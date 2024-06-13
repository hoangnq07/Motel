package controller;

import context.DBcontext;
import dao.MotelDAO;
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
        motels = MotelDAO.getAllMotels();
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
                existingMotel.setName(rs.getString("name"));
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
        String name = request.getParameter("name");
        String detailAddress = request.getParameter("detailAddress");
        String district = request.getParameter("district");
        String image = request.getParameter("image");
        String province = request.getParameter("province");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        String ward = request.getParameter("ward");
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        Motel motel = new Motel();
        motel.setName(name);
        motel.setDescriptions(descriptions);
        motel.setDetailAddress(detailAddress);
        motel.setDistrict(district);
        motel.setImage(image);
        motel.setProvince(province);
        motel.setStatus(status);
        motel.setWard(ward);
        motel.setAccountId(accountId);
        MotelDAO.addMotel(motel);
        response.sendRedirect("/Project/owner");
    }

    private void updateMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String name = request.getParameter("name");
        String descriptions = request.getParameter("descriptions");
        String detailAddress = request.getParameter("detailAddress");
        String district = request.getParameter("district");
        String image = request.getParameter("image");
        String province = request.getParameter("province");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        String ward = request.getParameter("ward");
        int accountId = Integer.parseInt(request.getParameter("accountId"));

        String sql = "UPDATE dbo.motels SET descriptions = ?, detail_address = ?, district = ?, image = ?, province = ?, status = ?, ward = ?, account_id = ? ,name =? WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, descriptions);
            stmt.setString(2, detailAddress);
            stmt.setString(3, district);
            stmt.setString(4, image);
            stmt.setString(5, province);
            stmt.setBoolean(6, status);
            stmt.setString(7, ward);
            stmt.setInt(8, accountId);
            stmt.setString(9, name);
            stmt.setInt(10, id);

            stmt.executeUpdate();
        }
        response.sendRedirect("/Project/owner");
    }

    private void deleteMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String sql = "DELETE FROM dbo.motels WHERE motel_id = ?";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, id);
            stmt.executeUpdate();
        }
        response.sendRedirect("/Project/motel");
    }
}
