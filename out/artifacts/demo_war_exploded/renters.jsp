<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Renter</title>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container">
    <h2>Thêm Renter</h2>
    <%-- Hiển thị thông báo thành công nếu có --%>
    <% if (request.getAttribute("successMessage") != null) { %>
    <div class="alert alert-success" role="alert">
        <%= request.getAttribute("successMessage") %>
    </div>
    <% } %>
    <%-- Hiển thị thông báo thất bại nếu có --%>
    <% if (request.getAttribute("errorMessage") != null) { %>
    <div class="alert alert-danger" role="alert">
        <%= request.getAttribute("errorMessage") %>
    </div>
    <% } %>
    <form action="RenterServlet" method="post">
        <div class="form-group">
            <label for="motelRoomId">Chọn Motel Room:</label>
            <select class="form-control" id="motelRoomId" name="motelRoomId">
                <option value="1">Motel Room 1</option>
                <option value="2">Motel Room 2</option>
                <!-- Thêm các tùy chọn khác nếu cần -->
            </select>
        </div>
        <div class="form-group">
            <label for="renterDate">Ngày Thuê:</label>
            <input type="date" class="form-control" id="renterDate" name="renterDate" required>
        </div>
        <div class="form-group">
            <label for="email">Email:</label>
            <input type="email" class="form-control" id="email" name="email" required>
        </div>
        <button type="submit" class="btn btn-primary">Thêm</button>
    </form>
</div>
</body>
</html>
