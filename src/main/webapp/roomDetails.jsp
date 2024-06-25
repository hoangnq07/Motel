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
                            <img src="${pageContext.request.contextPath}/images/${image}" class="d-block" alt="Room Image" style="width: 700px; height: 500px;">
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
            <h3>${room.description}</h3>
            <p><strong>Category:</strong> ${room.category}</p>
            <p><strong>Room Price:</strong> ${room.roomPrice} triệu/tháng</p>
            <p><strong>Length:</strong> ${room.length} m</p>
            <p><strong>Width:</strong> ${room.width} m</p>
            <p><strong>Electricity Price:</strong> ${room.electricityPrice} per unit</p>
            <p><strong>Water Price:</strong> ${room.waterPrice} per unit</p>
            <p><strong>WiFi Price:</strong> ${room.wifiPrice}</p>
            <p><strong>Owner's Name:</strong> ${room.accountFullname}</p>
            <p><strong>Owner's Phone:</strong> ${room.accountPhone}</p>
            <p><strong>Address:</strong> ${room.detailAddress}, ${room.ward}, ${room.district}, ${room.province}</p>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<jsp:include page="footer.jsp" />
</body>
</html>
