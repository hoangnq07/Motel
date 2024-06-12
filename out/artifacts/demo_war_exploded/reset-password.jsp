<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>
    <script type="text/javascript">
        function validatePasswords() {
            var password = document.getElementById("newPassword").value;
            var confirmPassword = document.getElementById("confirmPassword").value;

            // Check if password and confirm password are not empty
            if (!password || !confirmPassword) {
                alert("Password fields cannot be empty.");
                return false;
            }

            // Check if passwords match
            if (password !== confirmPassword) {
                alert("Passwords do not match. Please try again.");
                return false;
            }

            // Password security check
            var passwordRegex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$/;
            if (!passwordRegex.test(password)) {
                alert("Password must be at least 8 characters long and include at least one uppercase letter, one lowercase letter, one digit, and one special character.");
                return false;
            }

            return true;
        }
    </script>
</head>
<body>
    <h1>Reset Password</h1>
    <c:set var="email" value="${param.email}" />
    <c:set var="code" value="${param.code}" />
    <c:set var="verificationCodeKey" value="verificationCode_${email}" />
    <c:set var="storedCode" value="${sessionScope[verificationCodeKey]}" />
    <c:choose>
        <c:when test="${empty storedCode or storedCode ne code}">
            <p>Invalid verification code</p>
        </c:when>
        <c:otherwise>
            <form action="reset-password" method="post" onsubmit="return validatePasswords();">
                <input type="hidden" name="email" value="${email}">
                <label for="newPassword">New Password:</label>
                <input type="password" id="newPassword" name="newPassword" required><br>
                <label for="confirmPassword">Confirm Password:</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required><br>
                <button type="submit">Reset Password</button>
            </form>
        </c:otherwise>
    </c:choose>
</body>
</html>
