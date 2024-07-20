package controller;

import dao.AccountDAO;
import model.RequestAuthority;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import Account.Account;
import java.io.File;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "UserRequestAuthorityServlet", urlPatterns = {"/userRequestAuthorityServlet"})
@MultipartConfig
public class UserRequestAuthorityServlet extends HttpServlet {

    private static final String UPLOAD_DIR = "images";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");

        // Lấy accountId từ session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");
        Integer accountId = account != null ? account.getAccountId() : null;

        // Kiểm tra nếu accountId không có trong session
        if (accountId == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AccountDAO accountDAO = new AccountDAO();
        List<RequestAuthority> requestAuthorities = accountDAO.getRequestAuthoritiesByAccountId(accountId);

        boolean hasPendingRequest = requestAuthorities.stream()
                .anyMatch(ra -> "Chưa xử lý".equals(ra.getRequestAuthorityStatus()));

        if (hasPendingRequest) {
            request.setAttribute("errorMessage", "Bạn đã gửi yêu cầu trước đó và đang chờ xử lý. Bạn không thể gửi yêu cầu mới.");
            request.setAttribute("requestAuthorities", requestAuthorities);
            RequestDispatcher dispatcher = request.getRequestDispatcher("/requestAuthority.jsp");
            dispatcher.forward(request, response);
            return;
        }

        // Retrieve form fields
        String descriptions = request.getParameter("descriptions");
        Part idCardPart = request.getPart("imageidcard");
        Part docPart = request.getPart("imagedoc");

        // Get application path
        String applicationPath = request.getServletContext().getRealPath("");
        String idCardUploadPath = applicationPath + File.separator + UPLOAD_DIR + File.separator + "imageidcard";
        String docUploadPath = applicationPath + File.separator + UPLOAD_DIR + File.separator + "imagedoc";

        // Create upload folders if they don't exist
        createDirectoryIfNotExists(idCardUploadPath);
        createDirectoryIfNotExists(docUploadPath);

        // Save files
        String imageIdCardPath = saveFile(idCardPart, idCardUploadPath);
        String imageDocPath = saveFile(docPart, docUploadPath);

        // Get relative paths
        String relativeIdCardPath = UPLOAD_DIR + File.separator + "imageidcard" + File.separator + imageIdCardPath;
        String relativeDocPath = UPLOAD_DIR + File.separator + "imagedoc" + File.separator + imageDocPath;

        // Use DAO to submit the request
        boolean success = accountDAO.submitRequestAuthority(accountId, descriptions, relativeIdCardPath, relativeDocPath);

        // Lấy dữ liệu yêu cầu từ cơ sở dữ liệu
        requestAuthorities = accountDAO.getRequestAuthoritiesByAccountId(accountId);

        // Chuyển tiếp thông tin đến JSP
        request.setAttribute("success", success);
        request.setAttribute("requestAuthorities", requestAuthorities);

        // Chuyển tiếp đến JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("/requestAuthority.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy accountId từ session
        HttpSession session = request.getSession();
        Account account = (Account) session.getAttribute("user");
        Integer accountId = account != null ? account.getAccountId() : null;

        if (accountId != null) {
            AccountDAO accountDAO = new AccountDAO();
            List<RequestAuthority> requestAuthorities = accountDAO.getRequestAuthoritiesByAccountId(accountId);

            request.setAttribute("requestAuthorities", requestAuthorities);
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("/requestAuthority.jsp");
        dispatcher.forward(request, response);
    }

    private void createDirectoryIfNotExists(String path) {
        File directory = new File(path);
        if (!directory.exists()) {
            directory.mkdirs();
        }
    }

    private String saveFile(Part filePart, String uploadPath) throws IOException {
        String fileName = extractFileName(filePart);
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);
        return fileName;
    }

    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] items = contentDisposition.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }
}
