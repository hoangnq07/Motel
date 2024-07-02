package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import Account.Account;
import com.google.gson.Gson;
import jakarta.servlet.annotation.MultipartConfig;
import model.MotelRoom;
import dao.MotelRoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/motel-rooms")
@MultipartConfig
public class MotelRoomServlet extends HttpServlet {
    private MotelRoomDAO motelRoomDAO;
    private Gson gson = new Gson();
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
        } else if (action.equals("create")) {
            showForm(request, response, new MotelRoom());
        } else if ("getRoomDetails".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            MotelRoom room = MotelRoomDAO.getMotelRoomById(id);
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            if (room != null) {
                String jsonResponse = gson.toJson(room);
                response.getWriter().write(jsonResponse);
            } else {
                sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Room not found");
            }
        } else if (action.equals("edit")) {
            try {
                showEditForm(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }else if(action.equals("delete")){
            deleteMotelRoom(request,response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
           createMotelRoom(request, response);
        } else if ("edit".equals(action)) {
            updateMotelRoom(request, response);
        } else if ("addFavorite".equals(action)) {
            toggleFavoriteRoom(request, response, true);
        } else if ("removeFavorite".equals(action)) {
            toggleFavoriteRoom(request, response, false);
        }else {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }
    private void toggleFavoriteRoom(HttpServletRequest request, HttpServletResponse response, boolean add) throws IOException {
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int accountId = (Integer) request.getSession().getAttribute("accountId"); // Giả sử ID người dùng đã được lưu trong session

        boolean result;
        if (add) {
            result = motelRoomDAO.addFavoriteRoom(accountId, roomId);
        } else {
            result = motelRoomDAO.removeFavoriteRoom(accountId, roomId);
        }
        response.setContentType("application/json");
        response.getWriter().write("{\"success\": " + result + "}");
    }

    private void listRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MotelRoomDAO motelRoomDAO;
        try {
            motelRoomDAO = new MotelRoomDAO();
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

        int page = 1;
        int pageSize = 9;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        Account acc = (Account) request.getSession().getAttribute("user");
        List<MotelRoom> rooms = motelRoomDAO.getAllMotelRooms(page, pageSize,acc);
        int totalRooms = motelRoomDAO.getTotalMotelRooms();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.getRequestDispatcher("/listRooms.jsp").forward(request, response);
    }


    private void showForm(HttpServletRequest request, HttpServletResponse response, MotelRoom room) throws ServletException, IOException {
        request.setAttribute("room", room);
        request.getRequestDispatcher("/room-form.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, SQLException {
        int id = Integer.parseInt(request.getParameter("id"));
        MotelRoom existingRoom = motelRoomDAO.getMotelRoomById(id);
        showForm(request, response, existingRoom);
    }

    private void createMotelRoom(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        MotelRoom room = new MotelRoom();
        int motelId = (Integer)(request.getSession().getAttribute("motelId"));
        room.setName(request.getParameter("name"));
        room.setDescription(request.getParameter("description"));
        room.setLength(Double.parseDouble(request.getParameter("length")));
        room.setWidth(Double.parseDouble(request.getParameter("width")));
        room.setRoomStatus(Boolean.parseBoolean(request.getParameter("status")));
        room.setRoomPrice(Double.parseDouble(request.getParameter("roomPrice")));
        room.setWaterPrice(Double.parseDouble(request.getParameter("waterPrice")));
        room.setElectricityPrice(Double.parseDouble(request.getParameter("electricityPrice")));
        room.setWifiPrice(Double.parseDouble(request.getParameter("wifiPrice")));
        room.setMotelId(motelId);
        room.setCategoryRoomId(Integer.parseInt(request.getParameter("category")));
        Account acc = (Account) request.getSession().getAttribute("user");
        room.setAccountId(acc.getAccountId());
        try {
            motelRoomDAO.addMotelRoom(room);
            response.sendRedirect("/Project/motel/manage");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private void updateMotelRoom(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MotelRoom room = new MotelRoom();
        int motelId = (Integer)(request.getSession().getAttribute("motelId"));
        room.setName(request.getParameter("name"));
        room.setMotelRoomId(Integer.parseInt(request.getParameter("id")));
        room.setDescription(request.getParameter("description"));
        room.setLength(Double.parseDouble(request.getParameter("length")));
        room.setWidth(Double.parseDouble(request.getParameter("width")));
        room.setRoomStatus(Boolean.parseBoolean(request.getParameter("status")));
        room.setCategoryRoomId(Integer.parseInt(request.getParameter("category")));
        room.setRoomPrice(Double.parseDouble(request.getParameter("roomPrice")));
        room.setWaterPrice(Double.parseDouble(request.getParameter("waterPrice")));
        room.setElectricityPrice(Double.parseDouble(request.getParameter("electricityPrice")));
        room.setWifiPrice(Double.parseDouble(request.getParameter("wifiPrice")));
        try {
            motelRoomDAO.updateMotelRoom(room);
            response.sendRedirect("/Project/motel/manage");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void deleteMotelRoom(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        try {
            motelRoomDAO.deleteMotelRoom(id);
            response.sendRedirect("/Project/motel/manage");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
    private void sendErrorResponse(HttpServletResponse response, int status, String message) throws IOException {
        response.setStatus(status);
        response.getWriter().write(gson.toJson(new ErrorResponse(message)));
    }

    // Inner class for error responses
    private static class ErrorResponse {
        private String error;
        ErrorResponse(String error) {
            this.error = error;
        }
    }
}
