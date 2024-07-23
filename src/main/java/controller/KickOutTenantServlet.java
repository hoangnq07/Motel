package controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dao.RenterDAO;

@WebServlet("/kickOutTenant")
public class KickOutTenantServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int renterId = Integer.parseInt(request.getParameter("renterId"));

        RenterDAO renterDAO = new RenterDAO();
        boolean success = renterDAO.kickOutTenant(renterId);

        if (success) {
            response.getWriter().write("success");
        } else {
            response.getWriter().write("error");
        }
    }
}
