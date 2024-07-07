package controller;

import Account.Account;
import dao.NotificationDAO;
import model.Notification;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewNotificationsServlet", urlPatterns = {"/viewNotifications"})
public class ViewNotificationsServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int accountId = ((Account) request.getSession().getAttribute("user")).getAccountId();

        NotificationDAO dao = new NotificationDAO();
        try {
            List<Notification> notifications = dao.getNotificationsByAccountId(accountId);
            request.setAttribute("notifications", notifications);
            request.getRequestDispatcher("/viewNotifications.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }
}
