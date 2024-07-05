package controller;

import dao.AccountDAO;
import Account.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/searchAccounts")
public class SearchAccountsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        String motelRoomId = request.getParameter("motelRoomId");

        try {
            AccountDAO accountDAO = new AccountDAO();
            List<Account> accounts = accountDAO.searchAccounts(searchTerm);

            request.setAttribute("accounts", accounts);
            request.setAttribute("motelRoomId", motelRoomId);
            request.getRequestDispatcher("/WEB-INF/partials/search_results.jsp").forward(request, response);
        } catch (SQLException e) {
            response.getWriter().write("<p>An error occurred while searching for accounts.</p>");
        }
    }
}