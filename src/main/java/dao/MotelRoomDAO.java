package dao;

import model.MotelRoom;
import context.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import Account.Account;

public class MotelRoomDAO {
    private Connection connection;

    public MotelRoomDAO() throws SQLException {
        connection = DBcontext.getConnection();
    }

    public List<MotelRoom> getAllMotelRooms(int page, int pageSize) {
        List<MotelRoom> rooms = new ArrayList<>();
        String query = "SELECT mr.*, m.detail_address, m.ward, m.district, m.province " +
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
                room.setProvince(rs.getString("province"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    //Get motel rooms by motel id
    public static List<MotelRoom> getMotelRoomsByMotelId(int motelId) {
        List<MotelRoom> rooms = new ArrayList<>();
        String query = "SELECT * FROM motel_room WHERE motel_id = ?";
        try {
            PreparedStatement ps =DBcontext.getConnection().prepareStatement(query);
            ps.setInt(1, motelId);
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
                room.setRoomStatus(rs.getBoolean("room_status"));
                room.setCategoryRoomId(rs.getInt("category_room_id"));
                room.setMotelId(rs.getInt("motel_id"));
                room.setAccountId(rs.getInt("account_id"));
                room.setImage(getImageByRoomId(rs.getInt("motel_room_id")));
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

    private static String getImageByRoomId(int roomId) {
        String query = "SELECT name FROM image WHERE motel_room_id = ?";
        try {
            PreparedStatement ps = DBcontext.getConnection().prepareStatement(query);
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

    public MotelRoom getMotelRoomById(int roomId) {
        String query = "SELECT mr.*, a.fullname, a.phone, m.detail_address, m.ward, m.district, m.city, m.province " +
                "FROM motel_room mr " +
                "JOIN accounts a ON mr.account_id = a.account_id " +
                "JOIN motels m ON mr.motel_id = m.motel_id " +
                "WHERE mr.motel_room_id = ?";
        try {
            PreparedStatement ps = connection.prepareStatement(query);
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                MotelRoom room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setDescription(rs.getString("descriptions"));
                room.setLength(rs.getDouble("length"));
                room.setWidth(rs.getDouble("width"));
                room.setRoomPrice(rs.getDouble("room_price"));
                room.setElectricityPrice(rs.getDouble("electricity_price"));
                room.setWaterPrice(rs.getDouble("water_price"));
                room.setWifiPrice(rs.getDouble("wifi_price"));
                room.setDetailAddress(rs.getString("detail_address"));
                room.setWard(rs.getString("ward"));
                room.setDistrict(rs.getString("district"));
                room.setCity(rs.getString("city"));
                room.setProvince(rs.getString("province"));
                room.setCategoryRoomId(rs.getInt("category_room_id"));
                room.setMotelId(rs.getInt("motel_id"));
                room.setRoomStatus(rs.getBoolean("room_status"));
                room.setAccountId(rs.getInt("account_id"));
                room.setAccountFullname(rs.getString("fullname"));
                room.setAccountPhone(rs.getString("phone"));
                room.setImage(getImageByRoomId(roomId));
                return room;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
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


    public List<MotelRoom> searchMotelRooms(String description, Double minPrice, Double maxPrice, Boolean status) {
        List<MotelRoom> rooms = new ArrayList<>();
        StringBuilder query = new StringBuilder("SELECT mr.*, m.detail_address, m.ward, m.district, m.province " +
                "FROM motel_room mr " +
                "JOIN motels m ON mr.motel_id = m.motel_id " +
                "WHERE 1=1");

        if (description != null && !description.isEmpty()) {
            query.append(" AND mr.descriptions LIKE ?");
        }
        if (minPrice != null) {
            query.append(" AND mr.room_price >= ?");
        }
        if (maxPrice != null) {
            query.append(" AND mr.room_price <= ?");
        }
        if (status != null) {
            query.append(" AND mr.room_status = ?");
        }

        try {
            PreparedStatement ps = connection.prepareStatement(query.toString());
            int paramIndex = 1;

            if (description != null && !description.isEmpty()) {
                ps.setString(paramIndex++, "%" + description + "%");
            }
            if (minPrice != null) {
                ps.setDouble(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                ps.setDouble(paramIndex++, maxPrice);
            }
            if (status != null) {
                ps.setBoolean(paramIndex++, status);
            }

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
                room.setProvince(rs.getString("province"));
                room.setRoomStatus(rs.getBoolean("room_status"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

}
