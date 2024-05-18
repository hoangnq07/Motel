
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
@WebServlet(name="LoginServlet", urlPatterns={"/login"})
public class LoginServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

//        validateInput(email, password, request);

        if (AccountDAO.authenticateUser(email, password)) {
            session.setAttribute("login", AccountDAO.searchUser(email));
            request.getRequestDispatcher("home").forward(request, response);
        } else {
            setErrorStatus("Thông tin đăng nhập không chính xác.", request);
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }

//    private void validateInput(String username, String password, HttpServletRequest request) {
//        if (username == null || username.isEmpty() || username.length() < 6) {
//            setErrorStatus("Tên đăng nhập phải từ 6 kí tự trở lên.", request);
//        }
//        if (password == null || password.isEmpty() || password.length() < 8) {
//            setErrorStatus("Mật khẩu phải từ 8 kí tự trở lên.", request);
//        }
//    }

    private void setErrorStatus(String message, HttpServletRequest request) {
        request.setAttribute("status", message);
    }
}

