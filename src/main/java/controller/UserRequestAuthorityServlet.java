package controller;

import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.RequestAuthority;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet(name = "UserRequestAuthorityServlet", urlPatterns = {"/requestAuthority"})
public class UserRequestAuthorityServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        int accountId = (int) session.getAttribute("accountId");
        String image = request.getParameter("image");
        String descriptions = request.getParameter("descriptions");

        String sql = "INSERT INTO dbo.request_authority (image, createdate, descriptions, account_id, request_authority_status) " +
                "VALUES (?, GETDATE(), ?, ?, 'Pending')";

        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, image);
            stmt.setString(2, descriptions);
            stmt.setInt(3, accountId);
            stmt.executeUpdate();
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        response.sendRedirect("requestAuthority.jsp?status=success");
    }
}
