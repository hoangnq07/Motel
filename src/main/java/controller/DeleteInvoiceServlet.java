package controller;

import dao.InvoiceDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/deleteInvoice")
public class DeleteInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private InvoiceDAO invoiceDAO;

    public DeleteInvoiceServlet() {
        super();
        this.invoiceDAO = new InvoiceDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

        try {
            invoiceDAO.deleteInvoice(invoiceId);
            response.sendRedirect("invoiceList.jsp");
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Unable to delete invoice.");
        }
    }
}
