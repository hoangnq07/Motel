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
import java.util.List;

@WebServlet("/room-details")
public class RoomDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MotelRoomDAO motelRoomDAO;

    public RoomDetailsServlet() throws SQLException {
        super();
        motelRoomDAO = new MotelRoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String roomIdParam = request.getParameter("roomId");
        System.out.println("Received roomId: " + roomIdParam);

        if (roomIdParam != null) {
            try {
                int roomId = Integer.parseInt(roomIdParam);
                MotelRoom room = motelRoomDAO.getMotelRoomById(roomId);
                List<Renter> renters = renterDAO.getRentersByMotelRoom(roomId);

                System.out.println("Room retrieved: " + room);
                System.out.println("Renters retrieved: " + (renters != null ? renters.size() : "null"));

                if (room != null) {
                    request.setAttribute("room", room);
                    request.setAttribute("renters", renters);
                    request.getRequestDispatcher("/roomDetails.jsp").forward(request, response);
                } else {
                    System.out.println("Room not found for ID: " + roomId);
                    response.sendError(HttpServletResponse.SC_NOT_FOUND, "Room not found");
                }
            } catch (NumberFormatException e) {
                System.out.println("Invalid roomId: " + roomIdParam);
                response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid room ID");
            } catch (SQLException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database error");
            }
        } else {
            System.out.println("Missing roomId parameter");
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing room ID");
        }
    }
}