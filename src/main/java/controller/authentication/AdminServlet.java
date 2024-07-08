package controller.authentication;
import com.google.gson.Gson;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Account.Account;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;
import java.sql.SQLDataException;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "AdminServlet", urlPatterns = {"/admin", "/fetchAllAccounts","/updateAccountStatus","/addAccount", "/updateAccount", "/fetchAccount", "/deleteAccount"})
public class AdminServlet extends HttpServlet {

    private static final int ITEMS_PER_PAGE = 10;
    private AccountDAO accountDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        accountDAO = new AccountDAO(); // Assume you have an AccountDAO class
        gson = new Gson();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/admin":
                request.getRequestDispatcher("/admin.jsp").forward(request, response);
                break;
            case "/fetchAllAccounts":
                fetchAllAccounts(request, response);
                break;
            case "/fetchAccount":
                fetchAccount(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getServletPath();

        switch (action) {
            case "/updateAccountStatus":
                updateAccountStatus(request, response);
                break;
            case "/addAccount":
                try {
                    addAccount(request, response);
                } catch (SQLDataException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "/updateAccount":
                try {
                    updateAccount(request, response);
                } catch (SQLDataException e) {
                    throw new RuntimeException(e);
                }
                break;
            case "/deleteAccount":
                deleteAccount(request, response);
                break;
            default:
                response.sendError(HttpServletResponse.SC_NOT_FOUND);
                break;
        }
    }

    private void deleteAccount(HttpServletRequest request, HttpServletResponse response) {
    }

    private void updateAccount(HttpServletRequest request, HttpServletResponse response) throws SQLDataException, IOException {
        // Đọc dữ liệu JSON từ request
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonString = sb.toString();

        // Chuyển đổi JSON thành đối tượng Java sử dụng Gson
        Gson gson = new Gson();
        Account account = gson.fromJson(jsonString, Account.class);
        boolean success = accountDAO.updateAccount(account);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        out.print("{\"success\":" + success + "}");
        out.flush();


    }

    private void addAccount(HttpServletRequest request, HttpServletResponse response) throws SQLDataException, IOException {
        // Đọc dữ liệu JSON từ request
        BufferedReader reader = request.getReader();
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = reader.readLine()) != null) {
            sb.append(line);
        }
        String jsonString = sb.toString();

        // Chuyển đổi JSON thành đối tượng Java sử dụng Gson
        Gson gson = new Gson();
        Account account = gson.fromJson(jsonString, Account.class);
        boolean success = accountDAO.addAccount(account);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = null;
        try {
            out = response.getWriter();
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
        out.print("{\"success\":" + success + "}");
        out.flush();
        
    }


    private void updateAccountStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        boolean isActive = Boolean.parseBoolean(request.getParameter("active"));

        boolean success = accountDAO.updateAccountStatus(accountId, isActive);

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        out.print("{\"success\":" + success + "}");
        out.flush();
    }
    private void fetchAllAccounts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Account> accounts = accountDAO.getAllAccount();
        int totalAccounts = accounts.size();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(accounts));
        out.flush();
    }
    private void fetchAccount(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        Account account = accountDAO.getAccountById(accountId);
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        out.print(gson.toJson(account));
        out.flush();
    }
}