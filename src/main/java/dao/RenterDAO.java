package dao;
import java.util.Calendar;
import java.util.Date;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Account.Account;
import context.DBcontext;
import model.Renter;

public class RenterDAO {

    public List<Renter> getRentersByMotel(int motelId) {
        List<Renter> renters = new ArrayList<>();
        String sql = "SELECT r.*, a.* FROM renter r " +
                "JOIN accounts a ON r.renter_id = a.account_id " +
                "JOIN motel_room mr ON r.motel_room_id = mr.motel_room_id " +
                "WHERE mr.motel_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, motelId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Account account = extractAccountFromResultSet(rs);
                Renter renter = extractRenterFromResultSet(rs, account);
                renters.add(renter);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return renters;
    }

    public List<Renter> getRentersByMotelRoom(int motelRoomId) {
        List<Renter> renters = new ArrayList<>();
        String sql = "SELECT r.*, a.* FROM renter r " +
                "JOIN accounts a ON r.renter_id = a.account_id " +
                "WHERE r.motel_room_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, motelRoomId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Account account = extractAccountFromResultSet(rs);
                Renter renter = extractRenterFromResultSet(rs, account);
                renters.add(renter);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return renters;
    }

    public void addRenter(Renter renter) {
        String sql = "INSERT INTO renter (renter_id, check_out_date, renter_date, motel_room_id) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renter.getRenterId());
            ps.setDate(2, new java.sql.Date(renter.getCheckOutDate().getTime()));
            ps.setDate(3, new java.sql.Date(renter.getRenterDate().getTime()));
            ps.setInt(4, renter.getMotelRoomId());

            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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

    public void deleteRenter(int renterId) {
        String sql = "DELETE FROM renter WHERE renter_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
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
}
