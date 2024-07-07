package dao;

import context.DBcontext;
import model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class FeedbackDAO {
    public static List<Feedback> getFeedbackForOwner(int userId) throws Exception {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.feedback_text, f.create_date, f.account_id, f.motel_id, f.motel_room_id, a.fullname AS sender_name " +
                "FROM feedback f " +
                "JOIN accounts a ON f.account_id = a.account_id " +
                "JOIN motels m ON f.motel_id = m.motel_id " +
                "WHERE m.account_id = ?";

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setFeedbackText(rs.getString("feedback_text"));
                feedback.setCreateDate(rs.getTimestamp("create_date")); // Sử dụng getTimestamp để lấy cả thời gian
                feedback.setCreateDate(rs.getDate("create_date"));
                feedback.setAccountId(rs.getInt("account_id"));
                feedback.setToUserId(rs.getInt("to_user_id"));
                feedback.setTag(rs.getString("tag")); // Sử dụng cột 'tag' để biết feedback gửi tới vai trò nào

                feedbacks.add(feedback);
                feedback.setMotelId(rs.getInt("motel_id"));
                feedback.setMotelRoomId(rs.getInt("motel_room_id"));
                feedback.setSenderName(rs.getString("sender_name"));
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Thông báo lỗi nếu không thể truy xuất dữ liệu
        }
        return feedbacks;
    }
}
