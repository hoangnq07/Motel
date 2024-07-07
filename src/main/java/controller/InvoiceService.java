package controller;

import dao.InvoiceDAO;
import model.Invoice;
import context.DBcontext;
import java.sql.*;
import java.util.Date;

public class InvoiceService {
    public Invoice createInvoice(int motelRoomId, String invoiceStatus, Date endDate, float electricityIndex, float waterIndex) throws SQLException {
        Connection connection = null;
        try {
            connection = DBcontext.getConnection();
            connection.setAutoCommit(false);

            Date currentDate = new Date();

            // Get the latest invoice for the room
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            Invoice latestInvoice = invoiceDAO.getLatestInvoiceForRoom(motelRoomId);

            if (latestInvoice != null) {
                if (electricityIndex <= latestInvoice.getElectricityIndex() || waterIndex <= latestInvoice.getWaterIndex()) {
                    throw new IllegalArgumentException("New electricity and water indexes must be greater than the previous ones.");
                }
            }

            // Get room prices
            String getRoomPricesSQL = "SELECT electricity_price, water_price FROM dbo.motel_room WHERE motel_room_id = ?";
            float electricityPrice = 0, waterPrice = 0;
            try (PreparedStatement ps = connection.prepareStatement(getRoomPricesSQL)) {
                ps.setInt(1, motelRoomId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        electricityPrice = rs.getFloat("electricity_price");
                        waterPrice = rs.getFloat("water_price");
                    } else {
                        throw new SQLException("Room not found.");
                    }
                }
            }

            // Calculate total price
            float electricityUsage = latestInvoice != null ? electricityIndex - latestInvoice.getElectricityIndex() : electricityIndex;
            float waterUsage = latestInvoice != null ? waterIndex - latestInvoice.getWaterIndex() : waterIndex;
            float totalPrice = (electricityUsage * electricityPrice) + (waterUsage * waterPrice);


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
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(e);
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                connection.close();
            }
        }
    }
}