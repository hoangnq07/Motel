package controller;

import Account.Account;
import com.google.gson.Gson;
import dao.RenterDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Feedback;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "FeedbackHistoryServlet", value = "/showFeedbackHistory")
public class FeedbackHistoryServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        int userId = ((Account) session.getAttribute("user")).getAccountId();
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        try {
            List<Feedback> feedbacks = new RenterDAO().getFeedbackHistory(userId); // Ensure RenterDAO has getFeedbackHistory method
            String jsonResponse = new Gson().toJson(feedbacks);
            out.print(jsonResponse);
            out.flush();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print("{\"error\":\"Error retrieving feedback history\"}");
            out.flush();
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Handle POST request if needed
    }
}
