package dao;

import model.MotelRoom;
import context.DBcontext;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class MotelRoomDAO {

    public List<MotelRoom> getAllMotelRooms() throws SQLException {
        List<MotelRoom> motelRooms = new ArrayList<>();
        String sql = "SELECT * FROM dbo.motel_room";
        try (Connection conn = DBcontext.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                MotelRoom room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setCreateDate(rs.getDate("create_date"));
                room.setDescriptions(rs.getString("descriptions"));
                room.setLength(rs.getDouble("length"));
                room.setWidth(rs.getDouble("width"));
                room.setStatus(rs.getBoolean("status"));
                room.setVideo(rs.getString("video"));
                room.setCategoryRoomId(rs.getInt("category_room_id"));
                room.setMotelId(rs.getInt("motel_id"));
                room.setRoomStatus(rs.getString("room_status"));
                motelRooms.add(room);
            }
        }
        return motelRooms;
    }

    public MotelRoom getMotelRoomById(int id) throws SQLException {
        MotelRoom room = null;
        String sql = "SELECT * FROM dbo.motel_room WHERE motel_room_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    room = new MotelRoom();
                    room.setMotelRoomId(rs.getInt("motel_room_id"));
                    room.setCreateDate(rs.getDate("create_date"));
                    room.setDescriptions(rs.getString("descriptions"));
                    room.setLength(rs.getDouble("length"));
                    room.setWidth(rs.getDouble("width"));
                    room.setStatus(rs.getBoolean("status"));
                    room.setVideo(rs.getString("video"));
                    room.setCategoryRoomId(rs.getInt("category_room_id"));
                    room.setMotelId(rs.getInt("motel_id"));
                    room.setRoomStatus(rs.getString("room_status"));
                }
            }
        }
        return room;
    }

    public void addMotelRoom(MotelRoom room) throws SQLException {
        String sql = "INSERT INTO dbo.motel_room (create_date, descriptions, length, width, status, video, category_room_id, motel_id, room_status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setString(2, room.getDescriptions());
            stmt.setDouble(3, room.getLength());
            stmt.setDouble(4, room.getWidth());
            stmt.setBoolean(5, room.isStatus());
            stmt.setString(6, room.getVideo());
            stmt.setInt(7, room.getCategoryRoomId());
            stmt.setInt(8, room.getMotelId());
            stmt.setString(9, room.getRoomStatus());
            stmt.executeUpdate();
        }
    }

    public void updateMotelRoom(MotelRoom room) throws SQLException {
        int motelRoomId = room.getMotelRoomId();
        if (isMotelRoomExists(motelRoomId)) {
            String sql = "UPDATE dbo.motel_room SET descriptions = ?, length = ?, width = ?, status = ?, video = ?, category_room_id = ?, motel_id = ?, room_status = ? WHERE motel_room_id = ?";
            try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setString(1, room.getDescriptions());
                stmt.setDouble(2, room.getLength());
                stmt.setDouble(3, room.getWidth());
                stmt.setBoolean(4, room.isStatus());
                stmt.setString(5, room.getVideo());
                stmt.setInt(6, room.getCategoryRoomId());
                stmt.setInt(7, room.getMotelId());
                stmt.setString(8, room.getRoomStatus());
                stmt.setInt(9, motelRoomId);
                stmt.executeUpdate();
            }
        } else {
            System.out.println("Motel room with id " + motelRoomId + " does not exist.");
        }
    }

    public void deleteMotelRoom(int motelRoomId) throws SQLException {
        if (isMotelRoomExists(motelRoomId)) {
            String sql = "DELETE FROM dbo.motel_room WHERE motel_room_id = ?";
            try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, motelRoomId);
                stmt.executeUpdate();
            }
        } else {
            System.out.println("Motel room with id " + motelRoomId + " does not exist.");
        }
    }
    private boolean isMotelRoomExists(int motelRoomId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM dbo.motel_room WHERE motel_room_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, motelRoomId);
            try (ResultSet rs = stmt.executeQuery()) {
                rs.next();
                return rs.getInt(1) > 0;
            }
        }
    }


}
