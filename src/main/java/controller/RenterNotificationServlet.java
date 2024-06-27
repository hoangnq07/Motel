//package controller;
//
//import java.io.IOException;
//import java.util.List;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//@WebServlet("/renterNotifications")
//public class RenterNotificationServlet extends HttpServlet {
//    private static final long serialVersionUID = 1L;
//
//    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
//        HttpSession session = request.getSession();
//        int userId = (int) session.getAttribute("userId");
//
//        List<Notification> notifications = NotificationDAO.getNotificationsByUserId(userId);
//        request.setAttribute("notifications", notifications);
//        request.getRequestDispatcher("renterNotifications.jsp").forward(request, response);
//    }
//}
