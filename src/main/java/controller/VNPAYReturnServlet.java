package com.vnpay.common;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import context.DBcontext;

@WebServlet(name = "VNPAYReturnServlet", urlPatterns = {"/vnpay_return"})
public class VNPAYReturnServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get parameters from the request
        String responseCode = request.getParameter("vnp_ResponseCode");

        // Retrieve the session to get the invoiceId
        HttpSession session = request.getSession();
        String invoiceId = (String) session.getAttribute("invoiceId");

        // Initialize response content
        StringBuilder responseContent = new StringBuilder();
        responseContent.append("<html><head><title>Payment Status</title>");
        responseContent.append("<meta http-equiv='refresh' content='5;url=bills.jsp'>");
        responseContent.append("</head><body>");

        // Debugging information
        responseContent.append("Response code: ").append(responseCode).append("<br>");
        responseContent.append("Invoice ID from session: ").append(invoiceId).append("<br>");

        // Check if the payment was successful
        if ("00".equals(responseCode) && invoiceId != null) {
            // Update invoice status to "Paid" in the database
            try (Connection connection = DBcontext.getConnection()) {
                String updateSQL = "UPDATE dbo.invoice SET invoice_status = 'Paid' WHERE invoice_id = ?";
                try (PreparedStatement ps = connection.prepareStatement(updateSQL)) {
                    ps.setInt(1, Integer.parseInt(invoiceId));
                    int rowsUpdated = ps.executeUpdate();
                    if (rowsUpdated > 0) {
                        responseContent.append("Payment successful. Invoice status updated to 'Paid'.");
                        session.setAttribute("paymentMessage", "Payment successful for invoice ID: " + invoiceId);
                    } else {
                        responseContent.append("Payment successful but failed to update invoice status.");
                        session.setAttribute("paymentMessage", "Payment successful but failed to update invoice status for invoice ID: " + invoiceId);
                    }

                }
            } catch (SQLException e) {
                e.printStackTrace();
                responseContent.append("Database error occurred: ").append(e.getMessage());
            }
        } else {
            responseContent.append("Payment failed or cancelled.");
        }

        responseContent.append("<br>You will be redirected to the bills page in 5 seconds...</body></html>");
        response.getWriter().write(responseContent.toString());
    }
}
