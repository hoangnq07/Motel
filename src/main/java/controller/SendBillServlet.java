package controller;

import java.io.IOException;
import java.sql.*;
import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/SendBillServlet")
public class SendBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        float roomBill = Float.parseFloat(request.getParameter("roomBill"));
        float electricityBill = Float.parseFloat(request.getParameter("electricityBill"));
        float waterBill = Float.parseFloat(request.getParameter("waterBill"));
        float wifiBill = Float.parseFloat(request.getParameter("wifiBill"));

        if (email == null || email.isEmpty()) {
            response.sendRedirect("sendBill.jsp?status=empty_email");
            return;
        }

        String status;

        try (Connection conn = DBcontext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "SELECT a.email, mr.descriptions AS room_description " +
                             "FROM renter r " +
                             "JOIN accounts a ON r.account_id = a.account_id " +
                             "JOIN motel_room mr ON r.motel_room_id = mr.motel_room_id " +
                             "WHERE a.email = ?")) {

            pstmt.setString(1, email);

            ResultSet rs = pstmt.executeQuery();

            if (rs.next()) {
                String renterEmail = rs.getString("email");
                String roomDescription = rs.getString("room_description");
                float totalBill = roomBill + electricityBill + waterBill + wifiBill;

                String messageContent = String.format(
                        "Thông tin hóa đơn:\n\nPhòng: %s\nTiền phòng: %.2f\nTiền điện: %.2f\nTiền nước: %.2f\nTiền wifi: %.2f\nTổng cộng: %.2f",
                        roomDescription, roomBill, electricityBill, waterBill, wifiBill, totalBill
                );

                boolean emailSent = EmailSender.sendEmail(renterEmail, "Hóa đơn thanh toán", messageContent);
                status = emailSent ? "success" : "email_error";
            } else {
                status = "not_found";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            status = "sql_error";
        }

        response.sendRedirect("sendBill.jsp?status=" + status);
    }
}