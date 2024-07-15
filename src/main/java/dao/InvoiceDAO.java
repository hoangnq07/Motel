package dao;

import context.DBcontext;
import model.RevenueData;
import java.util.List;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import model.Invoice;

public class InvoiceDAO {

    public Invoice getInvoiceById(int invoiceId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT i.*, e.electricity_index, w.water_index " +
                "FROM dbo.invoice i " +
                "LEFT JOIN dbo.electricity e ON i.invoice_id = e.invoice_id " +
                "LEFT JOIN dbo.water w ON i.invoice_id = w.invoice_id " +
                "WHERE i.invoice_id = ?";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Invoice(
                            rs.getInt("invoice_id"),
                            rs.getDate("create_date"),
                            rs.getDate("end_date"),
                            rs.getFloat("total_price"),
                            rs.getString("invoice_status"),
                            rs.getInt("renter_id"),
                            rs.getInt("motel_room_id"),
                            rs.getFloat("electricity_index"),
                            rs.getFloat("water_index")
                    );
                }
            }
        } catch (SQLException e) {
            throw new SQLException("Error fetching invoice: " + e.getMessage(), e);
        }
        return null;
    }

    public void updateInvoice(Invoice invoice) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBcontext.getConnection();
            conn.setAutoCommit(false);

            boolean renterExists = checkEntityExists(conn, "renter", "renter_id", invoice.getRenterId());
            boolean motelRoomExists = checkEntityExists(conn, "motel_room", "motel_room_id", invoice.getMotelRoomId());

            // Update invoice
            String updateInvoiceSql = "UPDATE dbo.invoice SET total_price = ?, invoice_status = ? ";
            if (renterExists) updateInvoiceSql += ", renter_id = ? ";
            if (motelRoomExists) updateInvoiceSql += ", motel_room_id = ? ";
            updateInvoiceSql += "WHERE invoice_id = ?";

            try (PreparedStatement ps = conn.prepareStatement(updateInvoiceSql)) {
                int paramIndex = 1;
                ps.setFloat(paramIndex++, invoice.getTotalPrice());
                ps.setString(paramIndex++, invoice.getInvoiceStatus());
                if (renterExists) ps.setInt(paramIndex++, invoice.getRenterId());
                if (motelRoomExists) ps.setInt(paramIndex++, invoice.getMotelRoomId());
                ps.setInt(paramIndex, invoice.getInvoiceId());
                ps.executeUpdate();
            }


            // Update electricity
            String updateElectricitySql = "UPDATE dbo.electricity SET electricity_index = ? WHERE invoice_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateElectricitySql)) {
                ps.setFloat(1, invoice.getElectricityIndex());
                ps.setInt(2, invoice.getInvoiceId());
                ps.executeUpdate();
            }

            // Update water
            String updateWaterSql = "UPDATE dbo.water SET water_index = ? WHERE invoice_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(updateWaterSql)) {
                ps.setFloat(1, invoice.getWaterIndex());
                ps.setInt(2, invoice.getInvoiceId());
                ps.executeUpdate();
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new SQLException("Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            throw e;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    // Log this exception
                }
            }
        }
    }

    private boolean checkRenterExists(Connection conn, int renterId) throws SQLException {
        String sql = "SELECT 1 FROM dbo.renter WHERE renter_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, renterId);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public void deleteInvoice(int invoiceId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            conn = DBcontext.getConnection();
            conn.setAutoCommit(false);

            // Delete related records in electricity table
            String deleteElectricitySql = "DELETE FROM dbo.electricity WHERE invoice_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteElectricitySql)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            // Delete related records in water table
            String deleteWaterSql = "DELETE FROM dbo.water WHERE invoice_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteWaterSql)) {
                ps.setInt(1, invoiceId);
                ps.executeUpdate();
            }

            // Delete the invoice
            String deleteInvoiceSql = "DELETE FROM dbo.invoice WHERE invoice_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(deleteInvoiceSql)) {
                ps.setInt(1, invoiceId);
                int affectedRows = ps.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Deleting invoice failed, no rows affected.");
                }
            }

            conn.commit();
        } catch (SQLException e) {
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    throw new SQLException("Error rolling back transaction: " + ex.getMessage(), ex);
                }
            }
            throw new SQLException("Error deleting invoice: " + e.getMessage(), e);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    // Log this exception
                }
            }
        }
    }

    private boolean checkEntityExists(Connection conn, String tableName, String idColumnName, int id) throws SQLException {
        String sql = "SELECT 1 FROM dbo." + tableName + " WHERE " + idColumnName + " = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    public Invoice getLatestInvoiceForRoom(int motelRoomId) throws SQLException, ClassNotFoundException {
        String sql = "SELECT TOP 1 i.*, e.electricity_index, w.water_index " +
                "FROM dbo.invoice i " +
                "LEFT JOIN dbo.electricity e ON i.invoice_id = e.invoice_id " +
                "LEFT JOIN dbo.water w ON i.invoice_id = w.invoice_id " +
                "WHERE i.motel_room_id = ? " +
                "ORDER BY i.create_date DESC";
        try (Connection conn = DBcontext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, motelRoomId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return new Invoice(
                            rs.getInt("invoice_id"),
                            rs.getDate("create_date"),
                            rs.getDate("end_date"),
                            rs.getFloat("total_price"),
                            rs.getString("invoice_status"),
                            rs.getInt("renter_id"),
                            rs.getInt("motel_room_id"),
                            rs.getFloat("electricity_index"),
                            rs.getFloat("water_index")
                    );
                }
            }
        }
        return null;
    }

    public List<RevenueData> getMonthlyRevenueByOwnerIdAndYear(int ownerId, int year) throws SQLException, ClassNotFoundException {
        List<RevenueData> revenues = new ArrayList<>();
        String sql = "WITH RevenueData AS (" +
                "    SELECT a.account_id AS OwnerId, MONTH(i.create_date) AS Month, YEAR(i.create_date) AS Year, SUM(i.total_price) AS TotalRevenue " +
                "    FROM invoice i " +
                "    JOIN motel_room mr ON i.motel_room_id = mr.motel_room_id " +
                "    JOIN accounts a ON mr.account_id = a.account_id " +
                "    WHERE a.role = 'owner' AND a.account_id = ? AND YEAR(i.create_date) = ? " +
                "    GROUP BY a.account_id, MONTH(i.create_date), YEAR(i.create_date) " +
                ") " +
                "SELECT m.Month, m.Year, ISNULL(rd.TotalRevenue, 0) AS TotalRevenue " +
                "FROM (SELECT * FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS months(Month) " +
                "      CROSS JOIN (VALUES (?)) AS years(Year)) AS m " +
                "LEFT JOIN RevenueData rd ON m.Month = rd.Month AND m.Year = rd.Year " +
                "ORDER BY m.Month;";

        DBcontext dbContext = new DBcontext();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            ps.setInt(2, year);
            ps.setInt(3, year); // Thiết lập năm cho CROSS JOIN
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenues.add(new RevenueData(rs.getInt("Month"), rs.getDouble("TotalRevenue"), rs.getInt("Year")));
                }
            }
        }
        return revenues;
    }
    public int getNumberOfRenters(int ownerId) throws SQLException, ClassNotFoundException {
        int count = 0;
        String sql = "SELECT COUNT(DISTINCT renter_id) AS Count FROM renter " +
                "JOIN motel_room ON renter.motel_room_id = motel_room.motel_room_id " +
                "WHERE motel_room.account_id = ?";
        DBcontext dbContext = new DBcontext();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("Count");
                }
            }
        }
        return count;
    }

    public int getNumberOfMotels(int ownerId) throws SQLException, ClassNotFoundException {
        int count = 0;
        String sql = "SELECT COUNT(DISTINCT motel_id) AS Count FROM motels " +
                "WHERE account_id = ?";
        DBcontext dbContext = new DBcontext();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("Count");
                }
            }
        }
        return count;
    }

    public int getNumberOfRooms(int ownerId) throws SQLException, ClassNotFoundException {
        int count = 0;
        String sql = "SELECT COUNT(*) AS Count FROM motel_room " +
                "WHERE account_id = ?";
        DBcontext dbContext = new DBcontext();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt("Count");
                }
            }
        }
        return count;
    }

//    public static void main(String[] args) {
//        try {
//            InvoiceDAO dao = new InvoiceDAO();
//            List<RevenueData> revenues = dao.getMonthlyRevenueByOwnerIdAndYear(1, 2024);
//            for (RevenueData rd : revenues) {
//                System.out.println("Month: " + rd.getMonth() + " - Total Revenue: " + rd.getTotalRevenue());
//            }
//        } catch (Exception e) {
//            e.printStackTrace();
//        }
//    }
}

