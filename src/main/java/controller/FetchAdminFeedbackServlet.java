package controller;

import com.google.gson.Gson;
import dao.FeedbackDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import model.Feedback;

import java.io.IOException;
import java.util.List;
//JSP xử lý servlet này nằm ở dashboard_admin dưới javascript
@WebServlet(name = "FetchAdminFeedbackServlet", value = "/fetchAdminFeedback")
public class FetchAdminFeedbackServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Không cần kiểm tra adminId vì chúng ta muốn lấy feedback cho tất cả admin
        FeedbackDAO dao = new FeedbackDAO();
        List<Feedback> feedbacks = dao.getFeedbacksForAdmin(); // Gọi phương thức không cần tham số adminId
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        new Gson().toJson(feedbacks, response.getWriter());
    }
}
