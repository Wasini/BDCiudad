/** Clase con metodos para insertar,eliminar,consultar datos a la base de datos ciudad sobre el esquema ciudad **/
import java.sql.*;
import java.io.*;
import java.util.Scanner;

public class Command{

	//Instancia de la coneccion
	public static Connection connection = SinConnection.getInstance();
	//Metodo que retorna true si el dni de un padrino ya existe en la tabla elegida
	public static boolean existsPersonaOnTable(int dni_persona,String tableName)throws ClassNotFoundException, SQLException {
		String query = "SELECT DISTINCT dni FROM "+tableName+" WHERE dni = "+dni_persona;
		Statement statement = connection.createStatement();
		ResultSet resultSet = statement.executeQuery(query);
		boolean exists = resultSet.next();
		return exists;
	}
        
    //inserta una persona en nuestra base de datos
    public static void insertPad(int dniAux, String apeAux, String nomAux, String dirAux, int c_posAux, String emailAux, String fbAux, 
								int tel_FijoAux, Date f_nacAux)throws SQLException, InvalidDataException, ClassNotFoundException {
			String query = "INSERT INTO persona (dni, apellido, nombre, direccion, cod_postal, e_mail, facebook, tel_fijo, fecha_nac, edad)"
							+ " VALUES (?,?,?,?,?,?,?,?,?,?)";
			PreparedStatement statement = connection.prepareStatement(query);
                        if (!existsPersonaOnTable(dniAux,"persona")){
			statement.setInt(1, dniAux);
  			statement.setString(2, apeAux);
  			statement.setString(3, nomAux);
  			statement.setString(4, dirAux);
  			statement.setInt(5, c_posAux);
  			statement.setString(6, emailAux);
  			statement.setString(7, fbAux);
  			statement.setInt(8, tel_FijoAux);
  			statement.setDate(9, f_nacAux);
  			statement.setInt(10, calcEdad(f_nacAux));
			statement.executeUpdate();
                        System.out.println("Persona añadida exitosamente.");
                        }
                       else{
			throw new InvalidDataException("INSERTAR PERSONA: Persona ya existente."); 
                        }
			
		
	}
	//Metodo para insertar un donante en la base de datos
	public static void insertDonante(int dniAux,String ocup,String cuil)throws ClassNotFoundException, SQLException, InvalidDataException {
		if (!existsPersonaOnTable(dniAux,"persona")){
                    throw new InvalidDataException("INSERTAR PADRINO: No se encontro una persona con el dni ingresado");
                }
                else {
                    if (!existsPersonaOnTable(dniAux,"donante")) {
			String query = "INSERT INTO donante (dni, ocupacion, cuil)"
							+ " VALUES (?,?,?)";
			PreparedStatement statement = connection.prepareStatement(query);
			statement.setInt(1, dniAux);
  			statement.setString(2, ocup);
  			statement.setString(3, cuil);
			statement.executeUpdate();
			System.out.println("Padrino añadido exitosamente.");
                    }else{
			throw new InvalidDataException("INSERT PADRINO: Padrino ya existente."); 
                    }
                }
        }
        
 
	//Pregunta si el donante existe en la base de datos, entonces lo elimina, de otro modo notifica que no estaba cargado
	public static void deleteDon()throws ClassNotFoundException, SQLException, InvalidDataException {
		System.out.println("Inserte el dni del donante a eliminar");
		Scanner num = new Scanner(System.in);
		int dni_donante = num.nextInt();
		if (existsPersonaOnTable(dni_donante,"donante")){
			String query = "DELETE FROM donante WHERE dni = "+dni_donante;
			Statement statement = connection.createStatement();
			statement.executeUpdate(query);
			System.out.println("Donante ELIMINADO con éxito");
		}else{ 
			throw new InvalidDataException("DELETE DONANTE: El donante no existe en la base de datos");
		}
	}
        
        /*listar los donantes con aportes mensuales y los medios de pago **/
        public static void showDonante()throws ClassNotFoundException, SQLException{
		
	}
        
        //Funcion auxiliar de la clase
        //Dado un Date calcula la edad con la fecha actual
	private static int calcEdad (Date fechaNac) {
            java.util.Date now = new java.util.Date();
            int currYear = now.getYear();
            int yearOfBirthDay = fechaNac.getYear();
            int ageWithBirthDay = (currYear - yearOfBirthDay);
            java.util.Date compareMonthDay = now;
            compareMonthDay.setYear(yearOfBirthDay);
            if (compareMonthDay.compareTo(fechaNac)>=0) {
                return ageWithBirthDay;
            }
            else {
                return (ageWithBirthDay-1);
            }
        }
}