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

@WebServlet("/createBill")
public class CreateBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private InvoiceService invoiceService;

    public void init() {
        invoiceService = new InvoiceService();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        String action = request.getParameter("action");

        try {
            if ("preview".equals(action)) {
                request.getRequestDispatcher("billConfirmation.jsp").forward(request, response);
                return; // Important: stop execution here
            } else if ("confirm".equals(action)) {
                // Parse and validate input
                String motelRoomIdStr = request.getParameter("motelRoomId");
                String invoiceStatus = request.getParameter("invoiceStatus");
                String electricityUsageStr = request.getParameter("electricityUsage");
                String waterUsageStr = request.getParameter("waterUsage");

                if (motelRoomIdStr == null || invoiceStatus == null ||
                        electricityUsageStr == null || waterUsageStr == null) {
                    throw new IllegalArgumentException("All fields are required");
                }

                int motelRoomId = Integer.parseInt(motelRoomIdStr);
                float electricityUsage = Float.parseFloat(electricityUsageStr);
                float waterUsage = Float.parseFloat(waterUsageStr);

                // Create the invoice
                String result = invoiceService.createInvoice(motelRoomId, invoiceStatus, electricityUsage, waterUsage);

                if (result.startsWith("SUCCESS:")) {
                    out.print(result);
                    // Don't redirect here, let the client handle it
                } else {
                    out.print(result);
                }
            } else {
                out.print("ERROR:Invalid action");
            }
        } catch (Exception e) {
            // Log the full stack trace
            e.printStackTrace();
            // Send a simplified error message to the client
            out.print("ERROR:Unexpected error: " + e.getMessage());
        }
    }
}