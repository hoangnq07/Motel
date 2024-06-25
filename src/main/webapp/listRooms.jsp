<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Motel Rooms</title>
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
<jsp:include page="header.jsp"></jsp:include>

<div class="container mt-5">
    <!-- Search Form -->
    <form id="searchForm">
        <div class="form-group">
            <label for="description">Description:</label>
            <input type="text" class="form-control" id="description" name="description">
        </div>
        <div class="form-group">
            <label for="minPrice">Min Price:</label>
            <input type="number" class="form-control" id="minPrice" name="minPrice" step="0.01">
        </div>
        <div class="form-group">
            <label for="maxPrice">Max Price:</label>
            <input type="number" class="form-control" id="maxPrice" name="maxPrice" step="0.01">
        </div>
        <div class="form-group">
            <label for="status">Status:</label>
            <select class="form-control" id="status" name="status">
                <option value="">Any</option>
                <option value="true">Available</option>
                <option value="false">Unavailable</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary">Search</button>
    </form>

    <!-- Room Listings -->
    <div class="row mt-4">
        <c:forEach var="room" items="${rooms}">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="room-card">
                    <c:if test="${not empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/${room.image.get(1)}" alt="Room Image">
                    </c:if>
                    <c:if test="${empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/default-room.jpg" alt="Default Room Image">
                    </c:if>
                    <div class="room-details">
                        <h5>${room.description}</h5>
                        <p>${room.length * room.width} m²</p>
                        <p class="price">${room.roomPrice} triệu/tháng</p>
                        <p>${room.detailAddress}, ${room.ward}, ${room.district}, ${room.province}</p>
                        <i class="favorite ${room.favorite ? 'fas text-danger' : 'far'} fa-heart" onclick="toggleFavorite(this, ${room.motelRoomId})"></i>
                        <a href="room-details?roomId=${room.motelRoomId}" class="btn btn-primary">View Details</a>
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
<jsp:include page="footer.jsp" />
</body>
<script>
    function toggleFavorite(element, roomId) {
        const isFavorite = element.classList.contains('fas'); // Check if already favorite
        const action = isFavorite ? 'remove' : 'add'; // Determine action based on current state

        fetch("favorite?action=" + action + "&roomId=" + roomId, { method: 'POST' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    element.classList.toggle('far'); // Toggle the empty heart
                    element.classList.toggle('fas'); // Toggle the filled heart
                } else {
                    alert('An error occurred while processing your request');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }
</script>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    $(document).ready(function() {
        $('#searchForm').submit(function(e) {
            e.preventDefault();
            $.ajax({
                url: '${pageContext.request.contextPath}/searchMotelRooms',
                type: 'GET',
                data: $(this).serialize(),
                success: function(response) {
                    $('.row.mt-4').html(response);
                    // Hide pagination if showing search results
                    $('.pagination').hide();
                },
                error: function() {
                    alert('An error occurred while processing your request');
                }
            });
        });
    });
</script>

</html>
