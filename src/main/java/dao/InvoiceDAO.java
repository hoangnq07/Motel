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

    public List<RevenueData> getMonthlyRevenueByOwnerId(int ownerId) throws SQLException, ClassNotFoundException {
        List<RevenueData> revenues = new ArrayList<>();
        String sql = "WITH RevenueData AS (" +
                "    SELECT a.account_id AS OwnerId, MONTH(i.create_date) AS Month, SUM(i.total_price) AS TotalRevenue " +
                "    FROM invoice i " +
                "    JOIN motel_room mr ON i.motel_room_id = mr.motel_room_id " +
                "    JOIN accounts a ON mr.account_id = a.account_id " +
                "    WHERE a.role = 'owner' AND a.account_id = ? " +
                "    GROUP BY a.account_id, MONTH(i.create_date) " +
                ") " +
                "SELECT m.Month, ISNULL(rd.TotalRevenue, 0) AS TotalRevenue " +
                "FROM (VALUES (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12)) AS m(Month) " +
                "LEFT JOIN RevenueData rd ON m.Month = rd.Month " +
                "ORDER BY m.Month;";

        DBcontext dbContext = new DBcontext();
        try (Connection conn = dbContext.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, ownerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    revenues.add(new RevenueData(rs.getInt("Month"), rs.getDouble("TotalRevenue")));
                }
            }
        }
        return revenues;
    }
//    public static void main(String[] args) {
//        try {
//            // Khởi tạo InvoiceDAO
//            InvoiceDAO invoiceDAO = new InvoiceDAO();
//
//            // Thiết lập ownerId cần kiểm tra
//            int ownerId = 2; // Bạn có thể thay đổi ID này để kiểm tra các owner khác
//
//            // Gọi phương thức getMonthlyRevenueByOwnerId
//            List<RevenueData> revenues = invoiceDAO.getMonthlyRevenueByOwnerId(ownerId);
//
//            // In kết quả
//            for (RevenueData revenue : revenues) {
//                System.out.println("Tháng: " + revenue.getMonth() + ", Doanh thu: " + revenue.getTotalRevenue());
//            }
//        } catch (SQLException | ClassNotFoundException e) {
//            e.printStackTrace();
//        }
//    }
}

