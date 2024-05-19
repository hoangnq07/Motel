package controller;

import Account.User;
import dao.AccountDAO;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.AddressException;
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
 * @author PC
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, AddressException, MessagingException {
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String phone = request.getParameter("phone");
        User u = new User(email, pass, phone);
        // Kiểm tra xem email đã tồn tại hay chưa
        if (AccountDAO.isEmailExist(email)) {
            request.setAttribute("status", "Email already exists.");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }
        // Kiểm tra mật khẩu có đủ tiêu chuẩn hay không
        if (!isValidPassword(pass)) {
            request.setAttribute("status", "Password must be at least 8 characters long and contain at least one digit, one lowercase letter, one uppercase letter, and one special character.");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
            return;
        }
        // Tạo mã xác nhận ngẫu nhiên gồm 6 chữ số
        String verificationCode = String.format("%06d", new Random().nextInt(999999));
        // Lưu mã xác nhận vào session
        HttpSession session = request.getSession();
        session.setAttribute("verificationCode", verificationCode);
        // Gửi email chứa mã xác nhận
        String to = email; // Địa chỉ email người nhận
        String subject = "Verification Code";
        String body = "Your verification code is: " + verificationCode;
        // Gửi email chứa mã xác nhận
        boolean emailSent = EmailSender.sendEmail(to, subject, body);

        if (emailSent) {
            // Chuyển hướng đến trang xác nhận mã
            session.setAttribute("email", email);
            session.setAttribute("User", u);
            request.getRequestDispatcher("verification.jsp").forward(request, response);
        } else {
            // Xử lý lỗi gửi email
            request.setAttribute("status", "Failed to send verification email.");
            request.getRequestDispatcher("registration.jsp").forward(request, response);
        }

    }
    private static final int MIN_PASSWORD_LENGTH = 8;
    private static final String PASSWORD_PATTERN = "^(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[@#$%^&+=])(?=\\S+$).{8,}$";

    private boolean isValidPassword(String password) {
        // Kiểm tra độ dài
        if (password.length() < MIN_PASSWORD_LENGTH) {
            return false;
        }

        // Kiểm tra mật khẩu có chứa ít nhất một chữ số, một chữ cái viết thường,
        // một chữ cái viết hoa và một ký tự đặc biệt hay không
        return password.matches(PASSWORD_PATTERN);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {

        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            processRequest(request, response);
        } catch (MessagingException ex) {

        }
    }

    public static void main(String[] args) {
    }
}
