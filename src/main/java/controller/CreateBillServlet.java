package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Invoice;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/createBill")
public class CreateBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private InvoiceService invoiceService;

    public void init() {
        invoiceService = new InvoiceService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        try {
            if ("preview".equals(action)) {
                // Forward to the confirmation JSP
                request.getRequestDispatcher("billConfirmation.jsp").forward(request, response);
            } else if ("confirm".equals(action)) {
                // Parse and validate input
                String motelRoomIdStr = request.getParameter("motelRoomId");
                String totalPriceStr = request.getParameter("totalPrice");
                String invoiceStatus = request.getParameter("invoiceStatus");
                String endDateStr = request.getParameter("endDate");
                String electricityUsageStr = request.getParameter("electricityUsage");
                String waterUsageStr = request.getParameter("waterUsage");

                if (motelRoomIdStr == null || totalPriceStr == null || invoiceStatus == null ||
                        endDateStr == null || electricityUsageStr == null || waterUsageStr == null) {
                    throw new IllegalArgumentException("All fields are required");
                }

                int motelRoomId = Integer.parseInt(motelRoomIdStr);
                float totalPrice = Float.parseFloat(totalPriceStr);
                Date endDate = java.sql.Date.valueOf(endDateStr);
                float electricityUsage = Float.parseFloat(electricityUsageStr);
                float waterUsage = Float.parseFloat(waterUsageStr);

                // Create the invoice
                Invoice invoice = invoiceService.createInvoice(motelRoomId, invoiceStatus, endDate, electricityUsage, waterUsage);

                if (invoice != null && invoice.getInvoiceId() > 0) {
                    out.print("{\"status\":\"success\", \"invoiceId\":" + invoice.getInvoiceId() + "}");
                } else {
                    throw new Exception("Invoice creation failed");
                }
            } else {
                throw new IllegalArgumentException("Invalid action");
            }
        } catch (IllegalArgumentException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print("{\"status\":\"error\", \"message\":\"" + e.getMessage() + "\"}");
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Database error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"status\":\"error\", \"message\":\"Unexpected error: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}