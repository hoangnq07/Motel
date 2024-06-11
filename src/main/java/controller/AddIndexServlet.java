package controller;

import context.DBcontext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddIndexServlet")
public class AddIndexServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        float electricityIndex = Float.parseFloat(request.getParameter("electricityIndex"));
        float waterIndex = Float.parseFloat(request.getParameter("waterIndex"));
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

        try {
            DBcontext dbContext = new DBcontext();
            Connection conn = dbContext.getConnection();

            String sqlElectricity = "INSERT INTO dbo.electricity (electricity_index, invoice_id) VALUES (?, ?)";
            PreparedStatement psElectricity = conn.prepareStatement(sqlElectricity);
            psElectricity.setFloat(1, electricityIndex);
            psElectricity.setInt(2, invoiceId);
            psElectricity.executeUpdate();

            String sqlWater = "INSERT INTO dbo.water (water_index, invoice_id) VALUES (?, ?)";
            PreparedStatement psWater = conn.prepareStatement(sqlWater);
            psWater.setFloat(1, waterIndex);
            psWater.setInt(2, invoiceId);
            psWater.executeUpdate();

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("createInvoice.jsp?invoiceId=" + invoiceId);
    }
}
