package controller;

import context.DBcontext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/NotificationServlet")
public class NotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String message = request.getParameter("message");

        try (Connection conn = DBcontext.getConnection()) {
            String userId = getUserIdByEmail(email, conn);
            if (userId != null) {
                sendNotification(userId, message, conn);
                response.sendRedirect("owner.jsp?status=success");
            } else {
                response.sendRedirect("owner.jsp?status=error");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String getUserIdByEmail(String email, Connection conn) throws SQLException {
        String sql = "SELECT account_id FROM accounts WHERE email = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getString("account_id");
            }
        }
        return null;
    }

    private void sendNotification(String userId, String message, Connection conn) throws SQLException {
        String sql = "INSERT INTO notifications (user_id, message) VALUES (?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, userId);
            pstmt.setString(2, message);
            pstmt.executeUpdate();
        }
    }
}
