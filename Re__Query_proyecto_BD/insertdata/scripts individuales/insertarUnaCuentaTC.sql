--Insertar un valor a la tabla tcredito usando un CTE con un solo valor
--EMPRESA debe ser algun valor de la tabla ciudad.empresa
INSERT INTO ciudad.empresa_tarjeta SELECT 'Naranja' WHERE NOT EXISTS ( SELECT 1 FROM ciudad.empresa_tarjeta et WHERE et.EMPRESA_T = 'Naranja');
with valor (NRO,CODIGO_T,TITULAR,F_VENCIMIENTO,EMPRESA) as (
	SELECT 10224,603,'Juan',DATE '2016-05-24','Naranja'
)
INSERT INTO ciudad.tcredito (NRO,CODIGO_T,TITULAR,F_VENCIMIENTO,EMPRESA)
SELECT * FROM valor v
WHERE NOT EXISTS ( SELECT 1 FROM ciudad.tcredito tc WHERE tc.NRO = v.NRO);

SELECT * from ciudad.tcredito;

