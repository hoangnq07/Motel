package controller;

import model.Invoice;
import context.DBcontext;
import java.sql.*;
import java.util.Date;

public class InvoiceService {
    public Invoice createInvoice(int motelRoomId, float totalPrice, String invoiceStatus,
                                 Date endDate, float electricityIndex, float waterIndex) throws SQLException {
        Connection connection = null;
        try {
            connection = DBcontext.getConnection();
            connection.setAutoCommit(false);

            Date currentDate = new Date();

            Date lastEndDate = getMostRecentInvoiceEndDate(connection, motelRoomId);
            if (lastEndDate != null && currentDate.before(lastEndDate)) {
                throw new IllegalArgumentException("Cannot create new invoice. Current date must be after " + lastEndDate);
            }

            // Find the renter_id from the motel_room_id
            String selectRenterIdSQL = "SELECT renter_id FROM dbo.renter WHERE motel_room_id = ?";
            int renterId = -1;
            try (PreparedStatement psSelectRenter = connection.prepareStatement(selectRenterIdSQL)) {
                psSelectRenter.setInt(1, motelRoomId);
                try (ResultSet rs = psSelectRenter.executeQuery()) {
                    if (rs.next()) {
                        renterId = rs.getInt("renter_id");
                    }
                }
            }
            if (renterId == -1) {
                throw new SQLException("No renter found for the specified room.");
            }

            // Insert into Invoice table
            String insertInvoiceSQL = "INSERT INTO dbo.invoice (create_date, end_date, total_price, invoice_status, renter_id, motel_room_id) VALUES (?, ?, ?, ?, ?, ?)";
            int invoiceId;
            try (PreparedStatement preparedStatement = connection.prepareStatement(insertInvoiceSQL, PreparedStatement.RETURN_GENERATED_KEYS)) {
                preparedStatement.setDate(1, new java.sql.Date(currentDate.getTime()));
                preparedStatement.setDate(2, new java.sql.Date(endDate.getTime()));
                preparedStatement.setFloat(3, totalPrice);
                preparedStatement.setString(4, invoiceStatus);
                preparedStatement.setInt(5, renterId);
                preparedStatement.setInt(6, motelRoomId);
                int affectedRows = preparedStatement.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Creating invoice failed, no rows affected.");
                }

                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        invoiceId = generatedKeys.getInt(1);
                    } else {
                        throw new SQLException("Creating invoice failed, no ID obtained.");
                    }
                }
            }

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

            connection.commit();
            return new Invoice(invoiceId, currentDate, endDate, totalPrice, invoiceStatus, renterId, motelRoomId, electricityIndex, waterIndex);
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    System.err.print("Transaction is being rolled back");
                    connection.rollback();
                } catch (SQLException excep) {
                    excep.printStackTrace();
                }
            }
            throw e;
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }

    private Date getMostRecentInvoiceEndDate(Connection connection, int motelRoomId) throws SQLException {
        String sql = "SELECT MAX(end_date) as last_end_date FROM dbo.invoice WHERE motel_room_id = ?";
        try (PreparedStatement pstmt = connection.prepareStatement(sql)) {
            pstmt.setInt(1, motelRoomId);
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getDate("last_end_date");
                }
            }
        }
        return null;
    }

}