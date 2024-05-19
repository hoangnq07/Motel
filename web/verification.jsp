<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verification</title>
</head>
<body>
    <h1>Verify Your Email</h1>
    <% String email = (String) session.getAttribute("email"); %>
    <p>A verification code has been sent to <%= email %>. Please enter the code below:</p>
    <form action="verify" method="post">
        <input type="text" name="verificationCode" placeholder="Enter the verification code" required>
        <input type="submit" value="Verify">
    </form>
</body>
</html>