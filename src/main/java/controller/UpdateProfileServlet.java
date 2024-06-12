package controller;

import Account.Account;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Account user = (Account) session.getAttribute("user");

        if (user != null) {
            String fullName = request.getParameter("fullName");
            boolean gender = "1".equals(request.getParameter("gender"));
            String phone = request.getParameter("phone");
            String citizen = request.getParameter("citizen");
            String fileName = null;

            try {
                Part filePart = request.getPart("avatar");
                String fileNameOrig = getFileName(filePart);

                if (fileNameOrig != null && !fileNameOrig.isEmpty()) {
                    fileName = UUID.randomUUID().toString() + "_" + fileNameOrig;

                    File uploadsDir = new File(getServletContext().getRealPath("/uploads"));
                    if (!uploadsDir.exists() && !uploadsDir.mkdirs()) {
                        throw new IOException("Failed to create upload directory");
                    }

                    try (InputStream fileContent = filePart.getInputStream()) {
                        File uploadedFile = new File(uploadsDir, fileName);
                        Files.copy(fileContent, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                    }
                }

                user.setFullname(fullName);
                user.setGender(gender);
                user.setPhone(phone);
                user.setCitizenId(citizen);
                if (fileName != null) {
                    user.setAvatar(fileName);
                }

                boolean isUpdated = AccountDAO.updateUser(user);

                if (isUpdated) {
                    session.setAttribute("user", user);
                    response.sendRedirect("account_info.jsp");
                } else {
                    request.setAttribute("error", "Failed to update profile. Please try again.");
                    request.getRequestDispatcher("account_info.jsp").forward(request, response);
                }
            } catch (Exception e) {
                request.setAttribute("error", "An error occurred while updating the profile: " + e.getMessage());
                request.getRequestDispatcher("account_info.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
