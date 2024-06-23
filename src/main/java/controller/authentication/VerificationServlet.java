package controller.authentication;
import Account.Account;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
@WebServlet(name = "VerificationServlet", urlPatterns = {"/verify"})
public class VerificationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String enteredCode = request.getParameter("verificationCode");
        HttpSession session = request.getSession();
        String storedCode = (String) session.getAttribute("verificationCode");

        if (enteredCode.equals(storedCode)) {
            Account u = (Account) session.getAttribute("User");
            boolean registrationSuccess = AccountDAO.registerUser(u);

            if (registrationSuccess) {
                session.removeAttribute("verificationCode"); // Xóa mã xác nhận khỏi session
                response.sendRedirect("login.jsp");
            } else {
                request.setAttribute("status", "Registration failed.");
                request.getRequestDispatcher("registration.jsp").forward(request, response);
            }
        } else {
            // Mã xác nhận không hợp lệ, hiển thị thông báo lỗi
            request.setAttribute("status", "Invalid verification code.");
            request.getRequestDispatcher("verification.jsp").forward(request, response);
        }
    }
}