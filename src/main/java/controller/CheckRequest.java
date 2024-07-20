package controller;

import dao.AccountDAO;
import model.RequestAuthority;
import Account.Account;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "CheckRequest", urlPatterns = {"/checkRequest"})
public class CheckRequest extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");
        Integer accountId = account != null ? account.getAccountId() : null;

        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        List<RequestAuthority> requestAuthorities = accountDAO.getRequestAuthoritiesByAccountId(accountId);

        boolean hasPendingOrAcceptedRequest = false;
        for (RequestAuthority requestAuthority : requestAuthorities) {
            if (!"Bị từ chối".equals(requestAuthority.getRequestAuthorityStatus())) {
                hasPendingOrAcceptedRequest = true;
                break;
            }
        }

        if (hasPendingOrAcceptedRequest) {
            response.sendRedirect(request.getContextPath() + "/userRequestAuthorityServlet");
        } else {
            response.sendRedirect(request.getContextPath() + "/requestAuthority.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
