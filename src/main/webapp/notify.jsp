<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Send Notification</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h1 class="mb-4">Send Notification</h1>
    <form id="notificationForm">
        <div class="form-group">
            <label for="motelRoomId">Motel Room:</label>
            <select class="form-control" id="motelRoomId" name="motelRoomId" required>
                <option value="all">All room</option>
                <c:forEach var="room" items="${requestScope.rooms}">
                    <option value="${room.motelRoomId}">${room.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="message">Message:</label>
            <textarea class="form-control" id="message" name="message" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary mt-3">Send</button>
    </form>
    <br>
    <div id="statusMessage"></div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    if (typeof jQuery !== 'undefined') {
        console.log('jQuery is loaded!');
    } else {
        console.log('jQuery is not loaded.');
    }
</script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function(){
        $("#notificationForm").on("submit", function(event){
            event.preventDefault(); // Prevent the form from submitting the traditional way
            $.ajax({
                url: "sendNotification",
                type: "POST",
                data: $(this).serialize(),
                success: function(response){
                    $("#statusMessage").html('<div class="alert alert-info">' + response + '</div>');
                },
                error: function(xhr, status, error){
                    $("#statusMessage").html('<div class="alert alert-danger">Failed to send notification: ' + xhr.responseText + '</div>');
                }
            });
        });
    });
</script>
</body>
</html>
