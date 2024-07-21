package controller;

import dao.RenterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/deleteTenant")
public class DeleteTenantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException, IOException {
        int renterId = Integer.parseInt(request.getParameter("renterId"));
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

        RenterDAO renterDAO = new RenterDAO();
        boolean success = renterDAO.deleteTenant(renterId);

        if (success) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}