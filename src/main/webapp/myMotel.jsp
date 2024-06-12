<%@ page import="dao.NotificationDAO" %>
<%@ page import="dao.Notification" %>
<%@ page import="java.util.List" %>
<<<<<<< HEAD
<%@ page import="Account.User" %>
<%@ page session="true" %>
<%
    // Lấy người dùng từ session
    User user = (User) session.getAttribute("user");
=======
<%@ page import="Account.Account" %>
<%@ page session="true" %>
<%
    // Lấy người dùng từ session
    Account user = (Account) session.getAttribute("user");
>>>>>>> origin/taskbaoupdate

    // Kiểm tra xem người dùng có đăng nhập hay không
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Lấy ID người dùng từ đối tượng user
    int userId = user.getAccountId();
    List<Notification> notifications = NotificationDAO.getNotificationsByUserId(userId);
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Motel</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <div class="row">
        <div class="col-md-3">
            <ul class="list-group">
                <li class="list-group-item"><a href="#" id="showNotifications">Notifications</a></li>
                <!-- Các liên kết điều hướng khác -->
            </ul>
        </div>
        <div class="col-md-9">
            <div id="content">
                <h1>Welcome to My Motel</h1>
                <div id="notifications" style="display: none;">
                    <h2>Your Notifications</h2>
                    <ul class="list-group">
                        <%
                            if (notifications != null && !notifications.isEmpty()) {
                                for (Notification notification : notifications) {
                        %>
                        <li class="list-group-item"><%= notification.getMessage() %> - <%= notification.getCreateDate() %></li>
                        <%
                            }
                        } else {
                        %>
                        <li class="list-group-item">No notifications available</li>
                        <%
                            }
                        %>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        $('#showNotifications').click(function(e) {
            e.preventDefault();
            $('#content > div').hide();
            $('#notifications').show();
        });
    });
</script>
</body>
</html>
