﻿--INSERCION DE UNA PERSONA 
INSERT INTO ciudad.persona (DNI,APELLIDO,NOMBRE,DIRECCION,COD_POSTAL,E_MAIL,FACEBOOK,TEL_FIJO,FECHA_NAC,EDAD)
VALUES (35279713,'Does','Jhon','Pueyrredon 2362',5800,'jhond@gmail.com',DEFAULT,DEFAULT,DATE '1990-10-10','25'),
		(32940352,'Perez','Juan','Maipu 2010',5800,'jp200@gmail.com',DEFAULT,DEFAULT,DATE '1990-10-03','25'),
		(22940352,'Tevez','Carlitos','Corrientes 39',5800,'tcarlosboca@gmail.com',DEFAULT,DEFAULT,DATE '1987-10-03','29'),
		(32940000,'Perez','Juan','Maipu 2010',5800,'jp200@gmail.com',DEFAULT,DEFAULT,DATE '1990-10-03','25'),
		(22940002,'Tevez','Carlitos','Corrientes 39',5800,'tcarlosboca@gmail.com',DEFAULT,DEFAULT,DATE '1987-10-03','29'),
		(32940003,'Perez','Juan','Maipu 2010',5800,'jp200@gmail.com',DEFAULT,DEFAULT,DATE '1990-10-03','25'),
		(22940004,'Tevez','Carlitos','Corrientes 39',5800,'tcarlosboca@gmail.com',DEFAULT,DEFAULT,DATE '1987-10-03','29');
----------------------------------------------------------------------------------------------------
--INSERCION DE VARIOS TELEFONOS PARA UNA PERSONA = 35279713 Jhon Does
INSERT INTO ciudad.Mtel_cel (NUMERO,DNI)
VALUES (155243594,35279713),
		(156432495,35279713);
----------------------------------------------------------------------------------------------------
--INSERCION DE UN DONANTE, DNI REFERENCIA A PERSONA
INSERT INTO ciudad.donante (DNI,OCUPACION,CUIL)
VALUES (35279713,'Estudiante','20-3527913-9'),
		(32940352,'Estudiante','20-32940352-9'),
		(22940004,'Estudiante','20-22940004-9'),
		(32940003,'Estudiante','20-32940003-9'),
		(22940002,'Estudiante','20-22940002-9'),
		(32940000,'Estudiante','20-32940000-9');
----------------------------------------------------------------------------------------------------
--INSERTAR UN CONTACTO
--DNI Referencia a persona
--ESTADO = ('Sin llamar','ERROR','En gestion','Adherido','Amigo','No acepta','Baja','Voluntario')
INSERT INTO ciudad.contacto (DNI,FECHA_PRIMER_CONTACTO,FECHA_ALTA,FECHA_BAJA,FECHA_RECHAZO,ESTADO)
VALUES (22940352,DEFAULT,DEFAULT,DEFAULT,DEFAULT,'En gestion');
----------------------------------------------------------------------------------------------------
--INSERTAR UN REFERENTE
--DNI referencia a Persona,Dni_conctato referencia a un contacto
INSERT INTO ciudad.referente (DNI,DNI_CONTACTO,COMENTARIO,RELACION)
VALUES (35279713,22940352,'Comentario','Conocido');
----------------------------------------------------------------------------------------------------
--INSERTAR EMPRESA
WITH nempresa (EMPRESA_T,TELEFONO) as (
	VALUES 
	('Naranja',4629345),
	('Visa',4740523),
	('Galicia',4740523),
	('Tucan',4740523)
),
actualizados as (
	UPDATE ciudad.empresa_tarjeta et
	SET
	TELEFONO = ne.TELEFONO
	FROM nempresa ne
	WHERE ne.EMPRESA_T = et.EMPRESA_T
	RETURNING et.*
)

INSERT INTO ciudad.empresa_tarjeta (EMPRESA_T,TELEFONO)
		SELECT * FROM nempresa
		WHERE NOT EXISTS (SELECT 1
				FROM actualizados net
				WHERE net.EMPRESA_T = nempresa.EMPRESA_T);

SELECT * FROM ciudad.empresa_tarjeta;
----------------------------------------------------------------------------------------------------
--INSERTAR TARJETA DEBITO
--Los valores en new_debitos son ingresados en la tabla debito_transfer si es que ya no existen
--si los valores en new_debitos ya existen(identificados por su CBU) se actualizan sus datos y se mantiene el cod_pago
--la clave cod_pago es manejada con un trigger que autoincrementa el serial de metodo_pago y lo asigna a la tabla
--With crea una o varias tablas temporales usando alguna expresion para crearlas
--luego se ejecuta algun query
WITH new_debitos (BANCO,TITULAR,T_CUENTA_DT,NRO_CUENTA,CBU) AS (
	VALUES
	('Nacion','Jhon Does','Corriente',102,2403),
	('Nacion','JuanCarlos','Corriente',020,1122),
	('Galicia','RobertoCarlos','Corriente',020,1123)
),
--actualizados contiene las tablas actualizadas con new_debitos
--aquellos valores que aun no estan en la tabla (su CBU no coincide) son omitidos
actualizados as (
	UPDATE ciudad.debito_transfer dt
	SET
	BANCO = nd.BANCO,
	TITULAR = nd.TITULAR,
	T_CUENTA_DT = nd.T_CUENTA_DT,
	NRO_CUENTA = nd.NRO_CUENTA
	FROM new_debitos nd
	WHERE dt.CBU = nd.CBU 
	RETURNING dt.*
)

	
--inserta solo los que su cbu no estan en la tabla de actualizados
INSERT INTO ciudad.debito_transfer (BANCO,TITULAR,T_CUENTA_DT,NRO_CUENTA,CBU)
	SELECT *
	FROM new_debitos
	WHERE NOT EXISTS (SELECT 1
			FROM actualizados dtn
			WHERE dtn.CBU = new_debitos.CBU);
-------------------------------------------------------------------------------------------------------------------------
--INSERTAR VALORES TARJETA CREDITO
--EMPRESA tiene que existir en la tabla ciudad.empresa_t, esta es la empresa de la tarjeta
WITH naportetarjeta (NRO,CODIGO_T,TITULAR,F_VENCIMIENTO,EMPRESA) AS (
	VALUES 
	(10224,603,'Juan',DATE '2016-05-24','Naranja'),
	(20342,203,'Pepe',DATE '2017-05-22','Naranja'),
	(00000,603,'000',DATE '2016-05-24','Galicia'),
	(00002,603,'002',DATE '2016-05-24','Tucan'),
	(00003,203,'003',DATE '2017-05-22','Naranja'),
	(00004,203,'004',DATE '2017-05-22','Galicia')
),
--actualizados contiene las tablas actualizadas con new_debitos
--aquellos valores que aun no estan en la tabla son omitidos
actualizados as (
	UPDATE ciudad.tcredito tc
	SET
	NRO = nt.NRO,
	CODIGO_T = nt.CODIGO_T,
	TITULAR = nt.TITULAR,
	F_VENCIMIENTO = nt.F_VENCIMIENTO,
	EMPRESA = nt.EMPRESA
	FROM naportetarjeta nt
	WHERE tc.NRO = nt.NRO 
	RETURNING tc.*
)

	
--inserta solo los que su NRO no estan en la tabla de actualizados
INSERT INTO ciudad.tcredito (NRO,CODIGO_T,TITULAR,F_VENCIMIENTO,EMPRESA)
	SELECT *
	FROM naportetarjeta
	WHERE NOT EXISTS (SELECT 1
			FROM actualizados dtn
			WHERE dtn.NRO = naportetarjeta.NRO);

select * from ciudad.tcredito;
----------------------------------------------------------------------------------------------------
--INSERCION DE UN PORGRAMA
INSERT INTO ciudad.programa (PROGRAMA,DESCRIPCION)
VALUES ('p1',''),
	('p0',''),
	('p2',''),
	('p3',''),
	('p4','');
----------------------------------------------------------------------------------------------------
--Frecuencia = {'Mensual','Semestral'}
--INSERTAR UN APORTE
INSERT INTO ciudad.aporte (DNI,NOMBRE_PROGRAMA,COD_PAGO,MONTO,FRECUENCIA)
VALUES
	(35279713,'p1',1,2000,'Mensual'),
	(22940002,'p1',2,1000,'Mensual'),
	(32940000,'p2',3,3000,'Semestral'),
	(22940002,'p2',4,1500,'Mensual'),
	(22940002,'p3',1,500,'Mensual'),
	(32940000,'p1',5,2000,'Mensual');
