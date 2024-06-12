package controller;

import Account.Account;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

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
        Account user = AccountDAO.authenticateUser(email, password);
        if (user != null) {
            if (user.getRole().equals("admin")) {
                session.setAttribute("user", AccountDAO.searchUser(email));
                request.getRequestDispatcher("admin.jsp").forward(request, response);
            }else if (user.getRole().equals("owner")){
                session.setAttribute("user", AccountDAO.searchUser(email));
                request.getRequestDispatcher("owner").forward(request, response);

            }else if (user.getRole().equals("user")) {
                session.setAttribute("user", AccountDAO.searchUser(email));
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
