package dao;

import context.DBcontext;
import Account.User;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import org.mindrot.jbcrypt.BCrypt;

public class AccountDAO {

    private static final String LOGIN = "SELECT email,password,role from [accounts] where email=?";

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
                            "",
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

    public static User authenticateUser(String email, String password) {
        User user = null;

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(LOGIN)) {
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    String role = rs.getString("role");
                    user = new User(email, role);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public static boolean registerUser(User u) {
        String QUERY = "INSERT INTO accounts (active, email, password, 1, phone, role) VALUES (1,?, ?, ?, ?, 'user')";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

            // Mã hóa mật khẩu bằng BCrypt
            String hashedPassword = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());

            pst.setString(1, u.getEmail());
            pst.setString(2, hashedPassword); // Lưu mật khẩu đã mã hóa
            pst.setBoolean(3, u.isGender());
            pst.setString(4, u.getPhone());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public static boolean isEmailExist(String email) {
    String QUERY = "SELECT COUNT(*) FROM accounts WHERE email = ?";
    
    try (Connection conn = DBcontext.getConnection();
         PreparedStatement pst = conn.prepareStatement(QUERY)) {
        pst.setString(1, email);
        ResultSet rs = pst.executeQuery();
        
        if (rs.next()) {
            int count = rs.getInt(1);
            return count > 0;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    return false;
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
            System.out.println(authenticateUser("user@gmail.com", "123456"));
//        System.out.println(registerUser(new User("nguyenhoang1@gmail.com", "123456", true, "012345678")));
    }
}
