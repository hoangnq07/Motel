<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.MotelRoom" %>
<jsp:useBean id="room" scope="request" type="model.MotelRoom" />

<!-- Include Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">

<!-- Include Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

<!DOCTYPE html>
<html>
<head>
    <title>Room Details</title>
</head>
<body>
<jsp:include page="header.jsp" />

<div class="container mt-5">
    <h1 class="my-4">Room Details</h1>
    <div class="row">
        <div class="col-md-6">
            <img src="<%= room.getImage() %>" class="img-fluid mb-3" alt="Room Image">
        </div>
        <div class="col-md-6">
            <h3><%= room.getDescription() %></h3>
            <p><strong>Room Price:</strong> <%= room.getRoomPrice() %> triệu/tháng</p>
            <p><strong>Length:</strong> <%= room.getLength() %> m</p>
            <p><strong>Width:</strong> <%= room.getWidth() %> m</p>
            <p><strong>Electricity Price:</strong> <%= room.getElectricityPrice() %> per unit</p>
            <p><strong>Water Price:</strong> <%= room.getWaterPrice() %> per unit</p>
            <p><strong>WiFi Price:</strong> <%= room.getWifiPrice() %></p>
            <p><strong>Account Fullname:</strong> <%= room.getAccountFullname() %></p>
            <p><strong>Account Phone:</strong> <%= room.getAccountPhone() %></p>
            <p><strong>Address:</strong> <%= room.getDetailAddress() %>, <%= room.getWard() %>, <%= room.getDistrict() %>, <%= room.getCity() %>, <%= room.getProvince() %></p>
        </div>
    </div>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>
