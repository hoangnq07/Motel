package controller;

import dao.AccountDAO;
import dao.RenterDAO;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import Account.Account;
import model.Renter;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

@WebServlet("/RenterServlet")
public class RenterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RenterDAO renterDAO;

    public void init() {
        renterDAO = new RenterDAO();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Nhận dữ liệu từ form
        int motelRoomId = Integer.parseInt(request.getParameter("motelRoomId"));
        String email = request.getParameter("email");
        String renterDateString = request.getParameter("renterDate");

        // Chuyển đổi chuỗi ngày thuê thành đối tượng Date
        Date renterDate = null;
        try {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            renterDate = dateFormat.parse(renterDateString);
        } catch (ParseException e) {
            e.printStackTrace();
        }

        if (renterDate != null) {
            // Tìm account bằng email
            Account account = AccountDAO.searchUser(email);

            if (account != null) {
                // Tính toán ngày checkout (cộng thêm 30 ngày)
                Calendar calendar = Calendar.getInstance();
                calendar.setTime(renterDate);
                calendar.add(Calendar.DAY_OF_MONTH, 30);
                Date checkoutDate = calendar.getTime();

                // Tạo một renter mới
                Renter newRenter = new Renter();
                newRenter.setRenterId(account.getAccountId());
                newRenter.setRenterDate(renterDate);
                newRenter.setCheckOutDate(checkoutDate);
                newRenter.setMotelRoomId(motelRoomId);

                // Thêm renter vào cơ sở dữ liệu
                renterDAO.addRenter(newRenter);

                // Gửi thông báo thành công
                request.setAttribute("successMessage", "Renter đã được thêm thành công!");
            } else {
                // Gửi thông báo thất bại
                request.setAttribute("errorMessage", "Không tìm thấy tài khoản với email: " + email);
            }
        } else {
            // Gửi thông báo thất bại nếu ngày thuê không hợp lệ
            request.setAttribute("errorMessage", "Ngày thuê không hợp lệ!");
        }
        // Forward (chuyển tiếp) đến renter.jsp
        request.getRequestDispatcher("renters.jsp").forward(request, response);
    }
}
