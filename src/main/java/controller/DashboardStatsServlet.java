package controller;

import com.google.gson.Gson;
import dao.InvoiceDAO;
import Account.Account;
import model.StatsData;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet(name = "DashboardStatsServlet", value = "/dashboardStats")
public class DashboardStatsServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Lấy thông tin người dùng từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"User not logged in.\"}");
            out.flush();
            return;
        }

        Account user = (Account) session.getAttribute("user");
        if (user != null && "owner".equals(user.getRole())) {
            int accountId = user.getAccountId();

            try {
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                StatsData statsData = new StatsData(
                        invoiceDAO.getNumberOfRenters(accountId),
                        invoiceDAO.getNumberOfMotels(accountId),
                        invoiceDAO.getNumberOfRooms(accountId)
                );

                // Serialize statsData to JSON
                String json = new Gson().toJson(statsData);
                out.print(json);
                out.flush();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Unable to retrieve stats data.\"}");
                out.flush();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Access Denied. You must be an owner to view this page.\"}");
            out.flush();
        }
    }
}
