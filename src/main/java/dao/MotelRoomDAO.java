package dao;

import model.MotelRoom;
import context.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MotelRoomDAO {
    private Connection connection;

    public MotelRoomDAO() throws SQLException {
        connection = DBcontext.getConnection();
    }

    public List<MotelRoom> getAllMotelRooms(int page, int pageSize) {
        List<MotelRoom> rooms = new ArrayList<>();
        String query = "SELECT mr.*, m.detail_address, m.ward, m.district, m.city, m.province " +
                "FROM motel_room mr " +
                "JOIN motels m ON mr.motel_id = m.motel_id " +
                "ORDER BY mr.create_date DESC " +
                "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MotelRoom room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setDescription(rs.getString("descriptions"));
                room.setLength(rs.getDouble("length"));
                room.setWidth(rs.getDouble("width"));
                room.setRoomPrice(rs.getDouble("room_price"));
                room.setElectricityPrice(rs.getDouble("electricity_price"));
                room.setWaterPrice(rs.getDouble("water_price"));
                room.setWifiPrice(rs.getDouble("wifi_price"));
                room.setImage(getImageByRoomId(rs.getInt("motel_room_id")));
                room.setDetailAddress(rs.getString("detail_address"));
                room.setWard(rs.getString("ward"));
                room.setDistrict(rs.getString("district"));
                room.setCity(rs.getString("city"));
                room.setProvince(rs.getString("province"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    public int getTotalMotelRooms() {
        String query = "SELECT COUNT(*) FROM motel_room";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private String getImageByRoomId(int roomId) {
        String query = "SELECT name FROM image WHERE motel_room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getString("name");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public MotelRoom getMotelRoomById(int id) {
        MotelRoom room = null;
        String query = "SELECT mr.*, cr.descriptions as category, a.fullname, a.phone, m.detail_address, m.ward, m.district, m.city, m.province " +
                "FROM motel_room mr " +
                "JOIN category_room cr ON mr.category_room_id = cr.category_room_id " +
                "JOIN accounts a ON mr.account_id = a.account_id " +
                "JOIN motels m ON mr.motel_id = m.motel_id " +
                "WHERE mr.motel_room_id = ?";
        try (Connection con = DBcontext.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setDescription(rs.getString("descriptions"));
                room.setLength(rs.getDouble("length"));
                room.setWidth(rs.getDouble("width"));
                room.setRoomPrice(rs.getDouble("room_price"));
                room.setElectricityPrice(rs.getDouble("electricity_price"));
                room.setWaterPrice(rs.getDouble("water_price"));
                room.setWifiPrice(rs.getDouble("wifi_price"));
                room.setAccountFullname(rs.getString("fullname"));
                room.setAccountPhone(rs.getString("phone"));
                room.setDetailAddress(rs.getString("detail_address"));
                room.setWard(rs.getString("ward"));
                room.setDistrict(rs.getString("district"));
                room.setCity(rs.getString("city"));
                room.setProvince(rs.getString("province"));
                room.setCategory(rs.getString("category"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return room;
    }


    public void addMotelRoom(MotelRoom room) throws SQLException {
        String sql = "INSERT INTO dbo.motel_room (create_date, descriptions, length, width, room_price, electricity_price, water_price, wifi_price, room_status, category_room_id, motel_id, account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setString(2, room.getDescription());
            stmt.setDouble(3, room.getLength());
            stmt.setDouble(4, room.getWidth());
            stmt.setDouble(5, room.getRoomPrice());
            stmt.setDouble(6, room.getElectricityPrice());
            stmt.setDouble(7, room.getWaterPrice());
            stmt.setDouble(8, room.getWifiPrice());
            stmt.setBoolean(9, room.isRoomStatus());
            stmt.setInt(10, room.getCategoryRoomId());
            stmt.setInt(11, room.getMotelId());
            stmt.setInt(12, room.getAccountId());
            stmt.executeUpdate();
        }
    }

    public void updateMotelRoom(MotelRoom room) throws SQLException {
        int motelRoomId = room.getMotelRoomId();
        if (isMotelRoomExists(motelRoomId)) {
            String sql = "UPDATE dbo.motel_room SET descriptions = ?, length = ?, width = ?, room_price = ?, electricity_price = ?, water_price = ?, wifi_price = ?, room_status = ?, category_room_id = ?, motel_id = ?, account_id = ? WHERE motel_room_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setString(1, room.getDescription());
                stmt.setDouble(2, room.getLength());
                stmt.setDouble(3, room.getWidth());
                stmt.setDouble(4, room.getRoomPrice());
                stmt.setDouble(5, room.getElectricityPrice());
                stmt.setDouble(6, room.getWaterPrice());
                stmt.setDouble(7, room.getWifiPrice());
                stmt.setBoolean(8, room.isRoomStatus());
                stmt.setInt(9, room.getCategoryRoomId());
                stmt.setInt(10, room.getMotelId());
                stmt.setInt(11, room.getAccountId());
                stmt.setInt(12, motelRoomId);
                stmt.executeUpdate();
            }
        } else {
            System.out.println("Motel room with id " + motelRoomId + " does not exist.");
        }
    }

    public void deleteMotelRoom(int motelRoomId) throws SQLException {
        if (isMotelRoomExists(motelRoomId)) {
            String sql = "DELETE FROM dbo.motel_room WHERE motel_room_id = ?";
            try (PreparedStatement stmt = connection.prepareStatement(sql)) {
                stmt.setInt(1, motelRoomId);
                stmt.executeUpdate();
            }
        } else {
            System.out.println("Motel room with id " + motelRoomId + " does not exist.");
        }
    }

    private boolean isMotelRoomExists(int motelRoomId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.motel_room WHERE motel_room_id = ?";
        try (PreparedStatement stmt = connection.prepareStatement(sql)) {
            stmt.setInt(1, motelRoomId);
            try (ResultSet rs = stmt.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }

    public List<String> getImagesForRoom(int motelRoomId) {
        List<String> images = new ArrayList<>();
        String query = "SELECT name FROM dbo.image WHERE motel_room_id = ?";
        try (Connection con = DBcontext.getConnection();
             PreparedStatement ps = con.prepareStatement(query)) {
            ps.setInt(1, motelRoomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                images.add(rs.getString("name"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return images;
    }

    public static void main(String[] args) {
        MotelRoomDAO motelRoomDAO;
        try {
            motelRoomDAO = new MotelRoomDAO();
            int motelRoomId = 1; // Change this to the ID of the motel room you want to retrieve
            MotelRoom room = motelRoomDAO.getMotelRoomById(motelRoomId);
            if (room != null) {
                System.out.println("Motel Room Details:");
                System.out.println("ID: " + room.getMotelRoomId());
                System.out.println("Description: " + room.getDescription());
                System.out.println("Length: " + room.getLength());
                System.out.println("Width: " + room.getWidth());
                System.out.println("Room Price: " + room.getRoomPrice());
                System.out.println("Electricity Price: " + room.getElectricityPrice());
                System.out.println("Water Price: " + room.getWaterPrice());
                System.out.println("Wifi Price: " + room.getWifiPrice());
                System.out.println("Account Fullname: " + room.getAccountFullname());
                System.out.println("Account Phone: " + room.getAccountPhone());
                System.out.println("Detail Address: " + room.getDetailAddress());
                System.out.println("Ward: " + room.getWard());
                System.out.println("District: " + room.getDistrict());
                System.out.println("City: " + room.getCity());
                System.out.println("Province: " + room.getProvince());
                System.out.println("Category: " + room.getCategory());
            } else {
                System.out.println("Motel room with ID " + motelRoomId + " not found.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}
