/**Clase que modela el menu de interaccion con el usario **/
import java.sql.*;
import java.io.*;
import java.util.Scanner;

public class Menu{

	public static void showing()throws ClassNotFoundException, SQLException, InvalidDataException{
		int selec=0;
		while (selec!=4){
			System.out.println("Ingrese el numero de la operacion a realizar");
			System.out.println("1) Insertar un padrino.");
			System.out.println("2) Eliminar un donante.");
			System.out.println("3) Ver los donantes con su aporte mensual y su medio de pago.");
			System.out.println("4) Salir.");
			Scanner sc = new Scanner(System.in);
			selec = sc.nextInt();
			if(selec==1){
				Scanner sci = new Scanner(System.in);
				System.out.println("Ingrese el dni"+"\n");
				int dni = sci.nextInt();
				Scanner scs = new Scanner(System.in);
				System.out.println("Ingrese el apellido");
				String apellido = scs.nextLine();
				System.out.println("Ingrese el nombre");
				String nombre = scs.nextLine();
				System.out.println("Ingrese la direccion(Calle y altura)");
				String direccion = scs.nextLine();
				System.out.println("Ingrese el codigo postal");
				int c_postal = sci.nextInt();
				System.out.println("Ingrese el e-mail");
				String email = scs.nextLine();
				System.out.println("Ingrese el facebook");
				String facebook = scs.nextLine();
				System.out.println("Ingrese el telefono fijo");
				int tel_f = sci.nextInt();
				System.out.println("Ingrese el año de nacimiento");
				String year = scs.nextLine();
				System.out.println("Ingrese el mes de nacimiento");
				String month = scs.nextLine();
				System.out.println("Ingrese el dia");
				String day = scs.nextLine();
				java.sql.Date f_nac = java.sql.Date.valueOf(year+month+day);
				System.out.println("Ingrese la edad");
				int edad = sci.nextInt();
				insertPadrino.insertPad(dni,apellido,nombre,direccion,c_postal,email,facebook,tel_f,f_nac,edad);
			};
			if(selec==2){deleteDonante.deleteDon();};
			if(selec==3){listDonante.showDonante();};
			if((selec<=0)||(selec>4)){System.out.println("Opcion incorrecta");};
		}
	}
	

}