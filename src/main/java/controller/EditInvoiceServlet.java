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
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
        float totalPrice = Float.parseFloat(request.getParameter("totalPrice"));
        String invoiceStatus = request.getParameter("invoiceStatus");
        int renterId = Integer.parseInt(request.getParameter("renterId"));
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
        float electricityIndex = Float.parseFloat(request.getParameter("electricityIndex"));
        float waterIndex = Float.parseFloat(request.getParameter("waterIndex"));

        Invoice invoice = new Invoice(invoiceId, null, null, totalPrice, invoiceStatus, renterId, motelRoomId, electricityIndex, waterIndex);

        try {
            invoiceDAO.updateInvoice(invoice);
            response.sendRedirect("invoiceList.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to update invoice.");
        }
    }
}
