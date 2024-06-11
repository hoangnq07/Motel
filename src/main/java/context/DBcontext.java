
package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBcontext {
    public static Connection getConnection() throws SQLException {
        String jdbcUrl = "jdbc:sqlserver://Localhost:1433;databaseName=motel6";
        String username = "sa";
        String password = "Bao021203";

        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new SQLException("Database driver not found");
        }
        return DriverManager.getConnection(jdbcUrl, username, password);
    }
    
    public static void main(String[] args) {
        try(Connection con= getConnection()) {
            if(con!=null)
            System.out.println("Connect success");
            else
            System.out.println("Connect fail");
            
        } catch (Exception e) {
        }
    }
}
