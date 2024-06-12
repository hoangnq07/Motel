<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Search Motel Rooms</title>
</head>
<body>
<h1>Search Motel Rooms</h1>
<form method="get" action="${pageContext.request.contextPath}/searchMotelRooms">
    <label for="description">Description:</label>
    <input type="text" id="description" name="description"><br>

    <label for="minPrice">Min Price:</label>
    <input type="number" id="minPrice" name="minPrice" step="0.01"><br>

    <label for="maxPrice">Max Price:</label>
    <input type="number" id="maxPrice" name="maxPrice" step="0.01"><br>

    <label for="status">Status:</label>
    <select id="status" name="status">
        <option value="">Any</option>
        <option value="true">Available</option>
        <option value="false">Unavailable</option>
    </select><br>

    <button type="submit">Search</button>
</form>

<c:if test="${not empty motelRooms}">
    <h2>Search Results</h2>
    <table border="1">
        <thead>
        <tr>
            <th>Description</th>
            <th>Length</th>
            <th>Width</th>
            <th>Room Price</th>
            <th>Status</th>
            <th>Image</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="room" items="${motelRooms}">
            <tr>
                <td>${room.description}</td>
                <td>${room.length}</td>
                <td>${room.width}</td>
                <td>${room.roomPrice}</td>
                <td><c:choose>
                    <c:when test="${room.roomStatus}">Available</c:when>
                    <c:otherwise>Unavailable</c:otherwise>
                </c:choose></td>
                <td><img src="${pageContext.request.contextPath}/images/${room.image}" alt="Room Image" width="100" height="100"></td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</c:if>
</body>
</html>
