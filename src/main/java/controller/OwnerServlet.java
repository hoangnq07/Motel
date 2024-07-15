package controller;
import Account.Account;
import dao.FeedbackDAO;
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
        String page = request.getParameter("page");
        Account account = (Account) request.getSession().getAttribute("user");
        List<Motel> motels = new ArrayList<>();
        if (page == null) {
            try {
                motels = MotelDAO.getMotelsByAccountId(account.getAccountId());
                request.setAttribute("motels", motels);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            request.getRequestDispatcher("owner.jsp").forward(request, response);
        }else{
            int motelId = -1;
            switch (page) {
                case "motel-list":
                    try {
                        motels = MotelDAO.getMotelsByAccountId(account.getAccountId());
                        request.setAttribute("motels", motels);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    break;
                case "room-list":
                case "notify":
                    try {
                            motelId = Integer.parseInt(request.getParameter("id"));
                            request.getSession().setAttribute("motelId", motelId);
                        } catch (Exception e) {
                            motelId = (int) request.getSession().getAttribute("motelId");
                        }
                        request.setAttribute("rooms", MotelRoomDAO.getMotelRoomsByMotelId(motelId));
                    break;
                case "createBill":

                    break;
                case "feedback":
                    try {
                        request.setAttribute("feedbacks", FeedbackDAO.getFeedbackForOwner(account.getAccountId()));
                    } catch (Exception e) {
                        throw new RuntimeException(e);
                    }
                    break;
                case "statics":
                    break;
            }
            request.getRequestDispatcher("motel-manage.jsp").forward(request, response);
        }

    }

}