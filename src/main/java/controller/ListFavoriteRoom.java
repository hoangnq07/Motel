package controller;

import dao.MotelRoomDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.MotelRoom;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "ListFavoriteRoom", value = "/favorite-rooms")
    public class ListFavoriteRoom extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int accountId = (Integer) request.getSession().getAttribute("accountId");

        try {
            MotelRoomDAO dao = new MotelRoomDAO();
            List<MotelRoom> favoriteRooms = dao.getFavoriteRooms(accountId);
            request.setAttribute("favoriteRooms", favoriteRooms);
        } catch (SQLException e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/favorite-rooms.jsp").forward(request, response);
    }
}
