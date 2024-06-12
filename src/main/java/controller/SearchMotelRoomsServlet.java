package servlet;

import dao.MotelRoomDAO;
import model.MotelRoom;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/searchMotelRooms")
public class SearchMotelRoomsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MotelRoomDAO motelRoomDAO;

    @Override
    public void init() throws ServletException {
        try {
            motelRoomDAO = new MotelRoomDAO();
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String description = request.getParameter("description");
        String minPriceStr = request.getParameter("minPrice");
        String maxPriceStr = request.getParameter("maxPrice");
        String statusStr = request.getParameter("status");

        Double minPrice = null;
        Double maxPrice = null;
        Boolean status = null;

        if (minPriceStr != null && !minPriceStr.isEmpty()) {
            minPrice = Double.parseDouble(minPriceStr);
        }
        if (maxPriceStr != null && !maxPriceStr.isEmpty()) {
            maxPrice = Double.parseDouble(maxPriceStr);
        }
        if (statusStr != null && !statusStr.isEmpty()) {
            status = Boolean.parseBoolean(statusStr);
        }

        List<MotelRoom> motelRooms = motelRoomDAO.searchMotelRooms(description, minPrice, maxPrice, status);
        request.setAttribute("motelRooms", motelRooms);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/searchMotelRooms.jsp");
        dispatcher.forward(request, response);
    }
}
