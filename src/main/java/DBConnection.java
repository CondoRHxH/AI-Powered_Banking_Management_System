import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	private static final String URL = "jdbc:mysql://localhost:3306/bank_app";
	private static final String USER = "root";
	private static final String PASSWORD = "";
	
	
	public static Connection getConnection() {
		Connection con = null;
		
		try {
			Class.forName("com.mysql.cj.jdbc.Driver");
			con = DriverManager.getConnection(URL,USER,PASSWORD);
			System.out.print("Connexion bien Etablie");
		}
		catch (ClassNotFoundException e) {
            System.out.println("Driver not found 💀");
        } catch(Exception e) {
			System.out.println("Connexion a echoue");
			e.printStackTrace();
		}
		return con;
	}
}
