package dao;

import Account.Account;
import context.DBcontext;
import model.Feedback;
import model.RequestAuthority;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static context.DBcontext.getConnection;

public class AccountDAO {

    private static final String LOGIN = "SELECT email,password,role from [accounts] where email=?";

    public static Account searchUser(String email) {
        String QUERY = "SELECT * FROM accounts WHERE email=?";
        Account acc = null;

        try (Connection conn = getConnection()) {
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

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(LOGIN)) {
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

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
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

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

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
        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
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

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
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
        String QUERY = "UPDATE accounts SET fullname = ?, gender = ?, phone = ?, citizen_id = ?, avatar = ? ,dob =? WHERE account_id = ?";
        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setString(1, user.getFullname());
            pst.setBoolean(2, user.isGender());
            pst.setString(3, user.getPhone());
            pst.setString(4, user.getCitizenId());
            pst.setString(5, user.getAvatar());
            pst.setDate(6, new java.sql.Date(user.getDob().getTime()));
            pst.setInt(7, user.getAccountId());

            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public static boolean updatePassword(String email, String newPassword) {
        String QUERY = "UPDATE accounts SET password = ? WHERE email = ?";

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {

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


    public List<Account> getAllAccount() {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT * FROM accounts WHERE role != 'admin'";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setRole(rs.getString("role"));
                account.setPhone(rs.getString("phone"));
                account.setGender(rs.getBoolean("gender"));
                account.setFullname(rs.getString("fullname"));
                account.setEmail(rs.getString("email"));
                account.setDob(rs.getDate("dob"));
                account.setCreateDate(rs.getDate("create_date"));
                account.setCitizenId(rs.getString("citizen_id"));
                account.setAvatar(rs.getString("avatar"));
                account.setActive(rs.getBoolean("active"));
                accounts.add(account);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return accounts;
    }
    public boolean updateAccountStatus(int accountId, boolean isActive) {
        String sql = "UPDATE accounts SET active = ? WHERE account_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, accountId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public Account getAccountById(int accountId){
        String sql = "SELECT * FROM accounts WHERE account_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Account account = new Account();
                account.setAccountId(rs.getInt("account_id"));
                account.setRole(rs.getString("role"));
                account.setPhone(rs.getString("phone"));
                account.setGender(rs.getBoolean("gender"));
                account.setFullname(rs.getString("fullname"));
                account.setEmail(rs.getString("email"));
                account.setDob(rs.getDate("dob"));
                account.setCitizenId(rs.getString("citizen_id"));
                account.setActive(rs.getBoolean("active"));
                account.setPassword(rs.getString("password"));
                return account;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean addAccount(Account account) {
        String sql = "INSERT INTO accounts (role, phone, password,gender, citizen_id, dob, active,email,fullname) VALUES (?, ?, ?, ?, ?, ?,?,?,?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account.getRole());
            ps.setString(2, account.getPhone());
            String hashedPassword = BCrypt.hashpw(account.getPassword(), BCrypt.gensalt());
            ps.setString(3, hashedPassword);
            ps.setBoolean(4, account.isGender());
            ps.setString(5, account.getCitizenId());
            if(account.getDob() == null) {
                ps.setDate(6, null);
            } else
                ps.setDate(6, new java.sql.Date(account.getDob().getTime()));
            ps.setBoolean(7, account.isActive());
            ps.setString(8, account.getEmail());
            ps.setString(9, account.getFullname());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
        return true;
    }

    public boolean updateAccount(Account account) {
        // Check if the password needs to be updated
        boolean updatePassword = account.getPassword() != null && !account.getPassword().isEmpty();

        // Construct the SQL query dynamically based on whether the password needs to be updated
        String sql = "UPDATE accounts SET fullname = ?, gender = ?, phone = ?, citizen_id = ?, active = ?, email = ?, role= ?, dob = ?";
        if (updatePassword) {
            sql += ", password = ?";
        }
        sql += " WHERE account_id = ?";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, account.getFullname());
            ps.setBoolean(2, account.isGender());
            ps.setString(3, account.getPhone());
            ps.setString(4, account.getCitizenId());
            ps.setBoolean(5, account.isActive());
            ps.setString(6, account.getEmail());
            ps.setString(7, account.getRole());
            if(account.getDob() == null) {
                ps.setNull(8, java.sql.Types.DATE);
            } else {
                ps.setDate(8, new java.sql.Date(account.getDob().getTime()));
            }

            int index = 9;

            if (updatePassword) {
                // Hash the password if it's being updated
                String hashedPassword = BCrypt.hashpw(account.getPassword(), BCrypt.gensalt());
                ps.setString(index++, hashedPassword);
            }

            ps.setInt(index, account.getAccountId());

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<Account> searchAccounts(String searchTerm) throws SQLException {
        List<Account> accounts = new ArrayList<>();
        String sql = "SELECT DISTINCT a.* FROM accounts a " +
                "LEFT JOIN renter r ON a.account_id = r.renter_id " +
                "WHERE (a.fullname LIKE ? OR a.email LIKE ? OR a.phone LIKE ? OR a.citizen_id LIKE ?) " +
                "AND a.role = 'user' " +
                "AND (r.renter_id IS NULL OR r.check_out_date IS NOT NULL)";

        try (Connection conn = getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchPattern = "%" + searchTerm + "%";
            stmt.setString(1, searchPattern);
            stmt.setString(2, searchPattern);
            stmt.setString(3, searchPattern);
            stmt.setString(4, searchPattern);

            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Account account = new Account();
                    account.setAccountId(rs.getInt("account_id"));
                    account.setEmail(rs.getString("email"));
                    account.setPhone(rs.getString("phone"));
                    account.setCitizenId(rs.getString("citizen_id"));
                    account.setFullname(rs.getString("fullname"));
                    account.setRole(rs.getString("role"));

                    accounts.add(account);
                }
            }
        }

        return accounts;
    }
    public boolean submitRequestAuthority(int accountId, String descriptions, String imageIdCard, String imageDoc) {
        String QUERY = "INSERT INTO request_authority (createdate, descriptions, account_id, request_authority_status, imageidcard, imagedoc) " +
                "VALUES (GETDATE(), ?, ?, N'Chưa xử lý', ?, ?)";

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setString(1, descriptions);
            pst.setInt(2, accountId);
            pst.setString(3, imageIdCard);
            pst.setString(4, imageDoc);
            return pst.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public List<RequestAuthority> getRequestAuthoritiesByAccountId(int accountId) {
        List<RequestAuthority> requestAuthorities = new ArrayList<>();
        String QUERY = "SELECT * FROM request_authority WHERE account_id = ?";

        try (Connection conn = getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            pst.setInt(1, accountId);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                RequestAuthority requestAuthority = new RequestAuthority();
                requestAuthority.setRequestId(rs.getInt("request_authority_id"));
                requestAuthority.setAccountId(rs.getInt("account_id"));
                requestAuthority.setDescriptions(rs.getString("descriptions"));
                requestAuthority.setRequestAuthorityStatus(rs.getString("request_authority_status"));
                requestAuthority.setImageIdCard(rs.getString("imageidcard"));
                requestAuthority.setImageDoc(rs.getString("imagedoc"));

                requestAuthorities.add(requestAuthority);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requestAuthorities;
    }
    public List<RequestAuthority> getPendingRequestAuthorities() {
        List<RequestAuthority> requestAuthorities = new ArrayList<>();
        String QUERY = "SELECT [request_authority_id], [createdate], [descriptions], [account_id], " +
                "[request_authority_status], [imageidcard], [imagedoc] " +
                "FROM [motel7].[dbo].[request_authority] " +
                "WHERE [request_authority_status] = N'Chưa xử lý'";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement pst = conn.prepareStatement(QUERY)) {
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                RequestAuthority requestAuthority = new RequestAuthority();
                requestAuthority.setRequestId(rs.getInt("request_authority_id"));
                requestAuthority.setCreateDate(rs.getDate("createdate"));
                requestAuthority.setDescriptions(rs.getString("descriptions"));
                requestAuthority.setAccountId(rs.getInt("account_id"));
                requestAuthority.setRequestAuthorityStatus(rs.getString("request_authority_status"));
                requestAuthority.setImageIdCard(rs.getString("imageidcard"));
                requestAuthority.setImageDoc(rs.getString("imagedoc"));

                requestAuthorities.add(requestAuthority);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return requestAuthorities;
    }
    public boolean updateRoleAndStatus(int accountId) {
        String updateRoleQuery = "UPDATE accounts SET role = 'owner' WHERE account_id = ?";
        String updateStatusQuery = "UPDATE request_authority SET request_authority_status = N'Chấp nhận' WHERE account_id = ? AND TRIM(request_authority_status) = N'Chưa xử lý'";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement updateRolePst = conn.prepareStatement(updateRoleQuery);
             PreparedStatement updateStatusPst = conn.prepareStatement(updateStatusQuery)) {
            updateRolePst.setInt(1, accountId);
            updateStatusPst.setInt(1, accountId);

            int roleRowsUpdated = updateRolePst.executeUpdate();
            int statusRowsUpdated = updateStatusPst.executeUpdate();

            return roleRowsUpdated > 0 && statusRowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean rejectRequest(int requestId) {
        String rejectQuery = "UPDATE request_authority SET request_authority_status = N'Bị từ chối' WHERE request_authority_id = ? AND TRIM(request_authority_status) = N'Chưa xử lý'";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement rejectPst = conn.prepareStatement(rejectQuery)) {
            rejectPst.setInt(1, requestId);
            int rowsUpdated = rejectPst.executeUpdate();
            return rowsUpdated > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public Map<String, Integer> getAccountCountsByRole() {
        Map<String, Integer> roleCounts = new HashMap<>();
        String sql = "SELECT role, COUNT(*) AS role_count FROM accounts GROUP BY role";

        try (Connection conn = DBcontext.getConnection();
                PreparedStatement statement = conn.prepareStatement(sql);
             ResultSet resultSet = statement.executeQuery()) {

            while (resultSet.next()) {
                String role = resultSet.getString("role");
                int count = resultSet.getInt("role_count");
                roleCounts.put(role, count);
            }

        } catch (SQLException e) {
            e.printStackTrace();
            // Handle exception (e.g., log the error, rethrow, etc.)
        }

        return roleCounts;
    }
    }

