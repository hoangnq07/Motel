package controller;

import com.google.gson.Gson;
import dao.NotificationDAO;
import model.MotelRoom;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/getRoomDescription")
public class GetRoomDescriptionServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int motelRoomId = Integer.parseInt(request.getParameter("motel_room_id"));

        MotelRoom room = notificationDAO.getRoomDescription(motelRoomId);

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(room);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write(jsonResponse);
    }
}
