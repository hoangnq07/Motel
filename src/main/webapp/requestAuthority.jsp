<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request Authority</title>
</head>
<body>
<h2>Request Authority</h2>
<form action="${pageContext.request.contextPath}/requestAuthority" method="post">
    <label for="image">Image URL:</label>
    <input type="text" id="image" name="image" required><br><br>

    <label for="descriptions">Descriptions:</label>
    <textarea id="descriptions" name="descriptions" required></textarea><br><br>

    <input type="submit" value="Submit Request">
</form>

<% if (request.getParameter("status") != null) { %>
<p>Request submitted successfully!</p>
<% } %>
</body>
</html>
