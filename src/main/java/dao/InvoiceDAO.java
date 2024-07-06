package dao;

import context.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
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
}