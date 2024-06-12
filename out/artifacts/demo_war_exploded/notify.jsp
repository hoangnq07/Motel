<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Thông báo</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <script type="text/javascript">
        window.onload = function() {
            const urlParams = new URLSearchParams(window.location.search);
            const status = urlParams.get('status');
            if (status === 'success') {
                alert('Gửi thông báo thành công.');
                window.location.href = 'owner.jsp';
            } else if (status === 'error') {
                alert('Email không tồn tại trong hệ thống.');
            }
        };
    </script>
</head>
<body>
<div class="container mt-4">
    <h2>Gửi Thông Báo</h2>
    <form method="post" action="NotificationServlet">
        <div class="form-group">
            <%--@declare id="email"--%><label for="email">Nhập email người nhận thông báo:</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="message"--%><label for="message">Nội dung thông báo:</label>
            <textarea name="message" class="form-control" rows="5" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">Gửi Thông Báo</button>
    </form>
</div>
</body>
</html>
