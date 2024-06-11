package controller;

import context.DBcontext;
import dao.Renter;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RentersServlet")
public class RentersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

        try {
            DBcontext dbContext = new DBcontext();
            Connection conn = dbContext.getConnection();

            // Lấy account_id từ email
            String sqlSelect = "SELECT account_id FROM dbo.accounts WHERE email = ?";
            PreparedStatement psSelect = conn.prepareStatement(sqlSelect);
            psSelect.setString(1, email);
            int accountId = -1;
            var rs = psSelect.executeQuery();
            if (rs.next()) {
                accountId = rs.getInt("account_id");
            }

            if (accountId != -1) {
                // Thêm người thuê vào phòng trọ
                String sqlInsert = "INSERT INTO dbo.renter (renter_id, renter_date, motel_room_id) VALUES (?, GETDATE(), ?)";
                PreparedStatement psInsert = conn.prepareStatement(sqlInsert);
                psInsert.setInt(1, accountId);
                psInsert.setInt(2, motelRoomId);
                psInsert.executeUpdate();
            }

            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }

        response.sendRedirect("renters.jsp");
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try (Connection conn = DBcontext.getConnection()) {
            if ("add".equals(action)) {
                addRenter(request, conn);
            } else if ("delete".equals(action)) {
                deleteRenter(request, conn);
            } else if ("update".equals(action)) {
                updateRenter(request, conn);
            } else {
                getRentersList(request, conn); // Default action to display all renters
            }
            request.setAttribute("rentersList", getRentersList(request, conn));
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        request.getRequestDispatcher("/renters.jsp").forward(request, response);
    }

    private void addRenter(HttpServletRequest request, Connection conn) throws SQLException {
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String renterDate = request.getParameter("renterDate");
        String checkOutDate = request.getParameter("checkOutDate");
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

        // Kiểm tra xem motel_room_id có tồn tại không
        if (!motelRoomExists(motelRoomId, conn)) {
            throw new SQLException("Motel room ID does not exist.");
        }

        String sql = "INSERT INTO renter (account_id, renter_date, check_out_date, motel_room_id) VALUES ((SELECT account_id FROM accounts WHERE email = ?), ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, email);
            pstmt.setString(2, renterDate);
            pstmt.setString(3, checkOutDate);
            pstmt.setInt(4, motelRoomId);
            pstmt.executeUpdate();
        }
    }

    private boolean motelRoomExists(int motelRoomId, Connection conn) throws SQLException {
        String sql = "SELECT COUNT(*) FROM motel_room WHERE motel_room_id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, motelRoomId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        }
        return false;
    }

    private void deleteRenter(HttpServletRequest request, Connection conn) throws SQLException {
        int renterId = Integer.parseInt(request.getParameter("renterId"));

        String sql = "DELETE FROM renter WHERE renter_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, renterId);
            pstmt.executeUpdate();
        }
    }

    private void updateRenter(HttpServletRequest request, Connection conn) throws SQLException {
        int renterId = Integer.parseInt(request.getParameter("renterId"));
        String fullname = request.getParameter("fullname");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String renterDate = request.getParameter("renterDate");
        String checkOutDate = request.getParameter("checkOutDate");
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));

        // Kiểm tra xem motel_room_id có tồn tại không
        if (!motelRoomExists(motelRoomId, conn)) {
            throw new SQLException("Motel room ID does not exist.");
        }

        String sql = "UPDATE renter SET renter_date=?, check_out_date=?, motel_room_id=? WHERE renter_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, renterDate);
            pstmt.setString(2, checkOutDate);
            pstmt.setInt(3, motelRoomId);
            pstmt.setInt(4, renterId);
            pstmt.executeUpdate();
        }
    }

    private List<Renter> getRentersList(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = "SELECT r.renter_id, r.renter_date, r.check_out_date, r.motel_room_id, a.fullname, a.email, a.phone FROM renter r JOIN accounts a ON r.account_id = a.account_id";
        List<Renter> rentersList = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                renter.setFullname(rs.getString("fullname"));
                renter.setEmail(rs.getString("email"));
                renter.setPhone(rs.getString("phone"));
                renter.setRenterDate(rs.getString("renter_date"));
                renter.setCheckOutDate(rs.getString("check_out_date"));
                renter.setMotelRoomId(rs.getInt("motel_room_id"));
                rentersList.add(renter);
            }
        }
        return rentersList;
    }
}