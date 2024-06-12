package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBcontext;
import model.Motel;
public class MotelDAO {
    public static List<Motel> getAllMotels() throws SQLException {
        List<Motel> motels = new ArrayList<>();
        String sql = "SELECT * FROM dbo.motels";
        try (Connection conn = DBcontext.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Motel motel = new Motel();
                motel.setMotelId(rs.getInt("motel_id"));
                motel.setCreateDate(rs.getDate("create_date"));
                motel.setDescriptions(rs.getString("descriptions"));
                motel.setDetailAddress(rs.getString("detail_address"));
                motel.setDistrict(rs.getString("district"));
                motel.setDistrictId(rs.getString("district_id"));
                motel.setImage(rs.getString("image"));
                motel.setProvince(rs.getString("province"));
                motel.setProvinceId(rs.getString("province_id"));
                motel.setStatus(rs.getBoolean("status"));
                motel.setWard(rs.getString("ward"));
                motel.setAccountId(rs.getInt("account_id"));
                motels.add(motel);
            }
        }
        return motels;
    }
    //Get motel by account id
    public static List<Motel> getMotelsByAccountId(int accountId) throws SQLException {
        List<Motel> motels = new ArrayList<>();
        String sql = "SELECT * FROM dbo.motels WHERE account_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, accountId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Motel motel = new Motel();
                    motel.setMotelId(rs.getInt("motel_id"));
                    motel.setCreateDate(rs.getDate("create_date"));
                    motel.setDescriptions(rs.getString("descriptions"));
                    motel.setDetailAddress(rs.getString("detail_address"));
                    motel.setDistrict(rs.getString("district"));
                    motel.setDistrictId(rs.getString("district_id"));
                    motel.setImage(rs.getString("image"));
                    motel.setProvince(rs.getString("province"));
                    motel.setProvinceId(rs.getString("province_id"));
                    motel.setStatus(rs.getBoolean("status"));
                    motel.setWard(rs.getString("ward"));
                    motel.setAccountId(rs.getInt("account_id"));
                    motels.add(motel);
                }
            }
        }
        return motels;
    }
    public void addMotel(Motel motel) throws SQLException {
        String sql = "INSERT INTO dbo.motels (create_date, descriptions, detail_address, district, district_id, image, province, province_id, status, ward, account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setString(2, motel.getDescriptions());
            stmt.setString(3, motel.getDetailAddress());
            stmt.setString(4, motel.getDistrict());
            stmt.setString(5, motel.getDistrictId());
            stmt.setString(6, motel.getImage());
            stmt.setString(7, motel.getProvince());
            stmt.setString(8, motel.getProvinceId());
            stmt.setBoolean(9, motel.isStatus());
            stmt.setString(10, motel.getWard());
            stmt.setInt(11, motel.getAccountId());
            stmt.executeUpdate();
        }
    }
    public void updateMotel(Motel motel) throws SQLException {
        String sql = "UPDATE dbo.motels SET descriptions = ?, detail_address = ?, district = ?, district_id = ?, image = ?, province = ?, province_id = ?, status = ?, ward = ?, account_id = ? WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, motel.getDescriptions());
            stmt.setString(2, motel.getDetailAddress());
            stmt.setString(3, motel.getDistrict());
            stmt.setString(4, motel.getDistrictId());
            stmt.setString(5, motel.getImage());
            stmt.setString(6, motel.getProvince());
            stmt.setString(7, motel.getProvinceId());
            stmt.setBoolean(8, motel.isStatus());
            stmt.setString(9, motel.getWard());
            stmt.setInt(10, motel.getAccountId());
            stmt.setInt(11, motel.getMotelId());
            stmt.executeUpdate();
        }
    }
    public void deleteMotel(int motelId) throws SQLException {
        String sql = "DELETE FROM dbo.motels WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, motelId);
            stmt.executeUpdate();
        }
    }
    public static void main(String[] args) {
        MotelDAO dao = new MotelDAO();
        try {
            // Chức năng Read
            System.out.println("Fetching all motels...");
            List<Motel> motels = dao.getMotelsByAccountId(2);
            for (Motel motel : motels) {
                System.out.println(motel);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }


}
