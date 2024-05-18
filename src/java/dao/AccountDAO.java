package dao;

import context.DBcontext;
import Account.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;

public class AccountDAO {
    private static final String LOGIN = "SELECT email,role from [User] where email=? and password=?";
    public static User searchUser(String email) {
        String QUERY = "SELECT * FROM accounts WHERE email=?";
        User user = null;

        try (Connection conn = DBcontext.getConnection()) {
            try (PreparedStatement pst = conn.prepareStatement(QUERY)) {
                pst.setString(1, email);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    user = new User(
                            rs.getInt("account_id"),
                            rs.getBoolean("active"),
                            rs.getString("avatar"),
                            rs.getString("citizen"),
                            rs.getDate("create_date"),
                            rs.getString("email"),
                            rs.getString("fullname"),
                            rs.getBoolean("gender"),
                            rs.getString("password"),
                            rs.getString("phone"),
                            rs.getString("role")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public static boolean authenticateUser(String email, String password) {
        User user = AccountDAO.searchUser(email);
        if (user == null) {
            return false;
        }
        return user.getPassword().equals(password);
    }

    public static boolean registerUser(User u) {
        String QUERY = "INSERT INTO accounts (active, email, password, gender, phone, role) "
                + "VALUES (1,?, ?, ?, ?, 'user')";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

            pst.setString(1, u.getEmail());
            pst.setString(2, u.getPassword());
            pst.setBoolean(3, u.isGender()); 
            pst.setString(4, u.getPhone());
            pst.execute();
            return true;
        } catch (Exception e) {
            e.printStackTrace(); 
            return false;
        }
    }

    public static boolean updateUser(User user) {
        String QUERY = "UPDATE Users SET Username=?, [Password]=?,Name=?, Email=?, Phone=?, [Address]=?, [Role]=?, IsActive=? WHERE UserID=?";
        try (Connection conn = DBcontext.getConnection()) {
            try (PreparedStatement pst = conn.prepareStatement(QUERY)) {

                int rowsAffected = pst.executeUpdate();
                return rowsAffected > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static void main(String[] args) {
//        listUsers().forEach(p -> System.out.println(p));
//        System.out.println(searchUser("admin2@gmail.com"));
        System.out.println(registerUser(new User("nguyenhoang@gmail.com", "123456", true, "012345678")));
    }
}
