--Los valores en new_debitos son ingresados en la tabla debito_transfer si es que ya no existen
--si los valores en new_debitos ya existen(identificados por su CBU) se actualizan sus datos y se mantiene el cod_pago
--la clave cod_pago es manejada con un trigger que autoincrementa el serial de metodo_pago y lo asigna a la tabla
--With crea una o varias tablas temporales usando alguna expresion para crearlas
--luego se ejecuta algun query
WITH new_debitos (BANCO,TITULAR,NRO_CUENTA,CBU) AS (
	VALUES 
	('Nacion','JuanCarlos',020,1122),
	('Galicia','RobertoCarlos',020,1123)
),
--actualizados contiene las tablas actualizadas con new_debitos
--aquellos valores que aun no estan en la tabla (su CBU no coincide) son omitidos
actualizados as (
	UPDATE ciudad.debito_transfer dt
	SET
	BANCO = nd.BANCO,
	TITULAR = nd.TITULAR,
	NRO_CUENTA = nd.NRO_CUENTA
	FROM new_debitos nd
	WHERE dt.CBU = nd.CBU 
	RETURNING dt.*
)

	
--inserta solo los que su cbu no estan en la tabla de actualizados
INSERT INTO ciudad.debito_transfer (BANCO,TITULAR,NRO_CUENTA,CBU)
	SELECT BANCO,TITULAR,NRO_CUENTA,CBU
	FROM new_debitos
	WHERE NOT EXISTS (SELECT 1
			FROM actualizados dtn
			WHERE dtn.CBU = new_debitos.CBU);









