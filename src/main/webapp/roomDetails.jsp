<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="room" scope="request" type="model.MotelRoom" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Room Details</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        .body {
            margin-top: 80px;
        }
        .carousel-item {
            margin: 0;
            padding: 0;
        }
        .carousel-item img {
            margin: 0;
            padding: 0;
            width: 100%;
            height: auto;
        }
    </style>
</head>
<body class="body">
<jsp:include page="header.jsp" />
<div class="container">
    <h1>Room Details</h1>
    <div class="row">
        <div class="col-md-6">
            <!-- Carousel -->
            <div id="roomImagesCarousel" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                    <c:forEach var="image" items="${images}" varStatus="status">
                        <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                            <img src="${pageContext.request.contextPath}/avatar/${image}" class="d-block w-100" alt="Room Image">
                        </div>
                    </c:forEach>
                </div>
                <a class="carousel-control-prev" href="#roomImagesCarousel" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="sr-only">Previous</span>
                </a>
                <a class="carousel-control-next" href="#roomImagesCarousel" role="button" data-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="sr-only">Next</span>
                </a>
            </div>
        </div>
        <div class="col-md-6">
            <h3><%= room.getDescription() %></h3>
            <p><strong>Category:</strong> <%= room.getCategory() %></p>
            <p><strong>Room Price:</strong> <%= room.getRoomPrice() %> triệu/tháng</p>
            <p><strong>Length:</strong> <%= room.getLength() %> m</p>
            <p><strong>Width:</strong> <%= room.getWidth() %> m</p>
            <p><strong>Electricity Price:</strong> <%= room.getElectricityPrice() %> per unit</p>
            <p><strong>Water Price:</strong> <%= room.getWaterPrice() %> per unit</p>
            <p><strong>WiFi Price:</strong> <%= room.getWifiPrice() %></p>
            <p><strong>Owner's Name:</strong> <%= room.getAccountFullname() %></p>
            <p><strong>Owner's Phone:</strong> <%= room.getAccountPhone() %></p>
            <p><strong>Address:</strong> <%= room.getDetailAddress() %>, <%= room.getWard() %>, <%= room.getDistrict() %>, <%= room.getCity() %>, <%= room.getProvince() %></p>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<jsp:include page="footer.jsp" />
</body>
</html>
