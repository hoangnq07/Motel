package dao;

import model.MotelRoom;
import context.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MotelRoomDAO {

    public List<MotelRoom> getAllMotelRooms() throws SQLException {
        List<MotelRoom> motelRooms = new ArrayList<>();
        String sql = "SELECT mr.motel_room_id, mr.descriptions, mr.length, mr.width, mr.status, cr.descriptions AS category_desc, m.descriptions AS motel_desc " +
                "FROM dbo.motel_room mr " +
                "INNER JOIN dbo.category_room cr ON mr.category_room_id = cr.category_room_id " +
                "INNER JOIN dbo.motels m ON mr.motel_id = m.motel_id";
        try (Connection conn = DBcontext.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                MotelRoom room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setDescriptions(rs.getString("descriptions"));
                room.setLength(rs.getDouble("length"));
                room.setWidth(rs.getDouble("width"));
                room.setStatus(rs.getBoolean("status"));
//                room.setCategoryDesc(rs.getString("category_desc"));
//                room.setMotelDesc(rs.getString("motel_desc"));
                motelRooms.add(room);
            }
        }
        return motelRooms;
    }

    public void addMotelRoom(MotelRoom room) throws SQLException {
        String sql = "INSERT INTO dbo.motel_room (create_date, descriptions, length, status, width, category_room_id, motel_id, room_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setString(2, room.getDescriptions());
            stmt.setDouble(3, room.getLength());
            stmt.setBoolean(4, room.isStatus());
            stmt.setDouble(5, room.getWidth());
            stmt.setInt(6, room.getCategoryRoomId());
            stmt.setInt(7, room.getMotelId());
            stmt.setString(8, room.getRoomStatus());
            stmt.executeUpdate();
        }
    }

    // Các phương thức khác như updateMotelRoom, deleteMotelRoom, ...
}