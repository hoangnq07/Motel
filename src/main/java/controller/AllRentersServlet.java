package controller;

import dao.RenterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Renter;

import java.io.IOException;
import java.util.List;

@WebServlet("/owner/all-renters")
public class AllRentersServlet extends HttpServlet {


    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Renter> renters = RenterDAO.getAllRenters();
        request.setAttribute("renters", renters);
        request.getRequestDispatcher("/WEB-INF/views/all-renters.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST requests if needed
        doGet(request, response);
    }
}