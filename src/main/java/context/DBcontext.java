
package context;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBcontext {
    public static Connection getConnection() throws SQLException {
        String jdbcUrl = "jdbc:mysql://103.97.126.29/nrmkbzgh_motel";
        String username = "nrmkbzgh_motel";
        String password = "123456789";
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
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