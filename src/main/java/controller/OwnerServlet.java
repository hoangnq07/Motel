package controller;
import Account.Account;
import dao.MotelDAO;
import dao.MotelRoomDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Motel;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "OwnerServlet", value = "/owner")
public class OwnerServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<Motel> motels = new ArrayList<>();
        Account account = (Account) request.getSession().getAttribute("user");
        try {
            motels = MotelDAO.getMotelsByAccountId(account.getAccountId());
            request.setAttribute("motels", motels);
            request.setAttribute("rooms", MotelRoomDAO.getMotelRoomsByMotelId(account.getAccountId()));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("owner.jsp").forward(request, response);
    }

}