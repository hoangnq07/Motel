<%-- Document : header.jsp Created on : 28-02-2024, 20:30:36 Author : PC --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ</title>
    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
        }
        .navbar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            background-color: #f8f8f8;
            padding: 10px 20px;
            border-bottom: 1px solid #ccc;
        }
        .navbar .logo {
            font-size: 20px;
            font-weight: bold;
        }
        .navbar .menu {
            display: flex;
            gap: 20px;
        }
        .navbar .menu a {
            text-decoration: none;
            color: black;
            font-size: 16px;
        }
        .navbar .buttons {
            display: flex;
            gap: 10px;
        }
        .navbar .buttons a {
            text-decoration: none;
            color: black;
            padding: 5px 10px;
            border: 1px solid #ccc;
            background-color: white;
            display: inline-block;
            text-align: center;
            cursor: pointer;
        }
        .navbar .buttons a:hover {
            background-color: #e0e0e0;
        }
        .navbar .buttons a:visited {
            color: black;
        }
    </style>
</head>
<body>
    <div class="navbar">
        <div class="logo">HOME</div>
        <div class="menu">
            <a href="#">Trang chủ</a>
            <a href="#">Sản phẩm</a>
            <a href="#">Chia sẻ</a>
        </div>
        <div class="buttons">
            <a href="login.jsp">Login</a>
            <a href="registration.jsp">Register</a>
        </div>
    </div>
</body>
</html>

