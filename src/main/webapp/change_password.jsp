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
        <title>Change Password</title>
    </head>
    <body>
        <jsp:include page="header.jsp" ></jsp:include>
            <h2>Change Password</h2>
        <c:if test="${not empty status}">
            <p style="color: red;">${status}</p>
        </c:if>
        <form action="ChangePasswordServlet" method="post">
            <label for="currentPassword">Current Password:</label>
            <input type="password" id="currentPassword" name="currentPassword" required>
            <br>
            <label for="newPassword">New Password:</label>
            <input type="password" id="newPassword" name="newPassword" required>
            <br>
            <label for="confirmNewPassword">Confirm New Password:</label>
            <input type="password" id="confirmNewPassword" name="confirmNewPassword" required>
            <br>
            <button type="submit">Submit</button>
        </form>
    </body>
</html>