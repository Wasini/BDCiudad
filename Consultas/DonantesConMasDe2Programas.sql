SELECT dni,count(nombre_programa) as cant_apo_prog
FROM ciudad.aporte
GROUP BY DNI
HAVING count(nombre_programa) > 2;