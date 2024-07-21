package controller;

import dao.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EditNotificationServlet", urlPatterns = {"/editNotification"})
public class EditNotificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int notificationId = Integer.parseInt(request.getParameter("notificationId"));
        String newMessage = request.getParameter("message");

        NotificationDAO dao = new NotificationDAO();
        String status;
        try {
            dao.updateNotification(notificationId, newMessage);
            status = "Notification updated successfully.";
        } catch (Exception e) {
            e.printStackTrace();
            status = "Failed to update notification: " + e.getMessage();
        }

        response.setContentType("text/plain");
        response.getWriter().write(status);
    }
}
