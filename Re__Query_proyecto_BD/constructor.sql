DROP SCHEMA IF EXISTS ciudad CASCADE;
CREATE SCHEMA ciudad;

--Tabla persona(PK: DNI)
DROP TABLE IF EXISTS ciudad.persona CASCADE;
CREATE TABLE ciudad.persona(
DNI integer NOT NULL,
APELLIDO text NOT NULL,
NOMBRE text NOT NULL,
DIRECCION text default '',
COD_POSTAL integer NOT NULL,
E_MAIL text default '',
FACEBOOK text default '',
TEL_FIJO integer default NULL,
FECHA_NAC date NOT NULL, 
EDAD integer NOT NULL,
PRIMARY KEY (DNI) 
);

--Tabla para definir telefono multivaluado en persona (PK: NUMERO,DNI; FK: DNI referencia a persona)
DROP TABLE IF EXISTS ciudad.Mtel_cel;
CREATE TABLE ciudad.Mtel_cel(
NUMERO integer NOT NULL,
DNI integer NOT NULL, 
PRIMARY KEY (DNI,NUMERO),
CONSTRAINT FK_DNI_CEL FOREIGN KEY (DNI) REFERENCES ciudad.persona ON DELETE CASCADE ON UPDATE CASCADE
);

--Tipo estado
DROP TYPE IF EXISTS estado;
CREATE DOMAIN estado varchar(20)
DEFAULT 'Sin llamar'
NOT NULL
CHECK (VALUE IN('Sin llamar','ERROR','En gestion','Adherido','Amigo','No acepta','Baja','Voluntario'));


--Tabla contacto referencia a persona (PK:DNI;FK:DNI referencia a persona)
DROP TABLE IF EXISTS ciudad.contacto; 
CREATE TABLE ciudad.contacto(
DNI integer NOT NULL,
FECHA_PRIMER_CONTACTO date DEFAULT current_date, 
FECHA_ALTA date DEFAULT NULL,
FECHA_BAJA date DEFAULT NULL,
FECHA_RECHAZO date DEFAULT NULL,
ESTADO estado DEFAULT 'Sin llamar' NOT NULL,
PRIMARY KEY (DNI),
CONSTRAINT FK_DNI_PERSONA FOREIGN KEY (DNI) REFERENCES ciudad.persona ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ciudad.referente; 
CREATE TABLE ciudad.referente(
DNI integer NOT NULL,
DNI_CONTACTO integer NOT NULL,
COMENTARIO text default NULL,
RELACION text default NULL,
PRIMARY KEY (DNI),
CONSTRAINT FK_DNI_CONTACTO FOREIGN KEY (DNI_CONTACTO) REFERENCES ciudad.contacto ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_DNI_REFERENTE FOREIGN KEY (DNI) REFERENCES ciudad.persona ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ciudad.donante;
CREATE TABLE ciudad.donante(
DNI integer NOT NULL,
OCUPACION text default '',
CUIL text NOT NULL, --restringir dominio?
PRIMARY KEY (DNI),
CONSTRAINT FK_DNI_PERSONA FOREIGN KEY (DNI) REFERENCES ciudad.persona (DNI) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ciudad.programa;
CREATE TABLE ciudad.programa(
PROGRAMA text NOT NULL,
DESCRIPCION text DEFAULT '',
PRIMARY KEY (PROGRAMA)
);

--medio de pago identifica un medio de pago(debito/trasnferencia o credito)
--un medio de pago es referenciado solo por una tarjeta/cbu
--puede que un titular tenga 2 medios de pagos, cada uno con su ID correspondiente
--(PK: ID)
DROP TABLE IF EXISTS ciudad.medio_pago;
CREATE TABLE ciudad.medio_pago(
COD_PAGO SERIAL UNIQUE PRIMARY KEY
);

DROP TYPE IF EXISTS frecuencia;
CREATE DOMAIN frecuencia varchar (20)
NOT NULL
CHECK (VALUE IN('Mensual','Semestral'));

DROP TABLE IF EXISTS ciudad.aporte;
CREATE TABLE ciudad.aporte(
DNI integer NOT NULL,
NOMBRE_PROGRAMA text NOT NULL,
COD_PAGO integer,
MONTO integer NOT NULL,
FRECUENCIA frecuencia,
PRIMARY KEY (DNI,NOMBRE_PROGRAMA),
CONSTRAINT FK_DNI_DONANTE FOREIGN KEY (DNI) REFERENCES ciudad.donante ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FK_N_PROGRAMA FOREIGN KEY (NOMBRE_PROGRAMA) REFERENCES ciudad.programa ON DELETE RESTRICT ON UPDATE CASCADE,
CONSTRAINT FK_ID_MEDIOPAGO FOREIGN KEY (COD_PAGO) REFERENCES ciudad.medio_pago ON DELETE RESTRICT ON UPDATE CASCADE
);


DROP TABLE IF EXISTS ciudad.empresa_tarjeta;
CREATE TABLE ciudad.empresa_tarjeta (
EMPRESA_T text NOT NULL UNIQUE PRIMARY KEY,
TELEFONO integer DEFAULT NULL
);

DROP TYPE IF EXISTS tcuenta;
CREATE DOMAIN tcuenta varchar (20) 
NOT NULL
CHECK (VALUE IN('Corriente','Ahorro'));

DROP TABLE IF EXISTS ciudad.debito_transfer;
CREATE TABLE ciudad.debito_transfer (
BANCO text NOT NULL,
TITULAR text NOT NULL,
T_CUENTA_DT tcuenta NOT NULL,
NRO_CUENTA integer NOT NULL,
CBU integer UNIQUE NOT NULL,
COD_PAGO integer,
PRIMARY KEY (COD_PAGO,CBU)
--CONSTRAINT FK_ID_METODOPAGO FOREIGN KEY (COD_PAGO) REFERENCES ciudad.medio_pago ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ciudad.tcredito;
CREATE TABLE ciudad.tcredito (
COD_PAGO integer,
NRO integer UNIQUE NOT NULL,
CODIGO_T integer NOT NULL,
TITULAR text NOT NULL,
F_VENCIMIENTO date DEFAULT NULL,
EMPRESA text NOT NULL,
PRIMARY KEY (COD_PAGO,NRO),
CONSTRAINT FK_ID_MP FOREIGN KEY (COD_PAGO) REFERENCES ciudad.medio_pago ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT FK_EMPRESA FOREIGN KEY (EMPRESA) REFERENCES ciudad.empresa_tarjeta ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS ciudad.donante_eliminado;
CREATE TABLE ciudad.donante_eliminado(
DNI integer NOT NULL,
F_BAJA date NOT NULL DEFAULT current_date,
USUARIO text NOT NULL,
PRIMARY KEY (DNI)
);

CREATE OR REPLACE FUNCTION borrado_donante () RETURNS TRIGGER AS
'BEGIN
INSERT INTO ciudad.donante_eliminado (DNI,F_BAJA,USUARIO) VALUES (old.DNI,DEFAULT,current_user);
RETURN new;
END;'
LANGUAGE 'plpgsql';

DROP TRIGGER IF EXISTS trigger_borrado_donante ON ciudad.donante CASCADE;
CREATE TRIGGER trigger_borrado_donante AFTER DELETE ON ciudad.donante
FOR EACH ROW EXECUTE PROCEDURE borrado_donante();

--actualiza el valor serializado en medio_pago
--toma el valor corriente de la sequencia del valor serializado en medio_pago y lo agrega
--a la columna COD_PAGO de la tabla que dispara el trigger
CREATE OR REPLACE FUNCTION obtener_cod_pago () RETURNS TRIGGER AS
E'BEGIN
INSERT INTO ciudad.medio_pago VALUES (DEFAULT);
SELECT currval(pg_get_serial_sequence(\'ciudad.medio_pago\',\'cod_pago\')) INTO new.COD_PAGO ;
RETURN new;
END;'
LANGUAGE 'plpgsql';

--Antes de insertar en debio_transfer, ingresa un nuevo valor serializado,
--que referencia a un metodo_pago, para las filas que COD_PAGO es nulo
DROP TRIGGER IF EXISTS trigger_insertar_dt ON ciudad.debito_transfer CASCADE;
CREATE TRIGGER trigger_insertar_dt
BEFORE INSERT ON ciudad.debito_transfer
FOR EACH ROW
WHEN (new.COD_PAGO IS NULL)
EXECUTE PROCEDURE obtener_cod_pago();

--Antes de insertar en tcredito, ingresa un nuevo valor serializado,
--que referencia a un metodo_pago, para las filas que COD_PAGO es nulo
DROP TRIGGER IF EXISTS trigger_insertar_tcredito ON ciudad.tcredito CASCADE;
CREATE TRIGGER trigger_insertar_tcredito
BEFORE INSERT ON ciudad.tcredito
FOR EACH ROW
WHEN (new.COD_PAGO IS NULL)
EXECUTE PROCEDURE obtener_cod_pago();

