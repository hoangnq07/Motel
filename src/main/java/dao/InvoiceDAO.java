package dao;

import context.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import model.Invoice;

public class InvoiceDAO {

    public float[] getIndexesByInvoiceId(int invoiceId) throws SQLException, ClassNotFoundException {
        float[] indexes = new float[2]; // [0]: electricityIndex, [1]: waterIndex

        DBcontext dbContext = new DBcontext();
        Connection conn = dbContext.getConnection();

        String sql = "SELECT e.electricity_index, w.water_index FROM dbo.electricity e JOIN dbo.water w ON e.invoice_id = w.invoice_id WHERE e.invoice_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            indexes[0] = rs.getFloat("electricity_index");
            indexes[1] = rs.getFloat("water_index");
        }

        conn.close();

        return indexes;
    }

    public Invoice getInvoiceById(int invoiceId) throws SQLException, ClassNotFoundException {
        DBcontext dbContext = new DBcontext();
        Connection conn = dbContext.getConnection();

        String sql = "SELECT * FROM dbo.invoice WHERE invoice_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();

        Invoice invoice = null;
        if (rs.next()) {
            invoice = new Invoice(
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

        conn.close();
        return invoice;
    }

    public void updateInvoice(Invoice invoice) throws SQLException, ClassNotFoundException {
        DBcontext dbContext = new DBcontext();
        Connection conn = dbContext.getConnection();

        String sql = "UPDATE dbo.invoice SET total_price = ?, invoice_status = ?, renter_id = ?, motel_room_id = ?, electricity_index = ?, water_index = ? WHERE invoice_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setFloat(1, invoice.getTotalPrice());
        ps.setString(2, invoice.getInvoiceStatus());
        ps.setInt(3, invoice.getRenterId());
        ps.setInt(4, invoice.getMotelRoomId());
        ps.setFloat(5, invoice.getElectricityIndex());
        ps.setFloat(6, invoice.getWaterIndex());
        ps.setInt(7, invoice.getInvoiceId());

        ps.executeUpdate();
        conn.close();
    }

    public void deleteInvoice(int invoiceId) throws SQLException, ClassNotFoundException {
        DBcontext dbContext = new DBcontext();
        Connection conn = dbContext.getConnection();

        String sql = "DELETE FROM dbo.invoice WHERE invoice_id = ?";
        PreparedStatement ps = conn.prepareStatement(sql);
        ps.setInt(1, invoiceId);

        ps.executeUpdate();
        conn.close();
    }
}
