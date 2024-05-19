package controller;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

import Account.User;
import dao.AccountDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/UpdateProfileServlet")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user != null) {
            String fullName = request.getParameter("fullName");
            boolean gender = "1".equals(request.getParameter("gender"));
            String phone = request.getParameter("phone");
            String citizen = request.getParameter("citizen");
            String fileName = null;

            // Get the part representing the file upload
            Part filePart = request.getPart("avatar");

            // Get the file name
            String fileNameOrig = getFileName(filePart);
            if (fileNameOrig != null && !fileNameOrig.isEmpty()) {
                fileName = UUID.randomUUID().toString() + "_" + fileNameOrig; // Generate unique file name

                // Get the InputStream to store the file
                try (InputStream fileContent = filePart.getInputStream()) {
                    // Specify the directory to store the uploaded file
                    File uploadsDir = new File(getServletContext().getRealPath("/uploads"));
                    uploadsDir.mkdirs();

                    // Create a File object with the specified file name
                    File uploadedFile = new File(uploadsDir, fileName);

                    // Copy the contents of the InputStream to the uploaded file
                    Files.copy(fileContent, uploadedFile.toPath(), StandardCopyOption.REPLACE_EXISTING);
                }
            }

            // Update user information
            user.setFullname(fullName);
            user.setGender(gender);
            user.setPhone(phone);
            user.setCitizen(citizen);
            if (fileName != null) {
                user.setAvatar(fileName);
            }

            // Update user in database
            boolean isUpdated = AccountDAO.updateUser(user);

            // Redirect to appropriate page based on update result
            if (isUpdated) {
                session.setAttribute("user", user);
                response.sendRedirect("account_info.jsp");
            } else {
                request.setAttribute("error", "Failed to update profile.");
                request.getRequestDispatcher("update_profile.jsp").forward(request, response);
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    // Method to get the file name from the Part object
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        String[] tokens = contentDisposition.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }
}
