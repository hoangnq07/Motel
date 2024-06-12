package controller;

import context.DBcontext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/approveAuthority")
public class AdminApproveAuthorityServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String respDescriptions = request.getParameter("respDescriptions");
        String status = request.getParameter("status");

        Connection conn = null;
        PreparedStatement stmt = null;
        PreparedStatement updateRoleStmt = null;

        try {
            conn = DBcontext.getConnection();
            conn.setAutoCommit(false);

            String sql = "UPDATE dbo.request_authority SET respdescriptions = ?, request_authority_status = ? WHERE request_authority_id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, respDescriptions);
            stmt.setString(2, status);
            stmt.setInt(3, requestId);
            stmt.executeUpdate();

            if ("Approved".equals(status)) {
                String updateRoleSql = "UPDATE dbo.accounts SET role = 'owner' WHERE account_id = (SELECT account_id FROM dbo.request_authority WHERE request_authority_id = ?)";
                updateRoleStmt = conn.prepareStatement(updateRoleSql);
                updateRoleStmt.setInt(1, requestId);
                updateRoleStmt.executeUpdate();
            }

            conn.commit();

            response.sendRedirect(request.getContextPath() + "/authorityRequests.jsp");

        } catch (SQLException e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            throw new ServletException(e);
        } finally {
            if (updateRoleStmt != null) try { updateRoleStmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}
