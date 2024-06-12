package controller;

import java.io.IOException;
import java.sql.*;
import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AddMeterReadingServlet")
public class AddMeterReadingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int roomId = Integer.parseInt(request.getParameter("room"));
        int electricityIndex = Integer.parseInt(request.getParameter("electricityIndex"));
        int waterIndex = Integer.parseInt(request.getParameter("waterIndex"));

        DBcontext dbContext = new DBcontext();
        String status = "";

        try (Connection conn = dbContext.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                     "INSERT INTO indexs (motel_room_id, electricity_index, water_index, create_date) " +
                             "VALUES (?, ?, ?, GETDATE())")) {

            pstmt.setInt(1, roomId);
            pstmt.setInt(2, electricityIndex);
            pstmt.setInt(3, waterIndex);

            int result = pstmt.executeUpdate();

            if (result > 0) {
                status = "success";
            } else {
                status = "error";
            }

        } catch (SQLException e) {
            e.printStackTrace();
            status = "error";
        }

        response.sendRedirect("addMeterReading.jsp?status=" + status);
    }
}
