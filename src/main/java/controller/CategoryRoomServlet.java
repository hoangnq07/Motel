package controller;
import com.google.gson.Gson;
import dao.CategoryRoomDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.CategoryRoom;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

@WebServlet(name = "CategoryRoomServlet", urlPatterns = {"/categories"})
public class CategoryRoomServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        List<CategoryRoom> categories = CategoryRoomDAO.getCategoryList();
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        try (PrintWriter out = response.getWriter()) {
            Gson gson = new Gson();
            out.print(gson.toJson(categories));
            out.flush();
        }
    }
}
