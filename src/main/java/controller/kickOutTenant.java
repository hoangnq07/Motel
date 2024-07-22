package controller;

import dao.RenterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.logging.Logger;

@WebServlet("/kickOutTenant")
public class kickOutTenant extends HttpServlet {
    private static final Logger logger = Logger.getLogger(kickOutTenant.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            int renterId = Integer.parseInt(request.getParameter("renterId"));
            boolean forceDelete = Boolean.parseBoolean(request.getParameter("forceDelete"));

            RenterDAO renterDAO = new RenterDAO();

            if (!forceDelete && renterDAO.hasUnpaidInvoices(renterId)) {
                out.write("unpaid_invoices|This renter has unpaid invoices. Do you want to continue?");
            } else {
                boolean success = renterDAO.deleteRenter(renterId, forceDelete);

                if (success) {
                    logger.info("Tenant kicked out successfully");
                    out.write("success|Tenant kicked out successfully");
                } else {
                    logger.warning("Failed to kick out tenant");
                    out.write("error|Failed to kick out tenant");
                }
            }
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format: " + e.getMessage());
            out.write("error|Invalid number format");
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            out.write("error|Database error: " + e.getMessage());
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.write("error|Unexpected error");
        }
    }
}
