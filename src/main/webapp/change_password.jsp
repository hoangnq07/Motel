<%-- 
    Document   : change_password
    Created on : May 20, 2024, 4:07:16 AM
    Author     : Admin
--%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta charset="UTF-8">
        <title>Thay đổi Mật khẩu</title>
    </head>
    <body>
        <jsp:include page="header.jsp" ></jsp:include>
        <div class="container mt-5">
            <h2>Đổi Mật Khẩu</h2>
            <c:if test="${not empty status}">
                <p style="color: red;">${status}</p>
            </c:if>
            <form action="ChangePasswordServlet" method="post">
                <label for="currentPassword" class="form-label">Mật khẩu hiện tại:</label>
                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
                <br>
                <label for="newPassword" class="form-label">Mật khẩu mới:</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
                <br>
                <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới:</label>
                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
                <br>
                <button type="submit">Xác nhận</button>
            </form>
        </div>
        <jsp:include page="footer.jsp" ></jsp:include>
    </body>
</html>