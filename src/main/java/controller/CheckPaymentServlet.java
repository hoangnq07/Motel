package controller;

import context.DBcontext;
import controller.util.EmailSender;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

@WebServlet(name = "CheckPaymentServlet", value = "/checkPayment")
public class CheckPaymentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Bước 1: Nhận kết quả thanh toán từ VNPAY
        String invoiceId = request.getParameter("invoiceId");
        String amount = request.getParameter("amount");
        String responseCode = request.getParameter("responseCode");

        // Bước 2: Xác thực thông tin thanh toán
        if ("00".equals(responseCode)) {  // Giả sử "00" là mã thành công
            // Bước 3: Cập nhật trạng thái hóa đơn
            try {
                updateInvoiceStatus(invoiceId, "PAID");
                response.getWriter().write("Error processing payment."+invoiceId);
//                // Bước 4: Gửi email hóa đơn
//                String customerEmail = getCustomerEmail(invoiceId);
//                boolean emailSent = EmailSender.sendEmail(customerEmail, "Thông tin hóa đơn",
//                        "Thanh toán của bạn cho hoá đơn " + invoiceId + " với tổng tiền " + amount + " đã được thanh toán thành công.");
//
//                if (emailSent) {
//                    response.getWriter().write("Payment successful, invoice updated and email sent.");
//                } else {
//                    response.getWriter().write("Payment successful, invoice updated but failed to send email.");
//                }
            } catch (SQLException e) {
                e.printStackTrace();
                response.getWriter().write("Error processing payment.");
            }
        } else {
            response.getWriter().write("Payment failed.");
        }
    }

    private void updateInvoiceStatus(String invoiceId, String status) throws SQLException {
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            conn = DBcontext.getConnection();
            String sql = "UPDATE invoice SET invoice_status = ? WHERE invoice_id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setString(2, invoiceId);
            pstmt.executeUpdate();
        } finally {
            if (pstmt != null) pstmt.close();
            if (conn != null) conn.close();
        }
    }

//    private String getCustomerEmail(String invoiceId) throws SQLException {
//        Connection conn = null;
//        PreparedStatement pstmt = null;
//        ResultSet rs = null;
//        try {
//            conn = DBcontext.getConnection();
//            String sql = "SELECT email FROM customers WHERE invoice_id = ?";
//            pstmt = conn.prepareStatement(sql);
//            pstmt.setString(1, invoiceId);
//            rs = pstmt.executeQuery();
//            if (rs.next()) {
//                return rs.getString("email");
//            }
//            return null;
//        } finally {
//            if (rs != null) rs.close();
//            if (pstmt != null) pstmt.close();
//            if (conn != null) conn.close();
//        }
//    }
}
