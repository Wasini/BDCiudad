
WITH nempresa (EMPRESA_T,TELEFONO) as (
	VALUES 
	('Naranja',4629345),
	('Visa',4740523)
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