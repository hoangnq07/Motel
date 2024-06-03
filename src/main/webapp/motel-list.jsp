<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Motel Management</title>
</head>
<body>
<h1>Motel List</h1>
<a href="motel/create">Add New Motel</a>
<table border="1">
    <tr>
        <th>ID</th>
        <th>Create Date</th>
        <th>Descriptions</th>
        <th>Detail Address</th>
        <th>District</th>
        <th>District ID</th>
        <th>Image</th>
        <th>Province</th>
        <th>Province ID</th>
        <th>Status</th>
        <th>Ward</th>
        <th>Account ID</th>
        <th>Actions</th>
    </tr>
    <c:forEach var="motel" items="${motels}">
        <tr>
            <td>${motel.motelId}</td>
            <td>${motel.createDate}</td>
            <td>${motel.descriptions}</td>
            <td>${motel.detailAddress}</td>
            <td>${motel.district}</td>
            <td>${motel.districtId}</td>
            <td>${motel.image}</td>
            <td>${motel.province}</td>
            <td>${motel.provinceId}</td>
            <td>${motel.status}</td>
            <td>${motel.ward}</td>
            <td>${motel.accountId}</td>
            <td>
                <a href="motel/update?id=${motel.motelId}">Edit</a>
                <a href="motel/delete?id=${motel.motelId}" onclick="return confirm('Are you sure?');">Delete</a>
            </td>
        </tr>
    </c:forEach>
</table>
</body>
</html>
