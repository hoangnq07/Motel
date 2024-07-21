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

@WebServlet("/addTenant")
public class AddTenantServlet extends HttpServlet {
    private static final Logger logger = Logger.getLogger(AddTenantServlet.class.getName());

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("plain/text");
        PrintWriter out = response.getWriter();

        try {
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
            String startDateStr = request.getParameter("startDate");
            boolean isHasRenter = Boolean.parseBoolean(request.getParameter("isHasRenter"));

            RenterDAO renterDAO = new RenterDAO();
            InvoiceDAO invoiceDAO = new InvoiceDAO();

            // Kiểm tra nếu người dùng đã thuê phòng
            if (renterDAO.isUserAlreadyRenting(accountId)) {
                logger.warning("User is already renting a room");
                out.write("User is already renting a room!");
                return;
            }

            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            Date startDate = dateFormat.parse(startDateStr);

            // Thêm người thuê
            Renter renter = new Renter();
            renter.setRenterId(accountId);
            renter.setRenterDate(startDate);
            renter.setMotelRoomId(motelRoomId);
            renter.setCheckOutDate(null);

            boolean success = renterDAO.addRenter(renter);

            if (success) {
                MotelRoomDAO.updateRoomStatus(motelRoomId, false);
                if(!isHasRenter){
                    float electricityIndex = Float.parseFloat(request.getParameter("electricityIndex"));
                    float waterIndex = Float.parseFloat(request.getParameter("waterIndex"));
                    // Tạo hóa đơn mới
                    Invoice invoice = new Invoice();
                    invoice.setCreateDate(new Date());
                    invoice.setEndDate(null);  // Đặt là null vì đây là hóa đơn mới
                    invoice.setTotalPrice(0);  // Giá tạm thời, sẽ cập nhật sau
                    invoice.setInvoiceStatus("Pending");
                    invoice.setRenterId(accountId);
                    invoice.setMotelRoomId(motelRoomId);

                    int invoiceId = invoiceDAO.addInvoice(invoice);

                    // Thêm chỉ số điện
                    Electricity electricity = new Electricity();
                    electricity.setCreateDate(new Date());
                    electricity.setElectricityIndex(electricityIndex);
                    electricity.setInvoiceId(invoiceId);
                    InvoiceDAO.addElectricityIndex(electricity);

                    // Thêm chỉ số nước
                    Water water = new Water();
                    water.setCreateDate(new Date());
                    water.setWaterIndex(waterIndex);
                    water.setInvoiceId(invoiceId);
                    InvoiceDAO.addWaterIndex(water);

                    logger.info("Tenant added successfully with new invoice and utility indexes");
                    out.write("success");
                }else{
                    logger.info("Tenant added successfully");
                    out.write("success");
                }
            } else {
                logger.warning("Failed to add tenant");
                out.write("Failed to add tenant");
            }
        } catch (JsonSyntaxException e) {
            logger.severe("Invalid JSON format: " + e.getMessage());
            out.write("Invalid JSON format");
        } catch (NumberFormatException e) {
            logger.severe("Invalid number format: " + e.getMessage());
            out.write("Invalid number format");
        } catch (ParseException e) {
            logger.severe("Invalid date format: " + e.getMessage());
            out.write("Invalid date format");
        } catch (SQLException e) {
            logger.severe("Database error: " + e.getMessage());
            out.write("Database error");
        } catch (Exception e) {
            logger.severe("Unexpected error: " + e.getMessage());
            e.printStackTrace();
            out.write("Unexpected error");
        }
    }
}