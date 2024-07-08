package dao;

import context.DBcontext;
import model.RevenueData;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class InvoiceDAO {

    private Connection connection; // Khai báo biến Connection

    // Constructor để khởi tạo kết nối
    public InvoiceDAO() throws SQLException, ClassNotFoundException {
        DBcontext dbContext = new DBcontext();
        this.connection = dbContext.getConnection(); // Khởi tạo kết nối
    }

    public float[] getIndexesByInvoiceId(int invoiceId) throws SQLException {
        float[] indexes = new float[2]; // [0]: electricityIndex, [1]: waterIndex

        String sql = "SELECT e.electricity_index, w.water_index FROM dbo.electricity e JOIN dbo.water w ON e.invoice_id = w.invoice_id WHERE e.invoice_id = ?";
        PreparedStatement ps = connection.prepareStatement(sql);
        ps.setInt(1, invoiceId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            indexes[0] = rs.getFloat("electricity_index");
            indexes[1] = rs.getFloat("water_index");
        }

        ps.close();
        rs.close();

        return indexes;
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
