<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:forEach var="room" items="${rooms}">
    <div class="col-lg-4 col-md-6 mb-4">
        <div class="room-card">
            <c:if test="${not empty room.image}">
                <img src="${pageContext.request.contextPath}/images/${room.image}" alt="Room Image">
            </c:if>
            <c:if test="${empty room.image}">
                <img src="${pageContext.request.contextPath}/images/default-room.jpg" alt="Default Room Image">
            </c:if>
            <div class="room-details">
                <h5>${room.description}</h5>
                <p>${room.length * room.width} m²</p>
                <p class="price">${room.roomPrice} triệu/tháng</p>
                <p>${room.detailAddress}, ${room.ward}, ${room.district}, ${room.city}, ${room.province}</p>
                <i class="favorite ${room.favorite ? 'fas text-danger' : 'far'} fa-heart" onclick="toggleFavorite(this, ${room.motelRoomId})"></i>
                <a href="room-details?roomId=${room.motelRoomId}" class="btn btn-primary">View Details</a>
            </div>
        </div>
    </div>
</c:forEach>