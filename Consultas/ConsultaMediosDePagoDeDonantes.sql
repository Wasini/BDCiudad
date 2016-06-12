WITH 
donanteConSuMPago (dni,cod_pago) AS (
	SELECT a.DNI, m.cod_pago
	FROM ciudad.aporte a,ciudad.medio_pago m
	WHERE (a.cod_pago = m.cod_pago AND a.frecuencia = 'Mensual')
),
donantesConTarjeta (dni,nro,titular,f_vencimiento,empresa) AS (
	SELECT d.DNI, t.nro, t.titular, t.f_vencimiento, t.empresa
	FROM donanteConSuMPago d, ciudad.tcredito t
	WHERE (d.cod_pago = t.cod_pago)
),
donantesConDebito (dni,banco,titular,t_cuenta_dt,nro_cuenta,cbu) AS (
	SELECT d.dni, t.banco, t.titular, t.t_cuenta_dt, t.cbu, t.nro_cuenta
	FROM donanteConSuMPago d, ciudad.debito_transfer t
	WHERE (d.cod_pago = t.cod_pago)
)
SELECT dni,titular,banco,t_cuenta_dt as tipo_cuenta_banco,nro_cuenta as nro_cuenta_banco,cbu,null as nro_tarjeta,null as f_vencimiento,null as empresa from donantesConDebito dd
UNION 
SELECT dni,titular,null as banco,null as tipo_cuenta_banco,null as nro_cuenta_banco, null as cbu,nro as nro_tarjeta,f_vencimiento,empresa from donantesConTarjeta dt 
