package controller;
import Account.Account;
import dao.MotelDAO;
import dao.MotelRoomDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import model.Motel;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

@MultipartConfig
@WebServlet(name = "MotelServlet", urlPatterns = {"/motel", "/motel/create", "/motel/update", "/motel/delete"})
public class MotelServlet extends HttpServlet {
    private static final String UPLOAD_DIRECTORY = "images";
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/motel/create":
                    request.getRequestDispatcher("/motelForm.jsp").forward(request, response);
                    break;
                case "/motel/update":
                    showUpdateForm(request, response);
                    break;
                case "/motel/delete":
                    deleteMotel(request, response);
                    break;
                default:
                    listMotels(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getServletPath();

        try {
            switch (action) {
                case "/motel/create":
                    createMotel(request, response);
                    break;
                case "/motel/update":
                    updateMotel(request, response);
                    break;
                default:
                    listMotels(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    private void listMotels(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        List<Motel> motels = new ArrayList<>();
        motels = MotelDAO.getAllMotels();
        request.setAttribute("motels", motels);
        request.getRequestDispatcher("motel-list.jsp").forward(request, response);
    }


    private void showUpdateForm(HttpServletRequest request, HttpServletResponse response) throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        Motel existingMotel = new Motel();
        existingMotel = MotelDAO.getMotelById(id);
        request.setAttribute("motel", existingMotel);
        request.getRequestDispatcher("/motelForm.jsp").forward(request, response);
    }

    private void createMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String descriptions = request.getParameter("descriptions");
        String name = request.getParameter("name");
        String detailAddress = request.getParameter("detailAddress");
        String province = request.getParameter("province");
        String provinceText = request.getParameter("provinceText");
        String district = request.getParameter("district");
        String districtText = request.getParameter("districtText");
        String ward = request.getParameter("town");
        String wardText = request.getParameter("townText");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        int accountId = Integer.parseInt(request.getParameter("accountId"));
        // Get file part
        try {
            Part filePart = request.getPart("image");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String newFileName = null;
            if(fileName!=null && !fileName.isEmpty()) {
                String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                newFileName = UUID.randomUUID().toString() + fileExtension;
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }
                String filePath = uploadPath + File.separator + newFileName;
                filePart.write(filePath);
            }
            //add motel
            Motel motel = new Motel();
            motel.setName(name);
            motel.setDescriptions(descriptions);
            motel.setDetailAddress(detailAddress);
            motel.setDistrict(districtText);
            if(newFileName!=null) motel.setImage(newFileName);
            motel.setProvince(provinceText);
            motel.setStatus(status);
            motel.setWard(wardText);
            motel.setProvinceId(province);
            motel.setDistrictId(district);
            motel.setWardId(ward);
            motel.setAccountId(accountId);
            MotelDAO.addMotel(motel);
            response.sendRedirect("/Project/owner");
        } catch (ServletException e) {
            throw new RuntimeException(e);
        }
    }

    private void updateMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        String name = request.getParameter("name");
        int id = Integer.parseInt(request.getParameter("id"));
        String descriptions = request.getParameter("descriptions");
        String detailAddress = request.getParameter("detailAddress");
        String province = request.getParameter("province");
        String provinceText = request.getParameter("provinceText");
        String district = request.getParameter("district");
        String districtText = request.getParameter("districtText");
        String ward = request.getParameter("town");
        String wardText = request.getParameter("townText");
        boolean status = Boolean.parseBoolean(request.getParameter("status"));
        String newFileName = null;
        // Get file part
        try {
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                    String fileExtension = fileName.substring(fileName.lastIndexOf("."));
                    newFileName = UUID.randomUUID().toString() + fileExtension;
                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIRECTORY;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdir();
                    }
                    String filePath = uploadPath + File.separator + newFileName;
                    filePart.write(filePath);
            }
            int accountId = Integer.parseInt(request.getParameter("accountId"));
            Motel motel = new Motel();
            motel.setMotelId(id);
            motel.setName(name);
            motel.setDescriptions(descriptions);
            motel.setDetailAddress(detailAddress);
            if(newFileName!=null) motel.setImage(newFileName);
            if(!province.equals("-1")){
                motel.setDistrict(districtText);
                motel.setProvince(provinceText);
                motel.setWard(wardText);
                motel.setProvinceId(province);
                motel.setDistrictId(district);
                motel.setWardId(ward);
            }
            motel.setStatus(status);
            motel.setAccountId(accountId);
            MotelDAO.updateMotel(motel);
        response.sendRedirect("/Project/owner");
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private void deleteMotel(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        MotelDAO.deleteMotel(id);
        response.sendRedirect("/Project/motel");
    }
}
