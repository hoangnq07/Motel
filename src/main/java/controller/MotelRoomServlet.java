package controller;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import Account.Account;
import com.google.gson.Gson;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;
import model.CategoryRoom;
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
        } else if (action.equals("create")) {
            showForm(request, response, new MotelRoom());
        } else if (action.equals("edit")) {
            try {
                showEditForm(request, response);
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        } else if (action.equals("delete")) {
            deleteMotelRoom(request, response);
        } else if ("search".equals(action) || "filter".equals(action)) {
            searchRooms(request, response);
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
        } else {
            sendErrorResponse(response, HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }


    private void getRoomDetails(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MotelRoom room = motelRoomDAO.getMotelRoomById(id);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        if (room != null) {
            String jsonResponse = gson.toJson(room);
            response.getWriter().write(jsonResponse);
        } else {
            sendErrorResponse(response, HttpServletResponse.SC_NOT_FOUND, "Room not found");
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
        int page = 1;
        int pageSize = 9;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }
        Account acc = (Account) request.getSession().getAttribute("user");
        List<MotelRoom> rooms = motelRoomDAO.getAllMotelRooms(page, pageSize, acc);
        int totalRooms = motelRoomDAO.getTotalMotelRooms();
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        List<CategoryRoom> categoryRooms = motelRoomDAO.getAllCategoryRooms();

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("categoryRooms", categoryRooms);
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
        int motelId = (Integer) (request.getSession().getAttribute("motelId"));
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
        // Xử lý các file ảnh
        List<String> imageNames = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                String fileName = getUniqueFileName(part.getSubmittedFileName());
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                part.write(uploadPath + File.separator + fileName);
                imageNames.add(fileName);
            }
        }
        room.setImage(imageNames);
        try {
            motelRoomDAO.addMotelRoom(room);
            response.sendRedirect("/Project/motel/manage");
        } catch (Exception ex) {
            throw new ServletException(ex);
        }
    }

    private String getUniqueFileName(String originalFileName) {
        return System.currentTimeMillis() + "_" + originalFileName;
    }

    private void updateMotelRoom(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        MotelRoom room = new MotelRoom();
        int motelId = (Integer) (request.getSession().getAttribute("motelId"));
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
        // Xử lý các file ảnh
        List<String> imageNames = new ArrayList<>();
        for (Part part : request.getParts()) {
            if ("images".equals(part.getName()) && part.getSize() > 0) {
                String fileName = getUniqueFileName(part.getSubmittedFileName());
                String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                part.write(uploadPath + File.separator + fileName);
                imageNames.add(fileName);
            }
        }
        room.setImage(imageNames);
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

    private void searchRooms(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String search = request.getParameter("search");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String town = request.getParameter("town");
        String category = request.getParameter("category");
        String minPrice = request.getParameter("minPrice");
        String maxPrice = request.getParameter("maxPrice");
        String minArea = request.getParameter("minArea");
        String maxArea = request.getParameter("maxArea");
        String sortPrice = request.getParameter("sortPrice");
        String sortArea = request.getParameter("sortArea");
        String sortDate = request.getParameter("sortDate");

        int page = 1;
        int pageSize = 9;
        if (request.getParameter("page") != null) {
            page = Integer.parseInt(request.getParameter("page"));
        }

        Account acc = (Account) request.getSession().getAttribute("user");
        List<MotelRoom> rooms = motelRoomDAO.searchRooms(search, province, district, town, category, minPrice, maxPrice, minArea, maxArea, sortPrice, sortArea, sortDate, page, pageSize, acc);
        int totalRooms = motelRoomDAO.getTotalSearchResults(search, province, district, town, category, minPrice, maxPrice, minArea, maxArea);
        int totalPages = (int) Math.ceil((double) totalRooms / pageSize);

        request.setAttribute("rooms", rooms);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("searchQuery", search);
        request.setAttribute("province", province);
        request.setAttribute("district", district);
        request.setAttribute("town", town);
        request.setAttribute("category", category);
        request.setAttribute("minPrice", minPrice);
        request.setAttribute("maxPrice", maxPrice);
        request.setAttribute("minArea", minArea);
        request.setAttribute("maxArea", maxArea);
        request.setAttribute("sortPrice", sortPrice);
        request.setAttribute("sortArea", sortArea);
        request.setAttribute("sortDate", sortDate);
        request.getRequestDispatcher("/listRooms.jsp").forward(request, response);
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