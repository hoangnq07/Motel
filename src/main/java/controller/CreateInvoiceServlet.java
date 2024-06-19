package controller;

import context.DBcontext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Properties;
import jakarta.mail.*;
import jakarta.mail.internet.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/CreateInvoiceServlet")
public class CreateInvoiceServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        float roomPrice = Float.parseFloat(request.getParameter("roomPrice"));
        float wifiPrice = Float.parseFloat(request.getParameter("wifiPrice"));
        float waterPrice = Float.parseFloat(request.getParameter("waterPrice"));
        float electricityPrice = Float.parseFloat(request.getParameter("electricityPrice"));
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
        int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));

        float electricityIndex = 0;
        float waterIndex = 0;

        try {
            DBcontext dbContext = new DBcontext();
            Connection conn = dbContext.getConnection();

            // Lấy chỉ số điện và nước
            String sql = "SELECT e.electricity_index, w.water_index FROM dbo.electricity e JOIN dbo.water w ON e.invoice_id = w.invoice_id WHERE e.invoice_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                electricityIndex = rs.getFloat("electricity_index");
                waterIndex = rs.getFloat("water_index");
            }

            // Tính tổng giá trị hóa đơn
            float totalPrice = roomPrice + wifiPrice + (waterIndex * waterPrice) + (electricityIndex * electricityPrice);

            // Tạo hóa đơn
            String insertInvoiceSql = "INSERT INTO dbo.invoice (end_date, total_price, invoice_status, renter_id, motel_room_id) VALUES (GETDATE(), ?, 'Chưa thanh toán', (SELECT renter_id FROM dbo.renter WHERE motel_room_id = ?), ?)";
            PreparedStatement psInvoice = conn.prepareStatement(insertInvoiceSql);
            psInvoice.setFloat(1, totalPrice);
            psInvoice.setInt(2, motelRoomId);
            psInvoice.setInt(3, motelRoomId);
            psInvoice.executeUpdate();

            // Gửi email hóa đơn
            sendInvoiceEmail(totalPrice, roomPrice, wifiPrice, waterPrice, electricityPrice, motelRoomId, conn);

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("success.jsp");
    }

    private void sendInvoiceEmail(float totalPrice, float roomPrice, float wifiPrice, float waterPrice, float electricityPrice, int motelRoomId, Connection conn) {
        try {
            // Lấy email của người thuê trong phòng đó
            String sql = "SELECT a.email FROM dbo.accounts a JOIN dbo.renter r ON a.account_id = r.renter_id WHERE r.motel_room_id = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, motelRoomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String email = rs.getString("email");

                // Nội dung email
                String subject = "Hóa đơn thanh toán";
                String message = "Hóa đơn thanh toán bao gồm:\n";
                message += "Tiền phòng: " + roomPrice + "\n";
                message += "Tiền wifi: " + wifiPrice + "\n";
                message += "Tiền nước: " + waterPrice + "\n";
                message += "Tiền điện: " + electricityPrice + "\n";
                message += "Tổng cộng: " + totalPrice + "\n";

                // Thiết lập thông tin email
                String from = "thaibaovu0212@gmail.com";
                String password = "@Bao02122003";
                String host = "smtp.gmail.com";
                Properties properties = System.getProperties();
                properties.put("mail.smtp.host", host);
                properties.put("mail.smtp.port", "587");
                properties.put("mail.smtp.auth", "true");
                properties.put("mail.smtp.starttls.enable", "true");

                Session session = Session.getInstance(properties, new jakarta.mail.Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(from, password);
                    }
                });

                MimeMessage mimeMessage = new MimeMessage(session);
                mimeMessage.setFrom(new InternetAddress(from));
                mimeMessage.addRecipient(Message.RecipientType.TO, new InternetAddress(email));
                mimeMessage.setSubject(subject);
                mimeMessage.setText(message);

                // Gửi email
                Transport.send(mimeMessage);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
