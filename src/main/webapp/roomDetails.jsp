<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<jsp:useBean id="room" scope="request" type="model.MotelRoom" />
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi Tiết Phòng</title>
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
    <h1>Chi Tiết về Phòng</h1>
    <div class="row">
        <div class="col-md-6">
            <!-- Carousel -->
            <div id="roomImagesCarousel" class="carousel slide" data-ride="carousel">
                <div class="carousel-inner">
                    <c:if test="${empty images}">
                        <div class="carousel-item active">
                            <img src="${pageContext.request.contextPath}/images/default-room.jpg" class="d-block" alt="Room Image" style="width: 700px; height: 500px;">
                        </div>
                    </c:if>
                    <c:forEach var="image" items="${images}" varStatus="status">
                        <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
                            <img src="${pageContext.request.contextPath}/images/${image}" class="d-block" alt="Room Image" style="width: 700px; height: 500px;">
                        </div>
                    </c:forEach>
                </div>
                <a class="carousel-control-prev" href="#roomImagesCarousel" role="button" data-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="sr-only">Trước</span>
                </a>
                <a class="carousel-control-next" href="#roomImagesCarousel" role="button" data-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="sr-only">Sau</span>
                </a>
            </div>
        </div>
        <div class="col-md-6">
            <h3>${room.description}</h3>
            <p><strong>Phân Loại:</strong> ${room.category}</p>
            <p><strong>Giá Phòng:</strong> ${room.roomPrice} Triệu/tháng</p>
            <p><strong>Chiều Dài:</strong> ${room.length} m</p>
            <p><strong>Chiều Rộng:</strong> ${room.width} m</p>
            <p><strong>Giá Điện:</strong> ${room.electricityPrice} per unit</p>
            <p><strong>Giá Nước:</strong> ${room.waterPrice} per unit</p>
            <p><strong>Giá Wi-Fi:</strong> ${room.wifiPrice}</p>
            <p><strong>Người Chủ:</strong> ${room.accountFullname}</p>
            <p><strong>Số Điện Thoại:</strong> ${room.accountPhone}</p>
            <p><strong>Địa Chỉ:</strong> ${room.detailAddress}, ${room.ward}, ${room.district}, ${room.province}</p>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.4/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<jsp:include page="footer.jsp" />
</body>
</html>
