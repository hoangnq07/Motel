package dao;

import Account.Account;
import context.DBcontext;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AccountDAO {

    private static final String LOGIN = "SELECT email,password,role from [accounts] where email=?";

    public static Account searchUser(String email) {
        String QUERY = "SELECT * FROM accounts WHERE email=?";
        Account acc = null;

        try (Connection conn = DBcontext.getConnection()) {
            try (PreparedStatement pst = conn.prepareStatement(QUERY)) {
                pst.setString(1, email);
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    acc = new Account(
                            rs.getInt("account_id"),
                            rs.getString("role"),
                            rs.getString("phone"),
                            "",
                            rs.getBoolean("gender"),
                            rs.getString("fullname"),
                            rs.getString("email"),
                            rs.getDate("dob"),
                            rs.getDate("create_date"),
                            rs.getString("citizen_id"),
                            rs.getString("avatar"),
                            rs.getBoolean("active")
                    );
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return acc;
    }

    public static Account authenticateUser(String email, String password) {
        Account user = null;

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(LOGIN)) {
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");
                if (BCrypt.checkpw(password, hashedPassword)) {
                    String role = rs.getString("role");
                    user = new Account(email, role);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }

    public static int getAccountIdByEmail(String email) {
        int accountId = -1; // Default value indicating not found
        String QUERY = "SELECT account_id FROM accounts WHERE email = ?";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setString(1, email);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                accountId = rs.getInt("account_id");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return accountId;
    }

    public static boolean registerUser(Account u) {
        String QUERY = "INSERT INTO accounts (active, email, password, gender, phone, role) VALUES (1,?, ?, 1, ?, 'user')";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

            // Mã hóa mật khẩu bằng BCrypt
            String hashedPassword = BCrypt.hashpw(u.getPassword(), BCrypt.gensalt());

            pst.setString(1, u.getEmail());
            pst.setString(2, hashedPassword); // Lưu mật khẩu đã mã hóa
            pst.setString(3, u.getPhone());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean registerGoogle(String email, String name) {
        String QUERY = "INSERT INTO accounts (active, email,fullname, gender, role) VALUES (1,?,?,1, 'user')";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setString(1, email);
            pst.setString(2, name);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean isEmailExist(String email) {
        String QUERY = "SELECT COUNT(*) FROM accounts WHERE email = ?";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
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

    public static boolean updateUser(Account user) {
        String QUERY = "UPDATE accounts SET fullname = ?, gender = ?, phone = ?, citizen_id = ?, avatar = ? WHERE account_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setString(1, user.getFullname());
            pst.setBoolean(2, user.isGender());
            pst.setString(3, user.getPhone());
            pst.setString(4, user.getCitizenId());
            pst.setString(5, user.getAvatar());
            pst.setInt(6, user.getAccountId());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(String email, String newPassword) {
        String QUERY = "UPDATE accounts SET password = ? WHERE email = ?";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

            // Mã hóa mật khẩu mới bằng BCrypt
            String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());

            pst.setString(1, hashedPassword);
            pst.setString(2, email);

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    public  boolean addRenter(int accountId, int roomId) {
        String QUERY = "INSERT INTO [dbo].[renter]([account_id]\n" +
                "           ,[motel_room_id]) VALUES (?,?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setInt(1, accountId);
            pst.setInt(2, roomId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    public  boolean deleteAccount(int accountId) {
        String QUERY = "DELETE FROM [dbo].[accounts]\n" +
                "      WHERE account_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setInt(1, accountId);

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public static void main(String[] args) {
//        listUsers().forEach(p -> System.out.println(p));
//        System.out.println(searchUser("hoangnq417@gmail.com"));
//        System.out.println(authenticateUser("hoangnqde170007@fpt.edu.vn", "Hoangasd@123"));
//        System.out.println(registerUser(new User("nguyenhoang5@gmail.com", "123456", "012345678")));
    }
}
