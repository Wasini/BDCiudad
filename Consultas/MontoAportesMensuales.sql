SELECT nombre_programa, SUM(monto) AS Monto_total 
FROM ciudad.aporte
WHERE frecuencia = 'Mensual'
GROUP BY nombre_Programa
  
