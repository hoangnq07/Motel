package controller;

import dao.RenterDAO;
import model.Renter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.Map;
import java.util.logging.Logger;

@WebServlet("/addTenant")
public class AddTenantServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AddTenantServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            String startDateStr = request.getParameter("startDate");
            int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

            logger.info("Received request to add tenant: accountId=" + accountId + ", startDate=" + startDateStr + ", motelRoomId=" + motelRoomId);

            RenterDAO renterDAO = new RenterDAO();

            // Check if user is already renting
            if (renterDAO.isUserAlreadyRenting(accountId)) {
                logger.warning("User is already renting a room");
                out.write("User is already renting a room!");
                return;
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);

            Renter renter = new Renter();
            renter.setRenterId(accountId);
            renter.setRenterDate(startDate);
            renter.setMotelRoomId(motelRoomId);
            renter.setCheckOutDate(null);

            boolean success = renterDAO.addRenter(renter);

            if (success) {
                logger.info("Tenant added successfully");
                out.write("success");
            } else {
                logger.warning("Failed to add tenant");
                out.write("Failed to add tenant");
            }
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format: " + e.getMessage());
            out.write("Invalid number format");
        } catch (ParseException e) {
            logger.severe("Invalid date format: " + e.getMessage());
            out.write("Invalid date format");
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            out.write("Database error");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.write("Unexpected error");
        }
    }
}