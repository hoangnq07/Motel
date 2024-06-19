package dao;

import context.DBcontext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

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
}
