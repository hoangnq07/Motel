package controller;

import java.io.IOException;
import java.util.List;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;

@WebServlet("/viewNotifications")
public class ViewNotificationsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Integer accountId = (Integer) session.getAttribute("accountId");
        Integer motelRoomId = (Integer) session.getAttribute("motelRoomId");

        if (accountId != null && motelRoomId != null) {
            NotificationDAO notificationDAO = new NotificationDAO();
            List<Notification> notifications = notificationDAO.getNotificationsByMotelRoomId(motelRoomId, accountId);

            request.setAttribute("notifications", notifications);
            request.getRequestDispatcher("/viewNotifications.jsp").forward(request, response);
        } else {
            response.getWriter().println("Account ID and Motel Room ID are required.");
        }
    }
}
