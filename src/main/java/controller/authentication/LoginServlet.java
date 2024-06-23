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
import java.util.logging.Logger;

/**
 *
 * @author PC
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    private static final Logger LOGGER = Logger.getLogger(LoginServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();
        Account user = AccountDAO.authenticateUser(email, password);

        if (user != null) {
            int accountId = AccountDAO.getAccountIdByEmail(email); // Fetch accountId separately
            if (accountId != -1) {
                LOGGER.info("User authenticated successfully: " + accountId);
                session.setAttribute("accountId", accountId);
                session.setAttribute("user", AccountDAO.searchUser(email));

                if (user.getRole().equals("admin")) {
                    request.getRequestDispatcher("admin.jsp").forward(request, response);
                } else if (user.getRole().equals("owner")) {
                    request.getRequestDispatcher("owner.jsp").forward(request, response);
                } else if (user.getRole().equals("user")) {
                    request.getRequestDispatcher("home").forward(request, response);
                }
            } else {
                LOGGER.warning("Failed to fetch accountId for email: " + email);
                setErrorStatus("Thông tin đăng nhập không chính xác.", request);
                request.getRequestDispatcher("login.jsp").forward(request, response);
            }
        } else {
            LOGGER.warning("Authentication failed for email: " + email);
            setErrorStatus("Thông tin đăng nhập không chính xác.", request);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }


    private void setErrorStatus(String message, HttpServletRequest request) {
        request.setAttribute("status", message);
    }
}