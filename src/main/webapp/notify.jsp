<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Send Notification</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>
<body>
<div class="container mt-4">
    <h1 class="mb-4">Send Notification</h1>
    <form method="post" action="sendNotification">
        <div class="form-group">
            <label for="motelRoomId">Motel Room ID:</label>
            <input type="text" class="form-control" id="motelRoomId" name="motelRoomId" required>
        </div>
        <div class="form-group">
            <label for="message">Message:</label>
            <input type="text" class="form-control" id="message" name="message" required>
        </div>
        <button type="submit" class="btn btn-primary">Send</button>
    </form>
    <br>
    <div>
        <c:if test="${not empty status}">
            <div class="alert alert-info">${status}</div>
        </c:if>
    </div>
</div>
</body>
</html>
