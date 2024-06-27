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
import java.util.List;

@WebServlet("/getMotelRooms")
public class GetMotelRoomsServlet extends HttpServlet {
    private NotificationDAO notificationDAO = new NotificationDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<MotelRoom> motelRooms = notificationDAO.getAllMotelRooms();

        Gson gson = new Gson();
        String jsonResponse = gson.toJson(motelRooms);
        response.getWriter().write(jsonResponse);
    }
}
