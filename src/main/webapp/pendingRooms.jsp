<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Pending Rooms</title>
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
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
            color: red; /* Active color */
        }
        .body {
            margin-top: 80px;
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
<body class="body">
<div class="container mt-4">
    <h2>Pending Motel Rooms</h2>
    <div class="row">
        <c:forEach items="${rooms}" var="room">
            <div class="col-md-4">
                <div class="card room-card">
                    <c:choose>
                        <c:when test="${not empty room.image}">
                            <img class="card-img-top" src="${pageContext.request.contextPath}/images/${room.image.get(0)}" alt="Room Image">
                        </c:when>
                        <c:otherwise>
                            <img class="card-img-top" src="${pageContext.request.contextPath}/images/default-room.jpg" alt="Default Room Image">
                        </c:otherwise>
                    </c:choose>
                    <div class="card-body room-details">
                        <h5 class="card-title">${room.description}</h5>
                        <p class="card-text">${room.detailAddress}, ${room.district}, ${room.province}</p>
                        <p class="card-text price">${room.roomPrice} triệu/tháng</p>
                        <a href="room-details?roomId=${room.motelRoomId}" class="btn btn-primary">View Details</a>
                        <button class="btn btn-success" onclick="updateRoomStatus(${room.motelRoomId}, 'approved')">Approve</button>
                        <button class="btn btn-danger" onclick="updateRoomStatus(${room.motelRoomId}, 'declined')">Decline</button>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
    <!-- Pagination -->
    <nav>
        <ul class="pagination">
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="${pageContext.request.contextPath}/pending-room-requests?action=listPending&page=${i}">${i}</a>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script>
    function updateRoomStatus(roomId, status) {
        $.post('${pageContext.request.contextPath}/pending-room-requests', { action: status === 'approved' ? 'approvePostRequest' : 'rejectPostRequest', roomId: roomId }, function(response) {
            if (response.success) {
                alert('Room ' + status + ' successfully');
                location.reload();
            } else {
                alert('Failed to ' + status + ' room');
            }
        }, 'json').fail(function() {
            alert('Error contacting server');
        });
    }
</script>
</body>
</html>
