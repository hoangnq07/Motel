package dao;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBcontext;
import model.Motel;
public class MotelDAO {

    private Connection connection;
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
                motel.setWardId(rs.getString("ward_id"));
                motel.setAccountId(rs.getInt("account_id"));
                motels.add(motel);
            }
        }
        return motels;
    }





    //Get motel by id
    public static Motel getMotelById(int motelId) throws SQLException {
        Motel motel = new Motel();
        String sql = "SELECT * FROM dbo.motels WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, motelId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    motel.setMotelId(rs.getInt("motel_id"));
                    motel.setName(rs.getString("name"));
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
                    motel.setWardId(rs.getString("ward_id"));
                    motel.setAccountId(rs.getInt("account_id"));
                }
            }
        }
        return motel;
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
                    motel.setName(rs.getString("name"));
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
                    motel.setWardId(rs.getString("ward_id"));
                    motel.setAccountId(rs.getInt("account_id"));
                    motels.add(motel);
                }
            }
        }
        return motels;
    }
    public static void addMotel(Motel motel) throws SQLException {
        String sql = "INSERT INTO dbo.motels (create_date,name, descriptions, detail_address, district, district_id, image, province, province_id, status, ward, ward_id, account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setString(2, motel.getName());
            stmt.setString(3, motel.getDescriptions());
            stmt.setString(4, motel.getDetailAddress());
            stmt.setString(5, motel.getDistrict());
            stmt.setString(6, motel.getDistrictId());
            stmt.setString(7, motel.getImage());
            stmt.setString(8, motel.getProvince());
            stmt.setString(9, motel.getProvinceId());
            stmt.setBoolean(10, motel.isStatus());
            stmt.setString(11, motel.getWard());
            stmt.setString(12, motel.getWardId());
            stmt.setInt(13, motel.getAccountId());
            stmt.executeUpdate();
        }
    }
    public static void  updateMotel(Motel motel) throws SQLException {
        String sql = "UPDATE dbo.motels SET descriptions = ?, detail_address = ?, district = ?, province = ?, status = ?, ward = ?, account_id = ? ,name =?,district_id =?, province_id=?,ward_id =? image = ? WHERE motel_id = ?";
        String sql1 = "UPDATE dbo.motels SET descriptions = ?, detail_address = ?, district = ?, province = ?, status = ?, ward = ?, account_id = ? ,name =?,district_id =?, province_id=?, ward_id =? WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection();) {
            PreparedStatement stmt = conn.prepareStatement(sql);
            if(motel.getImage()!=null) {
                stmt.setString(1, motel.getDescriptions());
                stmt.setString(2, motel.getDetailAddress());
                stmt.setString(3, motel.getDistrict());
                stmt.setString(4, motel.getProvince());
                stmt.setBoolean(5, motel.isStatus());
                stmt.setString(6, motel.getWard());
                stmt.setInt(7, motel.getAccountId());
                stmt.setString(8, motel.getName());
                stmt.setString(9, motel.getDistrictId());
                stmt.setString(10, motel.getProvinceId());
                stmt.setString(11, motel.getWardId());
                stmt.setString(12, motel.getImage());
                stmt.setInt(13, motel.getMotelId());
                }
                else{
                stmt = conn.prepareStatement(sql1);
                stmt.setString(1, motel.getDescriptions());
                stmt.setString(2, motel.getDetailAddress());
                stmt.setString(3, motel.getDistrict());
                stmt.setString(4, motel.getProvince());
                stmt.setBoolean(5, motel.isStatus());
                stmt.setString(6, motel.getWard());
                stmt.setInt(7, motel.getAccountId());
                stmt.setString(8, motel.getName());
                stmt.setString(9, motel.getDistrictId());
                stmt.setString(10, motel.getProvinceId());
                stmt.setString(11, motel.getWardId());
                stmt.setInt(12, motel.getMotelId());
                }
                stmt.executeUpdate();
            }
    }
    public static void deleteMotel(int motelId) throws SQLException {
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
