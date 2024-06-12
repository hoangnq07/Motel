<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Motel Form</title>
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
        .container {
            width: 80%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-top: 10px;
            font-weight: bold;
        }
        input[type="text"], input[type="checkbox"] {
            padding: 10px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        input[type="submit"] {
            padding: 10px 20px;
            background-color: #007BFF;
            color: #fff;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 20px;
        }
        input[type="submit"]:hover {
            background-color: #0056b3;
        }
        a {
            display: inline-block;
            margin-top: 20px;
            color: #007BFF;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>${motel == null ? "Create New Motel" : "Edit Motel"}</h1>
    <form action="/Project/motel/${motel == null ? 'create' : 'update'}" method="post">
        <input type="hidden" name="id" value="${motel.motelId}" />
        <label>Descriptions:</label>
        <input type="text" name="descriptions" value="${motel.descriptions}" />
        <label>Detail Address:</label>
        <input type="text" name="detailAddress" value="${motel.detailAddress}" />
        <label>District:</label>
        <input type="text" name="district" value="${motel.district}" />
        <label>District ID:</label>
        <input type="text" name="districtId" value="${motel.districtId}" />
        <label>Image:</label>
        <input type="text" name="image" value="${motel.image}" />
        <label>Province:</label>
        <input type="text" name="province" value="${motel.province}" />
        <label>Province ID:</label>
        <input type="text" name="provinceId" value="${motel.provinceId}" />
        <label>Status:</label>
        <input type="checkbox" name="status" ${motel.status ? "checked" : ""} />
        <label>Ward:</label>
        <input type="text" name="ward" value="${motel.ward}" />
        <label>Account ID:</label>
        <input type="text" name="accountId" value="${motel.accountId}" />
        <input type="submit" value="${motel == null ? 'Create' : 'Update'}" />
    </form>
    <a href="/Project/motel">Back to List</a>
</div>
</body>
</html>
