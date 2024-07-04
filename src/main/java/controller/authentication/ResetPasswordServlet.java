package controller.authentication;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 *
 * @author Admin
 */
@WebServlet("/reset-password")
public class ResetPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String newPassword = request.getParameter("newPassword");

        boolean passwordUpdated = AccountDAO.updatePassword(email, newPassword);

        if (passwordUpdated) {
            // Xóa mã xác nhận khỏi session
            request.setAttribute("message", "Password reset successfully");
        } else {
            request.setAttribute("error", "Failed to reset password");
        }

        request.getRequestDispatcher("result.jsp").forward(request, response);
    }
}
