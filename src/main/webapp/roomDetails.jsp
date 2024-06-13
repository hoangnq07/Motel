<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <title>Room Details</title>
</head>
<body>
<h1>Room Details</h1>
<c:if test="${not empty room}">
    <p><strong>Room ID:</strong> ${room.motelRoomId}</p>
    <p><strong>Description:</strong> ${room.description}</p>
    <p><strong>Price:</strong> ${room.roomPrice}</p>
    <p><strong>Location:</strong> ${room.detailAddress}, ${room.ward}, ${room.district}, ${room.province}</p>
    <p><strong>Image:</strong>
        <c:if test="${not empty room.image}">
            <img src="images/${room.image}" alt="Room Image"/>
        </c:if>
    </p>

    <h2>Renters</h2>
    <c:if test="${not empty renters}">
        <ul>
            <c:forEach var="renter" items="${renters}">
                <li>
                    <p><strong>Name:</strong> ${renter.account.fullname}</p>
                    <p><strong>Phone:</strong> ${renter.account.phone}</p>
                    <p><strong>Check-in Date:</strong> ${renter.renterDate}</p>
                    <c:if test="${not empty renter.changeRoomDate}">
                        <p><strong>Change Room Date:</strong> ${renter.changeRoomDate}</p>
                    </c:if>
                    <c:if test="${not empty renter.checkOutDate}">
                        <p><strong>Check-out Date:</strong> ${renter.checkOutDate}</p>
                    </c:if>
                </li>
            </c:forEach>
        </ul>
    </c:if>
    <c:if test="${empty renters}">
        <p>No renters found for this room.</p>
    </c:if>
</c:if>
<c:if test="${empty room}">
    <p>Room not found.</p>
</c:if>
</body>
</html>
