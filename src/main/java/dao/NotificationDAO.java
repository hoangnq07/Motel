package dao;

import context.DBcontext;
import model.Notification;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {
    public List<Notification> getNotificationsByAccountId(int accountId) throws Exception {
        List<Notification> list = new ArrayList<>();
        String query = "SELECT n.notification_id, n.message, n.create_date " +
                "FROM notifications n " +
                "JOIN account_notifications an ON n.notification_id = an.notification_id " +
                "WHERE an.account_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBcontext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, accountId);
            rs = ps.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification(rs.getInt("notification_id"),
                        rs.getString("message"), rs.getString("create_date"));
                list.add(notification);
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return list;
    }

    public void addNotification(String message, int motelRoomId) throws Exception {
        String queryNotification = "INSERT INTO notifications (message) VALUES (?)";
        String queryAccountNotifications = "INSERT INTO account_notifications (account_id, notification_id) " +
                "SELECT r.renter_id, n.notification_id " +
                "FROM renter r, notifications n " +
                "WHERE r.motel_room_id = ? AND n.message = ?";
        Connection conn = null;
        PreparedStatement psNotification = null;
        PreparedStatement psAccountNotifications = null;
        try {
            conn = new DBcontext().getConnection();
            conn.setAutoCommit(false);

            // Insert into notifications table
            psNotification = conn.prepareStatement(queryNotification);
            psNotification.setString(1, message);
            psNotification.executeUpdate();

            // Insert into account_notifications table
            psAccountNotifications = conn.prepareStatement(queryAccountNotifications);
            psAccountNotifications.setInt(1, motelRoomId);
            psAccountNotifications.setString(2, message);
            psAccountNotifications.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (psNotification != null) psNotification.close();
            if (psAccountNotifications != null) psAccountNotifications.close();
            if (conn != null) conn.close();
        }
    }
    //send notification to all room
    public void addNotificationToAllRooms(String message) throws Exception {
        String queryNotification = "INSERT INTO notifications (message) VALUES (?)";
        String queryAccountNotifications = "INSERT INTO account_notifications (account_id, notification_id) " +
                "SELECT r.renter_id, n.notification_id " +
                "FROM renter r, notifications n " +
                "WHERE n.message = ?";
        Connection conn = null;
        PreparedStatement psNotification = null;
        PreparedStatement psAccountNotifications = null;
        try {
            conn = new DBcontext().getConnection();
            conn.setAutoCommit(false);

            // Insert into notifications table
            psNotification = conn.prepareStatement(queryNotification);
            psNotification.setString(1, message);
            psNotification.executeUpdate();

            // Insert into account_notifications table for all renters
            psAccountNotifications = conn.prepareStatement(queryAccountNotifications);
            psAccountNotifications.setString(1, message);
            psAccountNotifications.executeUpdate();

            conn.commit();
        } catch (Exception e) {
            if (conn != null) conn.rollback();
            e.printStackTrace();
            throw e;
        } finally {
            if (psNotification != null) psNotification.close();
            if (psAccountNotifications != null) psAccountNotifications.close();
            if (conn != null) conn.close();
        }
    }

    //get notification sent
    public List<Object[]> getSentNotifications() throws Exception {
        List<Object[]> list = new ArrayList<>();
        String query = "SELECT n.notification_id, n.message, n.create_date, r.name AS room_name " +
                "FROM notifications n " +
                "JOIN account_notifications an ON n.notification_id = an.notification_id " +
                "JOIN renter rt ON an.account_id = rt.renter_id " +
                "JOIN motel_room r ON rt.motel_room_id = r.motel_room_id";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = new DBcontext().getConnection();
            ps = conn.prepareStatement(query);
            rs = ps.executeQuery();
            while (rs.next()) {
                Notification notification = new Notification(
                        rs.getInt("notification_id"),
                        rs.getString("message"),
                        rs.getString("create_date")
                );
                String roomName = rs.getString("room_name");
                int motelRoomId = rs.getInt("motel_room_id");
                list.add(new Object[]{notification, roomName,motelRoomId});
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
        return list;
    }
    //update notifi
    public void updateNotification(int notificationId, String newMessage) throws Exception {
        String query = "UPDATE notifications SET message = ? WHERE notification_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBcontext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setString(1, newMessage);
            ps.setInt(2, notificationId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
    //delete notify
    public void deleteNotification(int notificationId) throws Exception {
        String query = "DELETE FROM notifications WHERE notification_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = new DBcontext().getConnection();
            ps = conn.prepareStatement(query);
            ps.setInt(1, notificationId);
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
            throw e;
        } finally {
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        }
    }
}
