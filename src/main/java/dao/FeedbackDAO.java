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

    public List<Feedback> getFeedbacksForAdmin() {
        List<Feedback> feedbacks = new ArrayList<>();
        // Cập nhật câu truy vấn để lấy feedback với tag là 'Admin'
        String sql = "SELECT f.feedback_id, f.feedback_text, f.create_date, a.fullname as senderName " +
                "FROM feedback f " +
                "JOIN accounts a ON f.account_id = a.account_id " + // Người gửi
                "WHERE f.tag = 'Admin';"; // Chỉ lấy feedback có tag là 'Admin'

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setFeedbackText(rs.getString("feedback_text"));
                feedback.setCreateDate(rs.getTimestamp("create_date"));
                feedback.setSenderName(rs.getString("senderName")); // Tên người gửi
                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return feedbacks;
    }
    public int getOwnerIdByRenterId(int renterId) throws SQLException {
        String sql = "SELECT a.account_id FROM accounts a " +
                "JOIN motel_room mr ON a.account_id = mr.account_id " +
                "JOIN renter r ON r.motel_room_id = mr.motel_room_id " +
                "WHERE r.renter_id = ? AND a.role = 'owner'";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("account_id");
            } else {
                throw new SQLException("No owner found for renter with ID: " + renterId);
            }
        }
    }

    public void saveFeedback(String feedbackText, int fromUserId, Integer toUserId, String tag, Integer motelId, Integer motelRoomId) throws SQLException {
        String sql = "INSERT INTO feedback (feedback_text, account_id, to_user_id, tag, motel_id, motel_room_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, feedbackText);
            ps.setInt(2, fromUserId);
            if (toUserId != null) {
                ps.setInt(3, toUserId);
            } else {
                ps.setNull(3, java.sql.Types.INTEGER);
            }
            ps.setString(4, tag);
            if (motelId != null) {
                ps.setInt(5, motelId);
            } else {
                ps.setNull(5, java.sql.Types.INTEGER);
            }
            if (motelRoomId != null) {
                ps.setInt(6, motelRoomId);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
            throw e;
        }
    }


    public int[] getMotelDetailsByUserId(int userId) throws SQLException {
        String sql = "SELECT r.motel_room_id, mr.motel_id FROM renter r " +
                "JOIN motel_room mr ON r.motel_room_id = mr.motel_room_id " +
                "WHERE r.renter_id = ?";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new int[]{rs.getInt("motel_id"), rs.getInt("motel_room_id")};
            } else {
                throw new SQLException("No motel details found for user ID: " + userId);
            }
        }
    }

    public List<Integer> getAllAdminIds() throws SQLException {
        List<Integer> adminIds = new ArrayList<>();
        String sql = "SELECT account_id FROM accounts WHERE role = 'admin'";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                adminIds.add(rs.getInt("account_id"));
            }
        }
        return adminIds;
    }
    public List<Feedback> getFeedbackHistory(int userId) throws SQLException {
        List<Feedback> feedbacks = new ArrayList<>();
        String sql = "SELECT feedback_id, feedback_text, create_date, account_id, to_user_id, tag "
                + "FROM feedback "
                + "WHERE account_id = ?";  // Lấy feedback dựa trên accountId của người dùng hiện tại
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Feedback feedback = new Feedback();
                feedback.setFeedbackId(rs.getInt("feedback_id"));
                feedback.setFeedbackText(rs.getString("feedback_text"));
                feedback.setCreateDate(rs.getTimestamp("create_date")); // Sử dụng getTimestamp để lấy cả thời gian
                feedback.setAccountId(rs.getInt("account_id"));
                feedback.setToUserId(rs.getInt("to_user_id"));
                feedback.setTag(rs.getString("tag")); // Sử dụng cột 'tag' để biết feedback gửi tới vai trò nào

                feedbacks.add(feedback);
            }
        } catch (SQLException e) {
            e.printStackTrace();
            throw e; // Thông báo lỗi nếu không thể truy xuất dữ liệu
        }
        return feedbacks;
    }
    public static void main(String[] args) {
        FeedbackDAO feedbackDAO = new FeedbackDAO();

        try {
            int ownerId = 8; // Giả sử ID của owner mà bạn muốn kiểm tra là 13
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
