package controller;

import dao.FeedbackDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import Account.Account;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "FeedbackServlet", value = "/sendFeedback")
public class FeedbackServlet extends HttpServlet {
    private FeedbackDAO feedbackDAO;

    public void init() {
        feedbackDAO = new FeedbackDAO(); // Khởi tạo DAO
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String feedbackText = request.getParameter("feedback");
        String tag = request.getParameter("tag");
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user == null) {
            response.getWriter().write("{\"error\": \"User not logged in.\"}");
            return;
        }

        Integer accountId = user.getAccountId();

        try {
            int[] motelDetails = feedbackDAO.getMotelDetailsByUserId(accountId);
            Integer motelId = motelDetails[0];
            Integer motelRoomId = motelDetails[1];

            if ("owner".equals(tag)) {
                sendFeedbackToOwner(accountId, feedbackText, motelId, motelRoomId);
            } else if ("admin".equals(tag)) {
                sendFeedbackToAdmin(feedbackText, accountId, motelId, motelRoomId);
            }
            response.getWriter().write("{\"success\": \"Feedback sent successfully.\"}");
        } catch (SQLException e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"An error occurred while processing your request.\"}");
        }
    }

    private void sendFeedbackToOwner(int userId, String feedbackText, Integer motelId, Integer motelRoomId) throws SQLException {
        System.out.println("Sending feedback to owner...");
        int ownerId = feedbackDAO.getOwnerIdByRenterId(userId);
        System.out.println("Owner ID: " + ownerId);
        feedbackDAO.saveFeedback(feedbackText, userId, ownerId, "Owner", motelId, motelRoomId);
    }

    private void sendFeedbackToAdmin(String feedbackText, int fromUserId, Integer motelId, Integer motelRoomId) throws SQLException {
        feedbackDAO.saveFeedback(feedbackText, fromUserId, null, "Admin", motelId, motelRoomId);
    }
}
