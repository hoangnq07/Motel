<%@ page import="java.util.List" %>
<%@ page import="model.Notification" %>
<%@ page session="true" %>
<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Notification</title>
</head>
<body>
<h1>Notifications</h1>
<ul>
    <%
        if (notifications != null && !notifications.isEmpty()) {
            for(Notification notification : notifications) {
    %>
    <li><%= notification.getMessage() %> - <%= notification.getCreateDate() %></li>
    <%
        }
    } else {
    %>
    <li>No notifications available</li>
    <%
        }
    %>
</ul>
</body>
</html>
