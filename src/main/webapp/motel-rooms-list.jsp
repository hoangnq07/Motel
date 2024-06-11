<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Motel Room List</title>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
<h2>Motel Room List</h2>
<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Create Date</th>
        <th>Descriptions</th>
        <th>Length</th>
        <th>Width</th>
        <th>Room Price</th>
        <th>Electricity Price</th>
        <th>Water Price</th>
        <th>Wifi Price</th>
        <th>Room Status</th>
        <th>Category Room ID</th>
        <th>Motel ID</th>
        <th>Account ID</th>
    </tr>
    </thead>
    <tbody>
<%--    <c:forEach var="room" items="${motelRooms}">--%>
<%--        <tr>--%>
<%--            <td>${room.motelRoomId}</td>--%>
<%--            <td>${room.createDate}</td>--%>
<%--            <td>${room.descriptions}</td>--%>
<%--            <td>${room.length}</td>--%>
<%--            <td>${room.width}</td>--%>
<%--            <td>${room.roomPrice}</td>--%>
<%--            <td>${room.electricityPrice}</td>--%>
<%--            <td>${room.waterPrice}</td>--%>
<%--            <td>${room.wifiPrice}</td>--%>
<%--            <td><c:choose>--%>
<%--                <c:when test="${room.roomStatus}">Available</c:when>--%>
<%--                <c:otherwise>Unavailable</c:otherwise>--%>
<%--            </c:choose></td>--%>
<%--            <td>${room.categoryRoomId}</td>--%>
<%--            <td>${room.motelId}</td>--%>
<%--            <td>${room.accountId}</td>--%>
<%--        </tr>--%>
<%--    </c:forEach>--%>
    </tbody>
</table>
</body>
</html>