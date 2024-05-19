/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller;

import Account.User;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.regex.Pattern;
import org.mindrot.jbcrypt.BCrypt;


@WebServlet("/ChangePasswordServlet")
public class ChangePasswordServlet extends HttpServlet {

    private static final String PASSWORD_PATTERN =
            "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,20}$";

    private static boolean validatePassword(String password) {
        return Pattern.compile(PASSWORD_PATTERN).matcher(password).matches();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String email = user.getEmail();
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        // Kiểm tra xem mật khẩu mới và xác nhận mật khẩu mới có khớp nhau không
        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("status", "New password and confirmation do not match.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Kiểm tra xem mật khẩu mới có đủ an toàn không
        if (!validatePassword(newPassword)) {
            request.setAttribute("status", "Password does not meet security requirements.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }

        // Xác thực mật khẩu hiện tại
        User authenticatedUser = AccountDAO.authenticateUser(email, currentPassword);
        if (authenticatedUser == null) {
            request.setAttribute("status", "Current password is incorrect.");
            request.getRequestDispatcher("change_password.jsp").forward(request, response);
            return;
        }


        // Cập nhật mật khẩu mới
        boolean success = AccountDAO.updatePassword(email, newPassword);
        if (success) {
            request.setAttribute("status", "Password has been changed successfully.");
        } else {
            request.setAttribute("status", "Failed to change password.");
        }
        request.getRequestDispatcher("change_password.jsp").forward(request, response);
    }
}