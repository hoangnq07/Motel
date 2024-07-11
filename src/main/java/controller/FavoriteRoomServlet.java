
package controller;

import Account.Account;
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
        Account acc =(Account) request.getSession().getAttribute("user");

        boolean result = false;
        try {
            MotelRoomDAO dao = new MotelRoomDAO();
            if ("add".equals(action)) {
                result = dao.addFavoriteRoom(acc.getAccountId(), roomId);
            } else if ("remove".equals(action)) {
                result = dao.removeFavoriteRoom(acc.getAccountId(), roomId);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + result + "}");
    }
}
