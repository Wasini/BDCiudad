/** Clase para eliminar un Donante **/
import java.sql.*;
import java.io.*;
import java.util.Scanner;

public class deleteDonante{
	
	//Instancia de la coneccion
	public static Connection connection = SinConnection.getInstance();

	//Metodo que retorna verdadero si el donante existe en la base de datos
	public static boolean existDonante(int dni_don)throws ClassNotFoundException, SQLException {
		String queryOut = "SELECT DISTINCT dni FROM donante WHERE dni = "+dni_don;
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(queryOut);
		boolean exists = resultSet.next();
		return exists;
	}	
	//Pregunta si el donante existe en la base de datos, entonces lo elimina, de otro modo notifica que no estaba cargado
	public static void deleteDon()throws ClassNotFoundException, SQLException, InvalidDataException {
		System.out.println("Inserte el dni del donante a eliminar");
		Scanner num = new Scanner(System.in);
		int dni_donante = num.nextInt();
		System.out.println(existDonante(dni_donante));
		if (existDonante(dni_donante)){
			String query = "DELETE FROM donante WHERE dni = "+dni_donante;
			Statement statement = connection.createStatement();
			statement.executeUpdate(query);
			System.out.println("Donante ELIMINADO con éxito");
		}else{ 
			throw new InvalidDataException("DELETE DONANTE: El donante no existe en la base de datos");
		}
	}
}
