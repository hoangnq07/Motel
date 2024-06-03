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
        motelRoomDAO = new MotelRoomDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<MotelRoom> motelRooms = motelRoomDAO.getAllMotelRooms();
            request.setAttribute("motelRooms", motelRooms);
            request.getRequestDispatcher("room-list.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createMotelRoom(request, response);
                break;
            case "update":
//                updateMotelRoom(request, response);
//                break;
            case "delete":
//                deleteMotelRoom(request, response);
//                break;
        }
    }

    private void createMotelRoom(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        MotelRoom room = new MotelRoom();
        room.setDescriptions(request.getParameter("descriptions"));
        room.setLength(Double.parseDouble(request.getParameter("length")));
        room.setWidth(Double.parseDouble(request.getParameter("width")));
        room.setStatus(Boolean.parseBoolean(request.getParameter("status")));
        room.setCategoryRoomId(Integer.parseInt(request.getParameter("categoryRoomId")));
        room.setMotelId(Integer.parseInt(request.getParameter("motelId")));
        room.setRoomStatus(request.getParameter("roomStatus"));

        try {
            motelRoomDAO.addMotelRoom(room);
            response.sendRedirect("motel-rooms");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    // Các phương thức khác như updateMotelRoom, deleteMotelRoom, ...
}