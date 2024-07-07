package controller;

import dao.RenterDAO;
import model.Renter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/viewTenants")
public class ViewTenantsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int motelRoomId = Integer.parseInt(request.getParameter("motel_room_id"));

        RenterDAO renterDAO = new RenterDAO();
        List<Renter> currentTenants = renterDAO.getCurrentTenants(motelRoomId);

        request.setAttribute("currentTenants", currentTenants);
        request.setAttribute("motelRoomId", motelRoomId);

        request.getRequestDispatcher("/add_tenants.jsp").forward(request, response);
    }
}