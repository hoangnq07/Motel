<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password Result</title>
</head>
<body>
    <%
        String message = (String) request.getAttribute("message");
        String error = (String) request.getAttribute("error");
    %>

    <% if (message != null) { %>
        <p><%= message %></p>
        <a href="login.jsp">Go to Login</a>
    <% } else if (error != null) { %>
        <p><%= error %></p>
        <a href="forgot-password.jsp">Try Again</a>
    <% } %>
</body>
</html>