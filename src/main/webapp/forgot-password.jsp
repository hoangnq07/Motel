<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quên Mật Khẩu</title>
</head>
<body>
    <jsp:include page="header.jsp" ></jsp:include>
    <div class="container mt-5">
        <h1>Quên Mật Khẩu</h1>
        <c:if test="${not empty error}">
            <p style="color: red;">${error}</p>
        </c:if>
        <form action="forgot-password" method="post">
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>
            <button type="submit">Gửi</button>
        </form>
        <c:if test="${not empty message}">
            <p style="color: blanchedalmonda;">${message}</p>
        </c:if>
    </div>
</body>
</html>