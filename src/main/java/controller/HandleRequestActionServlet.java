package controller;

import com.google.gson.Gson;
import dao.AccountDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "HandleRequestActionServlet", urlPatterns = {"/handleRequestActionServlet"})
public class HandleRequestActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        int accountId = Integer.parseInt(request.getParameter("accountId"));

        AccountDAO accountDAO = new AccountDAO();
        boolean success = false;

        if ("accept".equals(action)) {
            success = accountDAO.updateRoleAndStatus(accountId);
        } else if ("reject".equals(action)) {
            success = accountDAO.rejectRequest(requestId);
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();

        Response jsonResponse = new Response(success, "Request " + action + (success ? " successfully." : " failed."));
        out.print(gson.toJson(jsonResponse));

        out.flush();
    }

    public static class Response {
        private boolean success;
        private String message;

        public Response(boolean success, String message) {
            this.success = success;
            this.message = message;
        }

        public boolean isSuccess() {
            return success;
        }

        public void setSuccess(boolean success) {
            this.success = success;
        }

        public String getMessage() {
            return message;
        }

        public void setMessage(String message) {
            this.message = message;
        }
    }
}
