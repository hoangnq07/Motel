package controller;

import context.DBcontext;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.Renter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/RentersServlet")
public class RentersServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
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
                displayAllRenter(request, conn);
            }
            searchRenter(request, conn);
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

        String sql = "INSERT INTO renter (renter_date, check_out_date, account_id) VALUES (?, ?, (SELECT account_id FROM accounts WHERE fullname=? AND email=? AND phone=?))";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, renterDate);
            pstmt.setString(2, checkOutDate);
            pstmt.setString(3, fullname);
            pstmt.setString(4, email);
            pstmt.setString(5, phone);
            pstmt.executeUpdate();
        }
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

        String sql = "UPDATE renter SET renter_date=?, check_out_date=?, account_id=(SELECT account_id FROM accounts WHERE fullname=? AND email=? AND phone=?) WHERE renter_id=?";
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, renterDate);
            pstmt.setString(2, checkOutDate);
            pstmt.setString(3, fullname);
            pstmt.setString(4, email);
            pstmt.setString(5, phone);
            pstmt.setInt(6, renterId);
            pstmt.executeUpdate();
        }
    }

    private void searchRenter(HttpServletRequest request, Connection conn) throws SQLException {
        String searchQuery = request.getParameter("searchQuery");
        String sql = "SELECT r.*, a.fullname, a.email, a.phone FROM renter r JOIN accounts a ON r.account_id = a.account_id";
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql += " WHERE a.fullname LIKE ?";
        }

        List<Renter> rentersList = new ArrayList<>();
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            if (searchQuery != null && !searchQuery.trim().isEmpty()) {
                pstmt.setString(1, "%" + searchQuery + "%");
            }
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                Renter renter = new Renter();
                renter.setRenterId(rs.getInt("renter_id"));
                renter.setFullname(rs.getString("fullname"));
                renter.setEmail(rs.getString("email"));
                renter.setPhone(rs.getString("phone"));
                renter.setRenterDate(rs.getString("renter_date"));
                renter.setCheckOutDate(rs.getString("check_out_date"));
                rentersList.add(renter);
            }
        }

        request.setAttribute("rentersList", rentersList);
    }

    private void displayAllRenter(HttpServletRequest request, Connection conn) throws SQLException {
        String sql = "SELECT r.*, a.fullname, a.email, a.phone FROM renter r JOIN accounts a ON r.account_id = a.account_id";
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
                rentersList.add(renter);
            }
        }

        request.setAttribute("rentersList", rentersList);
    }
    private List<Renter> getRentersList(Connection conn) throws SQLException {
        String sql = "SELECT r.*, a.fullname, a.email, a.phone FROM renter r JOIN accounts a ON r.account_id = a.account_id";
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
                rentersList.add(renter);
            }
        }
        return rentersList;
    }
}

