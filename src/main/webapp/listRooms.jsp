<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<jsp:useBean id="rooms" scope="request" type="java.util.List" />
<jsp:useBean id="currentPage" scope="request" type="java.lang.Integer" />
<jsp:useBean id="totalPages" scope="request" type="java.lang.Integer" />

<!-- Include Bootstrap CSS -->
<link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">

<!-- Include Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.2.1.slim.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.11.0/umd/popper.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js"></script>

<!DOCTYPE html>
<html>
<head>
    <title>Motel Rooms</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .body {
            margin-top: 80px;
        }
        .room-card {
            border: none;
            margin-bottom: 20px;
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
<jsp:include page="header.jsp" ></jsp:include>
<div class="container mt-5">
    <div class="row">
        <%
            List<MotelRoom> roomList = (List<MotelRoom>) request.getAttribute("rooms");
            if (roomList != null && !roomList.isEmpty()) {
                for (MotelRoom room : roomList) {
        %>
        <div class="col-lg-4 col-md-6 mb-4">
            <div class="room-card">
                <% if (room.getImage() != null && !room.getImage().isEmpty()) { %>
                <img src="<%= request.getContextPath()%>/avatar/<%= room.getImage() %>" alt="Room Image">
                <% } else { %>
                <img src="images/default-room.jpg" alt="Default Room Image">
                <% } %>
                <div class="room-details">
                    <h5><%= room.getDescription() %></h5>
                    <p><%= room.getLength() * room.getWidth() %> m²</p>
                    <p class="price"><%= room.getRoomPrice() %> triệu/tháng</p>
                    <p><%= room.getDetailAddress() %>, <%= room.getWard() %>, <%= room.getDistrict() %>, <%= room.getCity() %>, <%= room.getProvince() %></p>
                    <a href="room-details?roomId=<%= room.getMotelRoomId() %>" class="btn btn-primary">View Details</a>
                </div>
            </div>
        </div>
        <%
            }
        } else {
        %>
        <p class="col-12">No rooms available.</p>
        <% } %>
    </div>

    <!-- Pagination -->
    <nav aria-label="Page navigation example">
        <ul class="pagination justify-content-center">
            <% for (int i = 1; i <= (Integer)request.getAttribute("totalPages"); i++) { %>
            <li class="page-item<%= i == (Integer)request.getAttribute("currentPage") ? " active" : "" %>">
                <a class="page-link" href="motel-rooms?page=<%= i %>"><%= i %></a>
            </li>
            <% } %>
        </ul>
    </nav>
</div>
<jsp:include page="footer.jsp" />
</body>
</html>