--Insertar un valor a la tabla debito_transfer usando un CTE con un solo valor
with valor (BANCO,TITULAR,T_CUENTA_DT,NRO_CUENTA,CBU) as (
	SELECT 'Nacion','Juan','alguntipo',100,2016
)
INSERT INTO ciudad.debito_transfer (BANCO,TITULAR,T_CUENTA_DT,NRO_CUENTA,CBU)
SELECT BANCO,TITULAR,T_CUENTA_DT,NRO_CUENTA,CBU FROM valor v
WHERE NOT EXISTS ( SELECT 1 FROM ciudad.debito_transfer dt WHERE dt.CBU = v.CBU)



