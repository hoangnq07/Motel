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
}
