package controller;

import dao.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DeleteNotificationServlet", urlPatterns = {"/deleteNotification"})
public class DeleteNotificationServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));

        NotificationDAO dao = new NotificationDAO();
        String status;
        try {
            dao.deleteNotification(notificationId);
            status = "Notification deleted successfully.";
        } catch (Exception e) {
            e.printStackTrace();
            status = "Failed to delete notification: " + e.getMessage();
        }

        response.setContentType("text/plain");
        response.getWriter().write(status);
    }
}
