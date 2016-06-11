--EMPRESA tiene que existir en la tabla ciudad.empresa_t
WITH naportetarjeta (NRO,CODIGO_T,TITULAR,F_VENCIMIENTO,EMPRESA) AS (
	VALUES 
	(10224,603,'Juan',DATE '2016-05-24','Naranja'),
	(20342,203,'Pepe',DATE '2017-05-22','Naranja')
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
