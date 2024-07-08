package controller;

import com.google.gson.Gson;
import dao.InvoiceDAO;
import Account.Account;
import model.RevenueData;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "RevenueDataServlet", value = "/getRevenueData")
public class RevenueDataServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Lấy ID của owner từ session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"User not logged in.\"}");
            out.flush();
            return;
        }

        Account user = (Account) session.getAttribute("user");
        if (user != null && "owner".equals(user.getRole())) {
            int ownerId = user.getAccountId();

            try {
                // Gọi phương thức DAO để lấy dữ liệu doanh thu
                InvoiceDAO invoiceDAO = new InvoiceDAO();
                List<RevenueData> revenueData = invoiceDAO.getMonthlyRevenueByOwnerId(ownerId);

                // Chuyển đổi dữ liệu thành JSON
                Gson gson = new Gson();
                String jsonData = gson.toJson(revenueData);
                out.print(jsonData);
                out.flush();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Unable to retrieve revenue data.\"}");
                out.flush();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Access Denied. You must be an owner to view this page.\"}");
            out.flush();
        }
    }
}
