package dao;

import context.DBcontext;
import model.Feedback;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static context.DBcontext.getConnection;

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
    public List<Feedback> getFeedbacksReceivedByOwner(int ownerId) throws SQLException, ClassNotFoundException {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT f.feedback_id, f.feedback_text, f.create_date, a.fullname as senderName, " +
                "m.name as motelName, mr.name as roomName " +
                "FROM feedback f " +
                "JOIN accounts a ON f.account_id = a.account_id " +
                "LEFT JOIN motels m ON f.motel_id = m.motel_id " +
                "LEFT JOIN motel_room mr ON f.motel_room_id = mr.motel_room_id " +
                "WHERE f.to_user_id = ? AND a.role != 'owner';";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Feedback feedback = new Feedback();
                    feedback.setFeedbackId(rs.getInt("feedback_id"));
                    feedback.setFeedbackText(rs.getString("feedback_text"));
                    feedback.setCreateDate(rs.getTimestamp("create_date"));
                    feedback.setSenderName(rs.getString("senderName"));
                    feedback.setMotelName(rs.getString("motelName"));
                    feedback.setRoomName(rs.getString("roomName"));
                    feedbacks.add(feedback);
                }
            }
        }
        return feedbacks;
    }


    public static void main(String[] args) {
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        try {
            int ownerId = 13; // Giả sử ID của owner mà bạn muốn kiểm tra là 13
            List<Feedback> feedbacks = feedbackDAO.getFeedbacksReceivedByOwner(ownerId);

            if (feedbacks.isEmpty()) {
                System.out.println("Không có feedback nào cho owner này.");
            } else {
                for (Feedback feedback : feedbacks) {
                    System.out.println("Feedback ID: " + feedback.getFeedbackId());
                    System.out.println("Người gửi: " + feedback.getSenderName());
                    System.out.println("Nội dung: " + feedback.getFeedbackText());
                    System.out.println("Ngày gửi: " + feedback.getCreateDate());
                    System.out.println("Nhà trọ: " + feedback.getMotelName());
                    System.out.println("Phòng: " + feedback.getRoomName());
                    System.out.println("------------------------------------");
                }
            }
        } catch (SQLException e) {
            System.err.println("SQL Error: " + e.getMessage());
        } catch (ClassNotFoundException e) {
            System.err.println("JDBC Driver không tìm thấy: " + e.getMessage());
        }
    }

}
