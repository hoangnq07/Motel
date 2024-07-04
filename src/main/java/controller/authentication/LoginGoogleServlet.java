package controller.authentication;

import Account.GooglePojo;
import Account.GoogleUtils;
import dao.AccountDAO;
import jakarta.servlet.RequestDispatcher;
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
@WebServlet("/login-google")
public class LoginGoogleServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    public LoginGoogleServlet() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String code = request.getParameter("code");
        if (code == null || code.isEmpty()) {
            RequestDispatcher dis = request.getRequestDispatcher("login.jsp");
            dis.forward(request, response);
        } else {
            String accessToken = GoogleUtils.getToken(code);
            GooglePojo googlePojo = GoogleUtils.getUserInfo(accessToken);
            String email = googlePojo.getEmail();
            request.setAttribute("id", googlePojo.getId());
            request.setAttribute("name", googlePojo.getName());
            request.setAttribute("email", googlePojo.getEmail());
            if (!AccountDAO.isEmailExist(email)) {
                AccountDAO.registerGoogle(email,googlePojo.getName());
            }
            request.getSession().setAttribute("user", AccountDAO.searchUser(email));
            response.sendRedirect("home");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
