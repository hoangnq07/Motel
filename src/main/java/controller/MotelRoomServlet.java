package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.MotelRoom;
import dao.MotelRoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/motel-rooms")
public class MotelRoomServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MotelRoomDAO motelRoomDAO;

    public void init() {
        try {
            motelRoomDAO = new MotelRoomDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null || action.equals("list")) {
            listRooms(request, response);
        } else if (action.equals("view")) {
            try {
                viewRoomDetails(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 9;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MotelRoom> rooms = motelRoomDAO.getAllMotelRooms(page, pageSize);
        int totalRooms = motelRoomDAO.getTotalMotelRooms();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        System.out.println("Rooms fetched in servlet: " + rooms.size());
        for (MotelRoom room : rooms) {
            System.out.println("Room ID: " + room.getMotelRoomId() + ", Description: " + room.getDescription());
        }

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/listRooms.jsp").forward(request, response);
    }

    private void viewRoomDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int roomId = Integer.parseInt(request.getParameter("motelRoomId"));
        MotelRoom room = motelRoomDAO.getMotelRoomById(roomId);
        request.setAttribute("room", room);
        request.getRequestDispatcher("/roomDetails.jsp").forward(request, response);
    }

}

