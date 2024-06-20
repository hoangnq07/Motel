package controller;

import dao.MotelRoomDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet(name = "FavoriteServlet", value = "/favorite")
public class FavoriteRoomServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int accountId = (Integer) request.getSession().getAttribute("accountId");

        boolean result = false;
        try {
            MotelRoomDAO dao = new MotelRoomDAO();
            if ("add".equals(action)) {
                result = dao.addFavoriteRoom(accountId, roomId);
            } else if ("remove".equals(action)) {
                result = dao.removeFavoriteRoom(accountId, roomId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + result + "}");
    }
}
