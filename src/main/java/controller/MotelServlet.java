package controller;

import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Motel;

import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "MotelServlet", urlPatterns = {"/motel", "/motel/create", "/motel/update", "/motel/delete"})
public class MotelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/motel/create":
                    showCreateForm(request, response);
                    break;
                case "/motel/update":
                    showUpdateForm(request, response);
                    break;
                case "/motel/delete":
                    deleteMotel(request, response);
                    break;
                default:
                    listMotels(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/motel/create":
                    insertMotel(request, response);
                    break;
                case "/motel/update":
                    updateMotel(request, response);
                    break;
                default:
                    listMotels(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listMotels(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Motel> motels = new ArrayList<>();
        String sql = "SELECT * FROM dbo.motels";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql); ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Motel motel = new Motel();
                motel.setMotelId(rs.getInt("motel_id"));
                motel.setCreateDate(rs.getDate("create_date"));
                motel.setDescriptions(rs.getString("descriptions"));
                motel.setDetailAddress(rs.getString("detail_address"));
                motel.setDistrict(rs.getString("district"));
                motel.setDistrictId(rs.getString("district_id"));
                motel.setImage(rs.getString("image"));
                motel.setProvince(rs.getString("province"));
                motel.setProvinceId(rs.getString("province_id"));
                motel.setStatus(rs.getBoolean("status"));
                motel.setWard(rs.getString("ward"));
                motel.setAccountId(rs.getInt("account_id"));
                motels.add(motel);
            }
        }
        request.setAttribute("motels", motels);
        request.getRequestDispatcher("motel-list.jsp").forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/motel-form.jsp").forward(request, response);
    }

    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Motel existingMotel = new Motel();
        String sql = "SELECT * FROM dbo.motels WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                existingMotel.setMotelId(rs.getInt("motel_id"));
                existingMotel.setCreateDate(rs.getDate("create_date"));
                existingMotel.setDescriptions(rs.getString("descriptions"));
                existingMotel.setDetailAddress(rs.getString("detail_address"));
                existingMotel.setDistrict(rs.getString("district"));
                existingMotel.setDistrictId(rs.getString("district_id"));
                existingMotel.setImage(rs.getString("image"));
                existingMotel.setProvince(rs.getString("province"));
                existingMotel.setProvinceId(rs.getString("province_id"));
                existingMotel.setStatus(rs.getBoolean("status"));
                existingMotel.setWard(rs.getString("ward"));
                existingMotel.setAccountId(rs.getInt("account_id"));
            }
        }
        request.setAttribute("motel", existingMotel);
        request.getRequestDispatcher("/motel-form.jsp").forward(request, response);
    }

    private void insertMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String descriptions = request.getParameter("descriptions");
        String detailAddress = request.getParameter("detailAddress");
        String district = request.getParameter("district");
        String districtId = request.getParameter("districtId");
        String image = request.getParameter("image");
        String province = request.getParameter("province");
        String provinceId = request.getParameter("provinceId");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        String ward = request.getParameter("ward");
        int accountId = Integer.parseInt(request.getParameter("accountId"));

        String sql = "INSERT INTO dbo.motels (create_date, descriptions, detail_address, district, district_id, image, province, province_id, status, ward, account_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new Date(System.currentTimeMillis()));
            stmt.setString(2, descriptions);
            stmt.setString(3, detailAddress);
            stmt.setString(4, district);
            stmt.setString(5, districtId);
            stmt.setString(6, image);
            stmt.setString(7, province);
            stmt.setString(8, provinceId);
            stmt.setBoolean(9, status);
            stmt.setString(10, ward);
            stmt.setInt(11, accountId);
            stmt.executeUpdate();
        }
        response.sendRedirect("motel");
    }

    private void updateMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String descriptions = request.getParameter("descriptions");
        String detailAddress = request.getParameter("detailAddress");
        String district = request.getParameter("district");
        String districtId = request.getParameter("districtId");
        String image = request.getParameter("image");
        String province = request.getParameter("province");
        String provinceId = request.getParameter("provinceId");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        String ward = request.getParameter("ward");
        int accountId = Integer.parseInt(request.getParameter("accountId"));

        String sql = "UPDATE dbo.motels SET descriptions = ?, detail_address = ?, district = ?, district_id = ?, image = ?, province = ?, province_id = ?, status = ?, ward = ?, account_id = ? WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, descriptions);
            stmt.setString(2, detailAddress);
            stmt.setString(3, district);
            stmt.setString(4, districtId);
            stmt.setString(5, image);
            stmt.setString(6, province);
            stmt.setString(7, provinceId);
            stmt.setBoolean(8, status);
            stmt.setString(9, ward);
            stmt.setInt(10, accountId);
            stmt.setInt(11, id);
            stmt.executeUpdate();
        }
        response.sendRedirect("motel");
    }

    private void deleteMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String sql = "DELETE FROM dbo.motels WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
        response.sendRedirect("motel");
    }
}
