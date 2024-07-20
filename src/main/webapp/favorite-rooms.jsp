<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <title>Phòng Yêu Thích</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

    <style>
        .favorite {
            cursor: pointer;
            color: #ccc; /* Default color */
            font-size: 24px;
            position: absolute;
            bottom: 10px;
            right: 10px;
        }
        .favorite.active {
            color: red; /* Màu khi được kích hoạt */
        }
        .body {
            margin-top: 120px;
        }
        .room-card {
            border: none;
            margin-bottom: 20px;
            position: relative;
        }
        .room-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 5px;
        }
        .room-card .room-details {
            padding: 10px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 5px 5px;
        }
        .room-card .room-details h5 {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 5px;
        }
        .room-card .room-details p {
            margin-bottom: 5px;
        }
        .room-card .room-details .price {
            font-weight: bold;
            color: #dc3545;
        }
    </style>
</head>
<jsp:include page="header.jsp" ></jsp:include>
<body class="body"  >

<div class="container mt-5" <c:if test="${empty favoriteRooms}">style="height: 500px"</c:if>>
    <div class="row">
        <c:forEach var="room" items="${favoriteRooms}">
            <div class="col-lg-4 col-md-6 mb-4" id="fas${room.motelRoomId}">
                <div class="room-card">
                    <c:if test="${not empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/${room.image.get(0)}" alt="Room Image">
                    </c:if>
                    <c:if test="${empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/default-room.jpg" alt="Default Room Image">
                    </c:if>
                    <div class="room-details">
                        <h5>${room.description}</h5>
                        <p>${room.length * room.width} m²</p>
                        <p class="price">${room.roomPrice} triệu/tháng</p>
                        <p>${room.detailAddress}, ${room.ward}, ${room.district}, ${room.city}, ${room.province}</p>
                        <a href="room-details?roomId=${room.motelRoomId}" class="btn btn-primary">Xem chi tiết</a>
                        <i class="favorite ${room.favorite ? 'fas text-danger' : 'far'} fa-heart" onclick="toggleFavorite(this, ${room.motelRoomId})"></i>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>

    <!-- Pagination -->
    <nav aria-label="Page navigation example">
        <ul class="pagination justify-content-center">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="motel-rooms?page=${i}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>

</body>
<jsp:include page="footer.jsp" />
<script>
    function toggleFavorite(element, roomId) {
        const isFavorite = element.classList.contains('fas'); // Kiểm tra xem đã là yêu thích chưa
        const action = isFavorite ? 'remove' : 'add'; // Xác định hành động dựa trên trạng thái hiện tại

        fetch(`favorite?action=`+action+`&roomId=`+roomId, { method: 'POST' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    element.classList.toggle('far'); // Toggle the empty heart
                    element.classList.toggle('fas'); // Toggle the filled heart
                    if(action == 'remove'){
                        let ele = document.getElementById('fas'+roomId);
                        ele.parentNode.removeChild(ele);
                    }
                } else {
                    alert('Got errors while dealing with your requests');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }
</script>
</html>
