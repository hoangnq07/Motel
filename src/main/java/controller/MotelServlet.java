package controller;
import Account.Account;
import context.DBcontext;
import dao.MotelDAO;
import dao.MotelRoomDAO;
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

@WebServlet(name = "MotelServlet", urlPatterns = {"/motel", "/motel/create", "/motel/update", "/motel/delete","/motel/manage"})
public class MotelServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/motel/create":
                    request.getRequestDispatcher("/motel-form.jsp").forward(request, response);
                    break;
                case "/motel/update":
                    showUpdateForm(request, response);
                    break;
                case "/motel/delete":
                    deleteMotel(request, response);
                    break;
                case "/motel/manage":
                    List<Motel> motels = new ArrayList<>();
                    Account account = (Account) request.getSession().getAttribute("user");
                    motels = MotelDAO.getMotelsByAccountId(account.getAccountId());
                    request.setAttribute("motels", motels);
                    request.setAttribute("rooms", MotelRoomDAO.getMotelRoomsByMotelId(Integer.parseInt(request.getParameter("id"))));
                    request.getRequestDispatcher("/motel-manage.jsp").forward(request, response);
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


    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Motel existingMotel = new Motel();
        existingMotel = MotelDAO.getMotelById(id);
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
        MotelDAO.updateMotel(new Motel(id, name, new Date(System.currentTimeMillis()), descriptions, detailAddress, district, image, province, status, ward, accountId));
        response.sendRedirect("/Project/owner");
    }

    private void deleteMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MotelDAO.deleteMotel(id);
        response.sendRedirect("/Project/motel");
    }
}
