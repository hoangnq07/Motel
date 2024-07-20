package controller;

import com.google.gson.Gson;
import dao.AccountDAO;
import Account.Account;
import dao.FeedbackDAO;
import model.Feedback;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet(name = "OwnerFeedbacksServlet", value = "/getOwnerFeedbacks")
public class OwnerFeedbacksServlet extends HttpServlet {
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
            int ownerId = user.getAccountId();

            try {
                FeedbackDAO feedbackDAO = new FeedbackDAO();
                List<Feedback> feedbackList = feedbackDAO.getFeedbacksReceivedByOwner(ownerId);

                // Chuyển đổi danh sách feedback thành JSON
                Gson gson = new Gson();
                String jsonData = gson.toJson(feedbackList);
                out.print(jsonData);
                out.flush();
            } catch (SQLException | ClassNotFoundException e) {
                e.printStackTrace();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print("{\"error\": \"Unable to retrieve feedback list.\"}");
                out.flush();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print("{\"error\": \"Access Denied. You must be an owner to view this page.\"}");
            out.flush();
        }
    }
}
