/** Clase para insertar un padrino **/
import java.sql.*;
import java.io.*;

public class insertPadrino{

	//Instancia de la coneccion
	public static Connection connection = SinConnection.getInstance();

	//Metodo que retorna true si el padrino ya existe en la base de datos
	public static boolean existsPadrino(int dni_padrino)throws ClassNotFoundException, SQLException {
		String query = "SELECT DISTINCT dni FROM persona WHERE dni = "+dni_padrino;
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(query);
		boolean exists = resultSet.next();
		return exists;
	}

	//Metodo para insertar un padrino en la base de datos
	public static void insertPad(int dniAux, String apeAux, String nomAux, String dirAux, int c_posAux, String emailAux, String fbAux, 
								int tel_FijoAux, Date f_nacAux, int edadAux)throws ClassNotFoundException, SQLException, InvalidDataException {
		if (!existsPadrino(dniAux)){
			System.out.println("Llegue2");
			String query = "INSERT INTO persona (dni, apellido, nombre, direccion, cod_postal, e_mail, facebook, tel_fijo, fecha_nac, edad)"
							+ " VALUES (?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setInt(1, dniAux);
  			statement.setString(2, apeAux);
  			statement.setString(3, nomAux);
  			statement.setString(4, dirAux);
  			statement.setInt(5, c_posAux);
  			statement.setString(6, emailAux);
  			statement.setString(7, fbAux);
  			statement.setInt(8, tel_FijoAux);
  			statement.setDate(9, f_nacAux);
  			statement.setInt(10, edadAux);
			statement.executeUpdate();
			System.out.println("Padrino añadido exitosamente.");
		}else{
			throw new InvalidDataException("INSERT PADRINO: Padrino ya existente."); 
		}
	}
        
        public static void upsertPersona(int dniAux, String apeAux, String nomAux, String dirAux, int c_posAux, String emailAux, String fbAux,int tel_FijoAux, Date f_nacAux, int edadAux) {
            String $values = "(dni, apellido, nombre, direccion, cod_postal, e_mail, facebook, tel_fijo, fecha_nac, edad)";
            String $upsert = "UPDATE persona p "
                    + "SET apellido = nv.apellido,"
                    + "nombre = nv.nombre,"
                    + "direccion = nv.direccion,"
                    + "cod_postal = nv.cod_postal,"
                    + "e_mail = nv.e_mail,"
                    + "facebook = nv.facebook,"
                    + "tel_fijo = nv.tel_fijo,"
                    + "fecha_nac = nv.fecha_nac,"
                    + "edad = "+calcEdad(f_nacAux)+","
                    + "";
            String $insert = " ";
            String query = "(WITH nuevosValores "+$values+" AS (?,?,?,?,?,?,?,?,?,?), upsert AS ("+$upsert+" RETURNING *) "+$insert+" WHERE NOT EXISTS (SELECT * FROM upsert);";
        }
	private static int calcEdad (Date fechaNac) {
            int currYear = new java.util.Date().getYear();
            return (currYear - fechaNac.getYear());
        }
}