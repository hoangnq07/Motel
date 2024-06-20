package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import Account.Account;
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
        } else if (action.equals("create")) {
            showForm(request, response, new MotelRoom());
        } else if (action.equals("edit")) {
            try {
                showEditForm(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create".equals(action)) {
            createMotelRoom(request, response);
        } else if ("edit".equals(action)) {
            updateMotelRoom(request, response);
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
        room.setDescription(request.getParameter("description"));
        room.setLength(Double.parseDouble(request.getParameter("length")));
        room.setWidth(Double.parseDouble(request.getParameter("width")));
        room.setRoomStatus(Boolean.parseBoolean(request.getParameter("status")));
        room.setRoomPrice(Double.parseDouble(request.getParameter("roomPrice")));
        room.setWaterPrice(Double.parseDouble(request.getParameter("waterPrice")));
        room.setElectricityPrice(Double.parseDouble(request.getParameter("electricityPrice")));
        room.setWifiPrice(Double.parseDouble(request.getParameter("wifiPrice")));
//        room.setMotelId(Integer.parseInt(request.getParameter("motelId")));
        room.setMotelId(1);
        room.setCategoryRoomId(1);
        Account acc = (Account) request.getSession().getAttribute("user");
        room.setAccountId(acc.getAccountId());
        try {
            motelRoomDAO.addMotelRoom(room);
            response.sendRedirect("motel-rooms");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void updateMotelRoom(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MotelRoom room = new MotelRoom();
        room.setMotelRoomId(Integer.parseInt(request.getParameter("motelRoomId")));
        room.setDescription(request.getParameter("description"));
        room.setLength(Double.parseDouble(request.getParameter("length")));
        room.setWidth(Double.parseDouble(request.getParameter("width")));
        room.setRoomStatus(Boolean.parseBoolean(request.getParameter("status")));
        room.setMotelId(Integer.parseInt(request.getParameter("motelId")));

        try {
            motelRoomDAO.updateMotelRoom(room);
            response.sendRedirect("motel-rooms");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void deleteMotelRoom(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
        try {
            motelRoomDAO.deleteMotelRoom(motelRoomId);
            response.sendRedirect("motel-rooms");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }
}
