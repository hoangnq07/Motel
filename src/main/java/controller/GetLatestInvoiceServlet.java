package controller;

import dao.InvoiceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Invoice;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet("/getLatestInvoice")
public class GetLatestInvoiceServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

        try {
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice latestInvoice = invoiceDAO.getLatestInvoiceForRoom(motelRoomId);

            if (latestInvoice != null) {
                out.print("{\"electricityIndex\":" + latestInvoice.getElectricityIndex() +
                        ",\"waterIndex\":" + latestInvoice.getWaterIndex() + "}");
            } else {
                out.print("{}");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"" + e.getMessage() + "\"}");
        }
    }
}
