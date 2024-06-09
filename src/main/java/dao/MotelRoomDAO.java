package dao;

import model.MotelRoom;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import context.DBcontext;
public class MotelRoomDAO {
    private Connection connection;

    public MotelRoomDAO() throws SQLException {
        connection = DBcontext.getConnection();
    }

    public List<MotelRoom> getAllMotelRooms(int page, int pageSize) {
        List<MotelRoom> rooms = new ArrayList<>();
        String query = "SELECT * FROM motel_room ORDER BY create_date DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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

    public MotelRoom getMotelRoomById(int roomId) {
        String query = "SELECT mr.*, a.fullname, a.phone " +
                "FROM motel_room mr " +
                "JOIN accounts a ON mr.account_id = a.account_id " +
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

}
