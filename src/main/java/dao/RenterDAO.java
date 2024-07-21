package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Account.Account;
import context.DBcontext;
import model.Feedback;
import model.Renter;
import java.util.logging.Logger;

public class RenterDAO {

    private static final Logger logger = Logger.getLogger(RenterDAO.class.getName());

    public boolean addRenter(Renter renter) throws SQLException {
        String sql = "INSERT INTO renter (renter_id, check_out_date, renter_date, motel_room_id) VALUES (?, ?, ?, ?)";
        logger.info("RenterDAO: Executing SQL: " + sql);

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renter.getRenterId());
            ps.setNull(2, java.sql.Types.DATE);  // check_out_date is null
            ps.setDate(3, new java.sql.Date(renter.getRenterDate().getTime()));
            ps.setInt(4, renter.getMotelRoomId());

            logger.info("RenterDAO: Prepared statement values: " +
                    "renter_id=" + renter.getRenterId() +
                    ", check_out_date=null" +
                    ", renter_date=" + renter.getRenterDate() +
                    ", motel_room_id=" + renter.getMotelRoomId());

            int rowsAffected = ps.executeUpdate();
            logger.info("RenterDAO: Rows affected: " + rowsAffected);
            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.severe("RenterDAO: SQL Exception: " + e.getMessage());
            e.printStackTrace();
            throw e;
        }
    }

    public static List<Renter> getAllRenters() {
        List<Renter> renters = new ArrayList<>();
        String sql = "SELECT a.fullname AS renter_name, a.email AS renter_email, rt.renter_date, mr.name AS room_name " +
                "FROM dbo.renter rt " +
                "JOIN dbo.motel_room mr ON rt.motel_room_id = mr.motel_room_id " +
                "JOIN dbo.accounts a ON rt.renter_id = a.account_id " +
                "ORDER BY mr.name";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql);
             ResultSet rs = pstmt.executeQuery()) {

            while (rs.next()) {
                String fullname = rs.getString("renter_name");
                String email = rs.getString("renter_email");
                String date = rs.getString("renter_date");
                String roomName = rs.getString("room_name");

                Renter renter = new Renter();
                renters.add(renter);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return renters;
    }
    public Renter getRenterById(int renterId) {
        Renter renter = null;
        String sql = "SELECT r.*, a.* FROM renter r " +
                "JOIN accounts a ON r.renter_id = a.account_id " +
                "WHERE r.renter_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Account account = extractAccountFromResultSet(rs);
                renter = extractRenterFromResultSet(rs, account);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return renter;
    }
    public void updateRenter(Renter renter) {
        String sql = "UPDATE renter SET change_room_date = ?, check_out_date = ?, renter_date = ?, motel_room_id = ? WHERE renter_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, new java.sql.Date(renter.getChangeRoomDate().getTime()));
            ps.setDate(2, new java.sql.Date(renter.getCheckOutDate().getTime()));
            ps.setDate(3, new java.sql.Date(renter.getRenterDate().getTime()));
            ps.setInt(4, renter.getMotelRoomId());
            ps.setInt(5, renter.getRenterId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    public boolean checkOut(int renterId) {
        String sql = "UPDATE renter SET check_out_date = GETDATE() WHERE renter_id = ? AND check_out_date IS NULL";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, renterId);
            int rowsAffected = ps.executeUpdate();

            return rowsAffected > 0;
        } catch (SQLException e) {
            logger.severe("Error updating renter check-out date: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    public int countRemainingRenters(int motelRoomId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM renter WHERE motel_room_id = ? AND check_out_date IS NULL";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, motelRoomId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }


    private Account extractAccountFromResultSet(ResultSet rs) throws SQLException {
        Account account = new Account();
        account.setAccountId(rs.getInt("account_id"));
        account.setActive(rs.getBoolean("active"));
        account.setAvatar(rs.getString("avatar"));
        account.setCitizenId(rs.getString("citizen_id"));
        account.setCreateDate(rs.getDate("create_date"));
        account.setDob(rs.getDate("dob"));
        account.setEmail(rs.getString("email"));
        account.setFullname(rs.getString("fullname"));
        account.setGender(rs.getBoolean("gender"));
        account.setPassword(rs.getString("password"));
        account.setPhone(rs.getString("phone"));
        account.setRole(rs.getString("role"));
        return account;
    }

    private Renter extractRenterFromResultSet(ResultSet rs, Account account) throws SQLException {
        Renter renter = new Renter();
        renter.setRenterId(rs.getInt("renter_id"));
        renter.setChangeRoomDate(rs.getDate("change_room_date"));
        renter.setCheckOutDate(rs.getDate("check_out_date"));
        renter.setRenterDate(rs.getDate("renter_date"));
        renter.setMotelRoomId(rs.getInt("motel_room_id"));
        renter.setAccount(account);
        return renter;
    }


    public List<Renter> getCurrentTenants(int motelRoomId) {
        List<Renter> tenants = new ArrayList<>();
        String sql = "SELECT r.*, a.fullname, a.email, a.phone, a.gender, a.dob, a.citizen_id, a.avatar, a.active " +
                "FROM renter r JOIN accounts a ON r.renter_id = a.account_id " +
                "WHERE r.motel_room_id = ? AND r.check_out_date IS NULL";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, motelRoomId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                renter.setChangeRoomDate(rs.getDate("change_room_date"));
                renter.setCheckOutDate(rs.getDate("check_out_date"));
                renter.setRenterDate(rs.getDate("renter_date"));
                renter.setMotelRoomId(rs.getInt("motel_room_id"));

                Account account = new Account(
                        rs.getInt("renter_id"),
                        "user",
                        rs.getString("phone"),
                        "",
                        rs.getBoolean("gender"),
                        rs.getString("fullname"),
                        rs.getString("email"),
                        rs.getDate("dob"),
                        null,
                        rs.getString("citizen_id"),
                        rs.getString("avatar"),
                        rs.getBoolean("active")
                );

                renter.setAccount(account);
                tenants.add(renter);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return tenants;
    }

    public boolean isUserAlreadyRenting(int accountId) {
        String sql = "SELECT COUNT(*) FROM renter WHERE renter_id = ? AND (check_out_date IS NULL OR check_out_date > GETDATE())";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }
}