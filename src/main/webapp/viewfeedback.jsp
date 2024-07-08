<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<div class="container mt-4">
    <h1 class="mb-4">View feedback</h1>
    <c:if test="${not empty feedbacks}">
        <table id="feedbackHistory" class="table table-bordered">
            <thead>
                <tr>
                    <th>Ngày Gửi</th>
                    <th>Nội Dung</th>
                    <th>Người Gửi</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="feedback" items="${feedbacks}">
                    <tr>
                        <td>${feedback.createDate}</td>
                        <td>${feedback.feedbackText}</td>
                        <td>${feedback.senderName}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty feedbacks}">
        <p>Không có feedback.</p>
    </c:if>
</div>
</body>
</html>