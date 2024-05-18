package controller;

import Account.User;
import dao.AccountDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 *
 * @author PC
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/register"})
public class RegisterServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String pass = request.getParameter("pass");
        String phone = request.getParameter("phone");

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

        User u = new User(email, pass, phone);
        boolean registrationSuccess = AccountDAO.registerUser(u);

        if (registrationSuccess) {
            response.sendRedirect("login.jsp");
        } else {
            request.setAttribute("status", "Registration failed.");
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
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    public static void main(String[] args) {
        System.out.println("hi");
    }
}
