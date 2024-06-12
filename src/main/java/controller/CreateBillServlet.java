package controller;

import context.DBcontext;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.Date;

@WebServlet("/createBill")
public class CreateBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
        int renterId = Integer.parseInt(request.getParameter("renterId"));
        float totalPrice = Float.parseFloat(request.getParameter("totalPrice"));
        String invoiceStatus = request.getParameter("invoiceStatus");
        Date endDate = java.sql.Date.valueOf(request.getParameter("endDate"));
        float electricityIndex = Float.parseFloat(request.getParameter("electricityIndex"));
        float waterIndex = Float.parseFloat(request.getParameter("waterIndex"));

        try (Connection connection = DBcontext.getConnection()) {
            // Insert into Invoice table
            String insertInvoiceSQL = "INSERT INTO dbo.invoice (create_date, end_date, total_price, invoice_status, renter_id, motel_room_id) VALUES (GETDATE(), ?, ?, ?, ?, ?)";
            try (PreparedStatement preparedStatement = connection.prepareStatement(insertInvoiceSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                preparedStatement.setDate(1, (java.sql.Date) endDate);
                preparedStatement.setFloat(2, totalPrice);
                preparedStatement.setString(3, invoiceStatus);
                preparedStatement.setInt(4, renterId);
                preparedStatement.setInt(5, motelRoomId);
                preparedStatement.executeUpdate();

                try (var rs = preparedStatement.getGeneratedKeys()) {
                    if (rs.next()) {
                        int invoiceId = rs.getInt(1);

                        // Insert into Electricity table
                        String insertElectricitySQL = "INSERT INTO dbo.electricity (create_date, electricity_index, invoice_id) VALUES (GETDATE(), ?, ?)";
                        try (PreparedStatement psElectricity = connection.prepareStatement(insertElectricitySQL)) {
                            psElectricity.setFloat(1, electricityIndex);
                            psElectricity.setInt(2, invoiceId);
                            psElectricity.executeUpdate();
                        }

                        // Insert into Water table
                        String insertWaterSQL = "INSERT INTO dbo.water (create_date, water_index, invoice_id) VALUES (GETDATE(), ?, ?)";
                        try (PreparedStatement psWater = connection.prepareStatement(insertWaterSQL)) {
                            psWater.setFloat(1, waterIndex);
                            psWater.setInt(2, invoiceId);
                            psWater.executeUpdate();
                        }
                    }
                }
            }

            response.sendRedirect("bills.jsp");
        } catch (SQLException e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error creating bill");
        }
    }
}
