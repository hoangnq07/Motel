package controller;

import dao.MotelRoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MotelRoom;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/room-details")
public class RoomDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MotelRoomDAO motelRoomDAO;

    public RoomDetailsServlet() throws SQLException {
        super();
        motelRoomDAO = new MotelRoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        MotelRoom room = motelRoomDAO.getMotelRoomById(roomId);

        if (room != null) {
            request.setAttribute("room", room);
            request.getRequestDispatcher("/roomDetails.jsp").forward(request, response);
        } else {

            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
        }
    }
}