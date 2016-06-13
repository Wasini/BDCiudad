# BDCiudad
##Coneccion a la base de datos
Los datos para acceder a la base de datos se encuentran en la clase SinConnection
El usuario por defecto es postgres y la contraseña root, si se quiere conectar con otro usuario, cambie esos valores
En la Url para acceder a la conneccion por defecto toma como host a localhost con la base de datos ciudad
El nombre del esquema es ciudad (no cambiar)
A la hora de ejecutar el script para la creacion de las tablas usar una base de datos con el nombre ciudad, sino, se debe modificar el nombre de la base de datos en el Url por defecto al utilizado
##Clase Main
La clase main corre un menu por consola donde se elige la opcion que se desea.
Para ingresar padrino se ingresan los datos por consola
-Falla cuando
	* Se introduce un año/mes/dia con formato no valido
	* El donante ya existe
Para eliminar donante se solicita el dni del donante
-Falla cuando
	* El dni ingresado no corresponde a ningun donante en la base de datos

