package controller;

import dao.RenterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "FeedbackServlet", value = "/sendFeedback")
public class FeedbackServlet extends HttpServlet {
    private RenterDAO renterDAO;

    public void init() {
        renterDAO = new RenterDAO(); // Khởi tạo DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String feedbackText = request.getParameter("feedback");
        String tag = request.getParameter("tag");
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");

        if (accountId == null) {
            response.getWriter().write("{\"error\": \"User not logged in.\"}");
            return;
        }

        try {
            if ("owner".equals(tag)) {
                sendFeedbackToOwner(accountId, feedbackText);
            } else if ("admin".equals(tag)) {
                sendFeedbackToAdmin(feedbackText, accountId);
            }
            response.getWriter().write("{\"success\": \"Feedback sent successfully.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"An error occurred while processing your request.\"}");
        }
    }

    private void sendFeedbackToOwner(int userId, String feedbackText) throws SQLException {
        System.out.println("Sending feedback to owner...");
        int ownerId = renterDAO.getOwnerIdByRenterId(userId);
        System.out.println("Owner ID: " + ownerId);
        renterDAO.saveFeedback(feedbackText, userId, ownerId, "Owner");  // Thêm tag "owner"
    }

    private void sendFeedbackToAdmin(String feedbackText, int fromUserId) throws SQLException {
        List<Integer> adminIds = renterDAO.getAllAdminIds();
        for (int adminId : adminIds) {
            renterDAO.saveFeedback(feedbackText, fromUserId, adminId, "Admin");  // Thêm tag "admin"
        }
    }
}
