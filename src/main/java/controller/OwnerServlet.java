package controller;

import Account.Account;
import dao.MotelDAO;
import dao.MotelRoomDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Motel;
import model.MotelRoom;
import org.apache.http.client.fluent.Response;

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
            request.setAttribute("rooms", MotelRoomDAO.getMotelRoomsByMotelId(2));
        } catch (SQLException e) {
            response.sendRedirect("404.jsp");
        }
        request.getRequestDispatcher("owner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}