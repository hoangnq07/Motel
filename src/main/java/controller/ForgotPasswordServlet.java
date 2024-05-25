/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Random;

/**
 *
 * @author Admin
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession();
        // Kiểm tra xem email có tồn tại trong cơ sở dữ liệu hay không
        if (AccountDAO.isEmailExist(email)) {
            // Tạo mã xác nhận ngẫu nhiên
            String verificationCode = String.format("%06d", new Random().nextInt(999999));

            // Lưu mã xác nhận vào session
            session.setAttribute("verificationCode_" + email, verificationCode);

            // Gửi email chứa liên kết đổi mật khẩu
            String resetLink = request.getRequestURL().toString()
                    + "?action=reset&email=" + email + "&code=" + verificationCode;
            String subject = "Reset Password";
            String body = "Click the following link to reset your password: " + resetLink;

            boolean emailSent = EmailSender.sendEmail(email, subject, body);

            if (emailSent) {
                request.setAttribute("message", "An email with instructions to reset your password has been sent to your email address.");
            } else {
                request.setAttribute("error", "Failed to send reset password email");
            }

            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Email not found");
            request.getRequestDispatcher("forgot-password.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("reset-password.jsp").forward(req, resp);
    }
    
}
