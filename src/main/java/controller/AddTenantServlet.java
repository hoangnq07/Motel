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

        logger.info("AddTenantServlet: doPost method started");

        // Log all parameters
        logger.info("All received parameters:");
        for (Map.Entry<String, String[]> entry : request.getParameterMap().entrySet()) {
            logger.info(entry.getKey() + ": " + Arrays.toString(entry.getValue()));
        }

        String accountIdStr = request.getParameter("accountId");
        String startDateStr = request.getParameter("startDate");
        String motelRoomIdStr = request.getParameter("motelRoomId");

        logger.info("Parsed parameters: accountId=" + accountIdStr + ", startDate=" + startDateStr + ", motelRoomId=" + motelRoomIdStr);


        try {
            if (accountIdStr == null || accountIdStr.isEmpty() || motelRoomIdStr == null || motelRoomIdStr.isEmpty()) {
                throw new IllegalArgumentException("accountId and motelRoomId must not be empty");
            }

            int accountId = Integer.parseInt(accountIdStr);
            int motelRoomId = Integer.parseInt(motelRoomIdStr);

            if (startDateStr == null || startDateStr.isEmpty()) {
                throw new IllegalArgumentException("startDate must not be empty");
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);

            RenterDAO renterDAO = new RenterDAO();

            Renter renter = new Renter();
            renter.setRenterId(accountId);
            renter.setRenterDate(startDate);
            renter.setMotelRoomId(motelRoomId);
            renter.setCheckOutDate(null);

            logger.info("Attempting to add renter: " + renter);

            boolean success = renterDAO.addRenter(renter);

            if (success) {
                logger.info("Tenant added successfully");
                out.write("success");
            } else {
                logger.warning("Failed to add tenant");
                out.write("error: Failed to add tenant");
            }
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format: " + e.getMessage());
            out.write("error: Invalid number format - " + e.getMessage());
        } catch (ParseException e) {
            logger.severe("Invalid date format: " + e.getMessage());
            out.write("error: Invalid date format - " + e.getMessage());
        } catch (IllegalArgumentException e) {
            logger.severe("Invalid argument: " + e.getMessage());
            out.write("error: " + e.getMessage());
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            out.write("error: Database error - " + e.getMessage());
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.write("error: Unexpected error - " + e.getMessage());
        }

        logger.info("AddTenantServlet: doPost method ended");
    }
}