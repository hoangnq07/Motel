package controller;

import dao.InvoiceDAO;
import model.Invoice;
import context.DBcontext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/editInvoice")
public class EditInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private InvoiceDAO invoiceDAO;

    public EditInvoiceServlet() {
        super();
        this.invoiceDAO = new InvoiceDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

        try {
            Invoice invoice = invoiceDAO.getInvoiceById(invoiceId);
            request.setAttribute("invoice", invoice);
            request.getRequestDispatcher("/editInvoice.jsp").forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to fetch invoice details.");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

            // Use default values or handle null/empty inputs
            float totalPrice = parseFloatSafely(request.getParameter("totalPrice"), 0.0f);
            String invoiceStatus = request.getParameter("invoiceStatus");
            int renterId = parseIntSafely(request.getParameter("renterId"), 0);
            int motelRoomId = parseIntSafely(request.getParameter("motelRoomId"), 0);
            float electricityIndex = parseFloatSafely(request.getParameter("electricityIndex"), 0.0f);
            float waterIndex = parseFloatSafely(request.getParameter("waterIndex"), 0.0f);

            Invoice invoice = new Invoice(invoiceId, null, null, totalPrice, invoiceStatus, renterId, motelRoomId, electricityIndex, waterIndex);

            try {
                invoiceDAO.updateInvoice(invoice);
                response.sendRedirect("owner?page=bill");
            } catch (SQLException e) {
                e.printStackTrace();
                String errorMessage = "Unable to update invoice: " + e.getMessage();
                if (e.getMessage().contains("FK__invoice__renter_")) {
                    errorMessage = "The specified renter does not exist.";
                } else if (e.getMessage().contains("FK__invoice__motel_room_")) {
                    errorMessage = "The specified motel room does not exist.";
                }
                request.setAttribute("errorMessage", errorMessage);
                request.setAttribute("invoice", invoice);
                request.getRequestDispatcher("/editInvoice.jsp").forward(request, response);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Database connection error: " + e.getMessage());
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid input format: " + e.getMessage());
        }
    }

    // Helper method to safely parse int values
    private int parseIntSafely(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    // Helper method to safely parse float values
    private float parseFloatSafely(String value, float defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Float.parseFloat(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }
}
