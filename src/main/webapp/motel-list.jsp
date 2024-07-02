<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Motel Management</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        h1 {
            color: #333;
            margin-top: 20px;
        }
        a {
            color: #007BFF;
            text-decoration: none;
        }
        .container {
            width: 70%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .actions a {
            margin-right: 10px;
        }
        a:hover {
            text-decoration: none !important;
        }
        .create-btn{
            box-sizing: border-box;
            padding: 10px 20px;
            border: 1px solid #0a0a0a;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Motel List</h1>
    <a class="create-btn" href="${pageContext.request.contextPath}/motel/create">Add New Motel</a>
    <table>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Address</th>
            <th>Image</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        <c:forEach var="motel" items="${motels}">
            <tr>
                <td>${motel.name}</td>
                <td>${motel.descriptions}</td>
                <td>${motel.detailAddress}, ${motel.ward}, ${motel.district}, ${motel.province}</td>
                <c:choose>
                    <c:when test="${motel.image == null}">
                        <td><img src="${pageContext.request.contextPath}/images/default-room.jpg" width="100px" height="100px"></td>
                    </c:when>
                    <c:otherwise>
                        <td><img src="${pageContext.request.contextPath}/uploads/${motel.image}" width="100px" height="100px"></td>
                    </c:otherwise>
                </c:choose>
                <td><c:choose>
                    <c:when test="${motel.status}">Available</c:when>
                    <c:otherwise>Unavailable</c:otherwise>
                </c:choose></td>
                <td class="actions">
                    <a href="${pageContext.request.contextPath}/motel/update?id=${motel.motelId}">Edit</a>
                    <a href="${pageContext.request.contextPath}/motel/manage?id=${motel.motelId}">Manage</a>
<%--                    <a href="motel/delete?id=${motel.motelId}" onclick="return confirm('Are you sure?');">Delete</a>--%>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>
