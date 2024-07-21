package controller;

import dao.NotificationDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "NotificationServlet", urlPatterns = {"/sendNotification","/listNotifications"})
public class NotificationServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String message = request.getParameter("message");
        String motelRoomIdParam = request.getParameter("motelRoomId");

        NotificationDAO dao = new NotificationDAO();
        String status;
        try {
            if ("all".equals(motelRoomIdParam)) {
                dao.addNotificationToAllRooms(message);
                status = "Notification sent to all rooms successfully.";
            } else {
                int motelRoomId = Integer.parseInt(motelRoomIdParam);
                dao.addNotification(message, motelRoomId);
                status = "Notification sent successfully.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            status = "Failed to send notification: " + e.getMessage();
        }

        response.setContentType("text/plain");
        response.getWriter().write(status);
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        NotificationDAO dao = new NotificationDAO();
        try {
            List<Object[]> sentNotifications = dao.getSentNotifications();
            request.setAttribute("sentNotifications", sentNotifications);
            request.getRequestDispatcher("/notify.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to fetch sent notifications: " + e.getMessage());
            request.getRequestDispatcher("/notify.jsp").forward(request, response);
        }
    }
}
