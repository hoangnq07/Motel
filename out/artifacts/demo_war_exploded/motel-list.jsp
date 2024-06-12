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
        a:hover {
            text-decoration: underline;
        }
        .container {
            width: 80%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            margin-bottom: 20px;
            background-color: #007BFF;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            text-align: center;
        }
        .btn:hover {
            background-color: #0056b3;
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
    </style>
</head>
<body>
<div class="container">
    <h1>Motel List</h1>
    <a href="motel/create" class="btn">Add New Motel</a>
    <table>
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
                <td class="actions">
                    <a href="motel/update?id=${motel.motelId}">Edit</a>
                    <a href="motel/delete?id=${motel.motelId}" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
        </c:forEach>
    </table>
</div>
</body>
</html>
