/** Clase para obtener una coneccion con la base de datos **/
import java.sql.*;
import java.io.*;

public class Main {

	public static void main(String[] args) throws Exception{

		// intenta establecer la conexión de red a la base de datos.
    Connection connection = SinConnection.getInstance();

 		//Datos de un padrino a cargar
 		int dni = 36425882;
 		String name = new String("Ezequias");
 		String lastname = new String("Aramburu");
 		String adress = new String("Dinkeldein 1156");
 		int cod_postal = 5800;
 		String email = new String("ezequias.aramburu@gmail.com");
    String face = new String("Ezequias Aramburu");
    int tel_f = 4634777;
    java.sql.Date f_nac = java.sql.Date.valueOf("1992-01-14");
    int edad = 24;

    insertPadrino.insertPad(dni,name,lastname,adress,cod_postal,email,face,tel_f,f_nac,edad);
    //deleteDonante.deleteDon();

  	/**String queryOut = "SELECT * FROM  ciudad.persona";
  	PreparedStatement statementOut = connection.prepareStatement(queryOut);
		// Send query to database and store results.
    ResultSet resultSet = statementOut.executeQuery();

    // Print results.
    while(resultSet.next()) {
    // Quarter
    System.out.print("llegue3");	
    System.out.print(" DNI: " + resultSet.getInt(1));
    System.out.print("; Apellido: " + resultSet.getString(2));
    System.out.print("; Nombre: " + resultSet.getString(3)) ;
    System.out.print("; Direccion: " + resultSet.getString(4));
    System.out.print("; Codigo postal: " + resultSet.getString(5));
    System.out.print("; Email: " + resultSet.getString(6));
    System.out.print("; Facebook: " + resultSet.getString(7));
    System.out.print("; Telefono Fijo: " + resultSet.getString(8));
    System.out.print("; Fecha Nacimiento: " + resultSet.getString(9));
    System.out.print("; Edad: " + resultSet.getString(10));
	  System.out.print("\n   ");
	  System.out.print("\n   ");
   	}
   	**/
	}
}