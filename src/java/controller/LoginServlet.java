package controller;

import dao.AccountDAO;
import Account.User;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author PC
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();
        User user = AccountDAO.authenticateUser(email, password);
        if (user != null) {
            if (user.getRole().equals("admin")) {
                session.setAttribute("login", AccountDAO.searchUser(email));
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            } else if (user.getRole().equals("user")) {
                session.setAttribute("login", AccountDAO.searchUser(email));
                request.getRequestDispatcher("home").forward(request, response);
            }
        } else {
            setErrorStatus("Thông tin đăng nhập không chính xác.", request);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }


    private void setErrorStatus(String message, HttpServletRequest request) {
        request.setAttribute("status", message);
    }
}
