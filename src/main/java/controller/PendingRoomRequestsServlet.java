package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.MotelRoom;
import dao.MotelRoomDAO;
import com.google.gson.Gson;

import java.io.IOException;
import java.util.List;

@WebServlet("/pending-room-requests")
public class PendingRoomRequestsServlet extends HttpServlet {
    private MotelRoomDAO motelRoomDAO;
    private Gson gson = new Gson();

    @Override
    public void init() {
        try {
            this.motelRoomDAO = new MotelRoomDAO();
        } catch (Exception e) {
            throw new RuntimeException("Initialization failed: " + e.getMessage());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("listPending".equals(action)) {
            listPendingRooms(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        boolean success = false;

        if ("approvePostRequest".equals(action)) {
            success = motelRoomDAO.updatePostRequestStatus(roomId, "approved");
        } else if ("rejectPostRequest".equals(action)) {
            success = motelRoomDAO.updatePostRequestStatus(roomId, "declined");
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(gson.toJson(new StatusResponse(success)));
    }

    private void listPendingRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int page = 1;
        int pageSize = 10;  // Set page size or retrieve from a configuration or request parameter
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MotelRoom> rooms = motelRoomDAO.getRoomsByStatus("pending", page, pageSize);
        int totalRooms = motelRoomDAO.getCountByStatus("pending");
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);

        // Debug print
        System.out.println("Rooms size: " + rooms.size());
        for (MotelRoom room : rooms) {
            System.out.println("Room ID: " + room.getMotelRoomId() + ", Description: " + room.getDescription());
        }

        request.getRequestDispatcher("/pendingRooms.jsp").forward(request, response);
    }

    static class StatusResponse {
        private final boolean success;

        public StatusResponse(boolean success) {
            this.success = success;
        }
    }
}
