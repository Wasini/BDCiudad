/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author grazini
 */
import java.sql.*;
import java.io.*;

public class SinConnection {
    //constructor de la clase privado, para que no pueda ser accedido
    private SinConnection () {};
    
    //La instancia de la coneccion
    private static Connection instancia = null;
    
    
    private synchronized static void createInstance() {
        if (instancia == null) { 
            try {
                String driver = "org.postgresql.Driver";
		String url = "jdbc:postgresql://localhost:5432/ciudad";
		String username = "postgres";
		String password = "root";

		// carga el driver de la base de datos si no se cargo.
		 Class.forName(driver);
		
		// intenta establecer la conexión de red a la base de datos.
		instancia = DriverManager.getConnection(url, username, password);

		// set path al esquema "ciudad"
		String nameSchema = "ciudad";                        
		setSchema(nameSchema,instancia);
            }
            catch(ClassNotFoundException cnfe) {
      		System.err.println("Error loading driver: " + cnfe);
            } catch(SQLException sqle) {
    		sqle.printStackTrace();
      		System.err.println("Error connecting: " + sqle);
            }
        }
       }
    private static void setSchema(String nameSchema,Connection conn) throws SQLException {
        PreparedStatement statementIn = conn.prepareStatement("SET search_path TO "+nameSchema);
        statementIn.execute();
    }

    public static Connection getInstance() {
        if (instancia == null) createInstance();
        return instancia;
    }
    
}
