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
import java.util.HashMap;
import java.util.List;
import java.util.Map;

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

    private void listPendingRooms(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int page = 1;
        int pageSize = 10;  // Set page size or retrieve from a configuration or request parameter
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        List<MotelRoom> rooms = motelRoomDAO.getRoomsByStatus("pending", page, pageSize);
        int totalRooms = motelRoomDAO.getCountByStatus("pending");
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // Create a JSON object to hold the rooms and pagination info
        Map<String, Object> result = new HashMap<>();
        result.put("rooms", rooms);
        result.put("currentPage", page);
        result.put("totalPages", totalPages);

        response.getWriter().write(gson.toJson(result));
    }

    static class StatusResponse {
        private final boolean success;

        public StatusResponse(boolean success) {
            this.success = success;
        }
    }
}
