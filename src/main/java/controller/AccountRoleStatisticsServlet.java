package controller;

import com.google.gson.Gson;
import dao.AccountDAO;
import dao.MotelDAO;
import Account.Account;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;

@WebServlet(name = "AccountRoleStatisticsServlet", urlPatterns = {"/accountRoleStatistics"})
public class AccountRoleStatisticsServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        AccountDAO accountDAO = new AccountDAO();
        MotelDAO motelDAO = new MotelDAO();

        Map<String, Integer> roleCounts;
        roleCounts = accountDAO.getAccountCountsByRole();

        int totalMotels = motelDAO.getTotalMotels();
        int totalRooms = motelDAO.getTotalRooms();
        int totalRenters = motelDAO.getTotalRenters();

        Map<String, Object> combinedData = new HashMap<>();
        combinedData.put("roleCounts", roleCounts);
        combinedData.put("totalMotels", totalMotels);
        combinedData.put("totalRooms", totalRooms);
        combinedData.put("totalRenters", totalRenters);

        Gson gson = new Gson();
        String json = gson.toJson(combinedData);
        out.print(json);
        out.flush();
    }
}
