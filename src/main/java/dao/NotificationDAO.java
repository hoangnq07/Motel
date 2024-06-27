package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import context.DBcontext;
import model.MotelRoom;
import model.Notification;

public class NotificationDAO {
    private DBcontext dbContext = new DBcontext();

    public List<Notification> getNotificationsByMotelRoomId(int motelRoomId, int renterId) {
        List<Notification> notifications = new ArrayList<>();
        try (Connection conn = dbContext.getConnection()) {
            String query = "SELECT message, create_date FROM notifications WHERE motel_room_id = ? AND renter_id = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setInt(1, motelRoomId);
            pstmt.setInt(2, renterId);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                String message = rs.getString("message");
                String createDate = rs.getString("create_date");
                notifications.add(new Notification(message, createDate));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public List<MotelRoom> getAllMotelRooms() {
        List<MotelRoom> motelRooms = new ArrayList<>();
        String sql = "SELECT motel_room_id, description FROM dbo.motel_room";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MotelRoom room = new MotelRoom();
                room.setMotelRoomId(rs.getInt("motel_room_id"));
                room.setDescription(rs.getString("description"));
                motelRooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return motelRooms;
    }

    public MotelRoom getRoomDescription(int motelRoomId) {
        MotelRoom room = null;
        String sql = "SELECT motel_room_id, description FROM dbo.motel_room WHERE motel_room_id = ?";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, motelRoomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    room = new MotelRoom();
                    room.setMotelRoomId(rs.getInt("motel_room_id"));
                    room.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return room;
    }
}
