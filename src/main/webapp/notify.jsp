<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Gửi Thông Báo</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
</head>
<body>
<div class="container mt-4">
    <h1 class="mb-4">Gửi Thông Báo</h1>
    <form id="notificationForm">
        <div class="form-group">
            <label for="motelRoomId">Phòng:</label>
            <select class="form-control" id="motelRoomId" name="motelRoomId" required>
                <option value="all">Tất cả phòng</option>
                <c:forEach var="room" items="${requestScope.rooms}">
                    <option value="${room.motelRoomId}">${room.name}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="message">Tin nhắn:</label>
            <textarea class="form-control" id="message" name="message" rows="3" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary mt-3">Gửi</button>
    </form>
    <br>
    <div id="statusMessage"></div>

<%--    <h2 class="mt-4">Thông Báo Đã Gửi</h2>--%>
<%--    <table class="table table-striped">--%>
<%--        <thead>--%>
<%--        <tr>--%>
<%--            <th>Phòng</th>--%>
<%--            <th>Nội Dung</th>--%>
<%--            <th>Thời Gian</th>--%>
<%--            <th>Actions</th>--%>
<%--        </tr>--%>
<%--        </thead>--%>
<%--        <tbody>--%>
<%--        <c:forEach var="item" items="${sentNotifications}">--%>
<%--            <tr>--%>
<%--                <td>${item[1]}</td>--%>
<%--                <td>${item[0].message}</td>--%>
<%--                <td>${item[0].createDate}</td>--%>
<%--                <td>--%>
<%--                    <button class="btn btn-warning btn-sm">Edit</button>--%>
<%--                    <button class="btn btn-danger btn-sm">Delete</button>--%>
<%--                </td>--%>
<%--            </tr>--%>
<%--        </c:forEach>--%>
<%--        </tbody>--%>
<%--    </table>--%>
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
                    $("#statusMessage").html('<div class="alert alert-danger">Gửi thông báo không thành công: ' + xhr.responseText + '</div>');
                }
            });
        });
    });
    // $(".editBtn").on("click", function(){
    //     var id = $(this).data("id");
    //     var message = $(this).data("message");
    //     var newMessage = prompt("Enter new message:", message);
    //     if (newMessage !== null) {
    //         $.post("editNotification", { notificationId: id, message: newMessage }, function(response){
    //             $("#statusMessage").html('<div class="alert alert-info">' + response + '</div>');
    //             location.reload(); // Reload to reflect changes
    //         });
    //     }
    // });
</script>
</body>
</html>
