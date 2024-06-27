<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>View Notifications</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      background-color: #f4f4f4;
      margin: 0;
      padding: 0;
    }
    h1 {
      text-align: center;
      color: #333;
      margin-top: 20px;
    }
    .container {
      width: 80%;
      margin: auto;
      overflow: hidden;
    }
    ul {
      list-style-type: none;
      padding: 0;
    }
    li {
      background: #fff;
      margin: 10px 0;
      padding: 15px;
      border-radius: 5px;
      box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }
    .notification-date {
      color: #666;
      font-size: 0.9em;
    }
    .notification-message {
      margin-top: 5px;
      color: #333;
      font-size: 1.1em;
    }
    .no-notifications {
      text-align: center;
      color: #666;
      font-size: 1.1em;
      margin-top: 20px;
    }
  </style>
</head>
<body>
<jsp:include page="header.jsp"/>
<div class="container">
  <h1>Notifications</h1>
  <c:if test="${not empty notifications}">
    <ul>
      <c:forEach var="notification" items="${notifications}">
        <li>
          <div class="notification-date"><strong>Date:</strong> ${notification.createDate}</div>
          <div class="notification-message"><strong>Message:</strong> ${notification.message}</div>
        </li>
      </c:forEach>
    </ul>
  </c:if>
  <c:if test="${empty notifications}">
    <p class="no-notifications">No notifications found.</p>
  </c:if>
</div>
</body>
</html>
