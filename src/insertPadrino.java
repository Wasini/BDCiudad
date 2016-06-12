/** Clase para insertar un padrino **/
import java.sql.*;
public class insertPadrino{

	//Instancia de la coneccion
	public static Connection connection = SinConnection.getInstance();

	//Metodo que retorna true si el padrino ya existe en la base de datos
	public static boolean existsPadrino(int dni_padrino)throws ClassNotFoundException, SQLException {
		String query = "SELECT DISTINCT dni FROM padrino WHERE dni = "+dni_padrino;
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(query);
		boolean exists = resultSet.next();
		return exists;
	}

	//Metodo para insertar un padrino en la base de datos
	public static void insertPadrino(int dniAux, String nombreAux, String apellidoAux, String fecha_nacAux, String direccionAux, int cod_postalAux, String e_mailAux, 
									 String facebookAux, int edadAux, int tel_fijoAux, int tel_celAux
									)throws ClassNotFoundException, SQLException, InvalidDataException {
		if (!existsPadrino(dniAux)){
			String query = "INSERT INTO persona (dni, nombre, apellido, fecha_nac, direccion, cod_postal, e_mail, facebook, edad, tel_fijo, tel_cel)"
							+ " VALUES ("+dniAux+", "+nombreAux+", "+apellidoAux+", "+fecha_nacAux+", "+direccionAux+", "+cod_postalAux+", "+e_mailAux+", "+facebookAux+", "+edadAux+", "+tel_fijoAux+", "+tel_celAux+")";
			Statement statement = connection.createStatement();
			statement.executeUpdate(query);

			query ="INSERT INTO padrino (dni) VALUES("+dniAux+")";
			statement = connection.createStatement();
			statement.executeUpdate(query);
			System.out.println("Padrino added.");
		}else{
			throw new InvalidDataException("INSERT PADRINO: padrino already exists."); 
		}
	}
	
}