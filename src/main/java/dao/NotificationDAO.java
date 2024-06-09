package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import context.DBcontext;

public class NotificationDAO {

    public static List<Notification> getNotificationsByUserId(int userId) {
        List<Notification> notifications = new ArrayList<>();
        String query = "SELECT * FROM notifications WHERE user_id = ?";

        try (Connection con = DBcontext.getConnection()) {
            PreparedStatement st = con.prepareStatement(query);
            st.setInt(1, userId);
            ResultSet rs = st.executeQuery();

            while (rs.next()) {
                Notification notification = new Notification();
                notification.setId(rs.getInt("notification_id"));
                notification.setUserId(rs.getInt("user_id"));
                notification.setMessage(rs.getString("message"));
                notification.setCreateDate(rs.getTimestamp("create_date"));
                notifications.add(notification);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return notifications;
    }

    public static void saveNotification(int userId, String message) {
        String query = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";

        try (Connection con = DBcontext.getConnection()) {
            PreparedStatement st = con.prepareStatement(query);
            st.setInt(1, userId);
            st.setString(2, message);
            st.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
