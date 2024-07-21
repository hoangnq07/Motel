package controller;

import com.google.gson.JsonSyntaxException;
import dao.*;
import model.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Logger;

@WebServlet("/checkOut")
public class CheckOutServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(CheckOutServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("plain/text");
        PrintWriter out = response.getWriter();

        try {
            int renterId = Integer.parseInt(request.getParameter("renterId"));
            int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
//            String checkOutDateStr = request.getParameter("checkOutDate");
//            float finalElectricityIndex = Float.parseFloat(request.getParameter("finalElectricityIndex"));
//            float finalWaterIndex = Float.parseFloat(request.getParameter("finalWaterIndex"));

            RenterDAO renterDAO = new RenterDAO();
            InvoiceDAO invoiceDAO = new InvoiceDAO();


//            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
//            Date checkOutDate = dateFormat.parse(checkOutDateStr);

            // 1. Cập nhật ngày trả phòng cho người thuê
            boolean renterUpdated = renterDAO.checkOut(renterId);

            if (renterUpdated) {
                // 2. Kiểm tra xem còn người thuê nào khác trong phòng không
                int remainingRenters = renterDAO.countRemainingRenters(motelRoomId);

                if (remainingRenters == 0) {
                    // Nếu không còn ai thuê, cập nhật trạng thái phòng thành trống
                    boolean roomUpdated = MotelRoomDAO.updateRoomStatus(motelRoomId, true);
                    if (!roomUpdated) {
                        logger.warning("Failed to update room status");
                        out.write("Failed to update room status");
                        return;
                    }
                }else{
                    logger.warning("Trả phòng thành công");
                    out.write("success");
                    return;
                }

                // 3. Lấy hóa đơn mới nhất của người thuê
                Invoice latestInvoice = invoiceDAO.getLatestInvoiceForRoom(motelRoomId);

                if (latestInvoice != null) {
                    // 4. Tính toán tổng tiền
//                    double totalPrice = calculateTotalPrice(latestInvoice, finalElectricityIndex, finalWaterIndex);

                    // 5. Cập nhật hóa đơn
                    String invoiceStatus = "UNPAID";
                    invoiceDAO.updateInvoice(latestInvoice);

                } else {
                    logger.warning("No invoice found for the renter");
                    out.write("No invoice found for the renter");
                }
            } else {
                logger.warning("Failed to update renter check-out date");
                out.write("Failed to update renter check-out date");
            }
        } catch (JsonSyntaxException e) {
            logger.severe("Invalid JSON format: " + e.getMessage());
            out.write("Invalid JSON format");
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format: " + e.getMessage());
            out.write("Invalid number format");
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            out.write("Database error");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            out.write("Unexpected error");
        }
    }

    private double calculateTotalPrice(Invoice invoice, float finalElectricityIndex, float finalWaterIndex) {
        // Implement your logic to calculate the total price
        // This might involve fetching the initial indexes, calculating the usage,
        // and applying the appropriate rates
        // For now, we'll return a dummy value
        return 1000000.0;
    }
}