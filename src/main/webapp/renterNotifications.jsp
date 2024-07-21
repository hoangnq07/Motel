<%@ page import="java.util.List" %>
<%@ page import="model.Notification" %>
<%@ page session="true" %>
<%
    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Thông báo</title>
</head>
<body>
<h1>Thông báo</h1>
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
    <li>Hiện chưa có thông báo nào.</li>
    <%
        }
    %>
</ul>
</body>
</html>
