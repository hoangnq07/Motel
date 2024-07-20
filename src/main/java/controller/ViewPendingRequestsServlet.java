package controller;

import dao.AccountDAO;
import model.RequestAuthority;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import Account.Account;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ViewPendingRequestsServlet", urlPatterns = {"/viewPendingRequests"})
public class ViewPendingRequestsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy account từ session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");

        // Kiểm tra nếu account không có trong session hoặc không phải admin
        if (account == null || !"admin".equals(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        List<RequestAuthority> pendingRequests = accountDAO.getPendingRequestAuthorities();

        request.setAttribute("pendingRequests", pendingRequests);
        RequestDispatcher dispatcher = request.getRequestDispatcher("/admincheckrequest.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
