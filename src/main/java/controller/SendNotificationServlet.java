package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/sendNotification")
public class SendNotificationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/sendNotification.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String motelRoomId = request.getParameter("motelRoomId");
        String message = request.getParameter("message");

        if (motelRoomId != null && message != null) {
            try {
                // Get the connection from DBcontext
                Connection conn = DBcontext.getConnection();

                // Get renter_id of the renter based on motel_room_id
                String getRenterIdQuery = "SELECT renter_id FROM renter WHERE motel_room_id = ?";
                PreparedStatement pstmt = conn.prepareStatement(getRenterIdQuery);
                pstmt.setInt(1, Integer.parseInt(motelRoomId));
                ResultSet rs = pstmt.executeQuery();

                if (rs.next()) {
                    int renterId = rs.getInt("renter_id");

                    // Insert the notification into the notifications table
                    String insertNotificationQuery = "INSERT INTO notifications (message, renter_id, motel_room_id) VALUES (?, ?, ?)";
                    PreparedStatement insertStmt = conn.prepareStatement(insertNotificationQuery);
                    insertStmt.setString(1, message);
                    insertStmt.setInt(2, renterId);
                    insertStmt.setInt(3, Integer.parseInt(motelRoomId));
                    insertStmt.executeUpdate();

                    response.getWriter().println("Notification sent successfully!");
                } else {
                    response.getWriter().println("No renter found for the provided motel room ID.");
                }

                conn.close();
            } catch (Exception e) {
                e.printStackTrace();
                response.getWriter().println("An error occurred while sending the notification: " + e.getMessage());
            }
        } else {
            response.getWriter().println("Motel Room ID and message are required.");
        }
    }
}
