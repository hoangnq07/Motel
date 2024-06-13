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
        <label>Name:</label>
        <input type="text" name="name" value="${motel.name}" />
        <label>Descriptions:</label>
        <input type="text" name="descriptions" value="${motel.descriptions}" />
        <label>Province:</label>
        <input type="text" name="province" value="${motel.province}" />
        <label>District:</label>
        <input type="text" name="district" value="${motel.district}" />
        <label>Ward:</label>
        <input type="text" name="ward" value="${motel.ward}" />
        <label>Detail Address:</label>
        <input type="text" name="detailAddress" value="${motel.detailAddress}" />
        <label>Status:</label>
        <div>
            <input type="radio" id="statusTrue" name="status" value="true" ${motel.status ? "checked" : ""}>
            <label for="statusTrue">True</label>
        </div>
        <div>
            <input type="radio" id="statusFalse" name="status" value="false" ${!motel.status ? "checked" : ""}>
            <label for="statusFalse">False</label>
        </div>
        <label>Image:</label>
        <input type="text" name="image" value="${motel.image}" />
        <input type="hidden" name="accountId" value="${user.accountId}" />
        <input type="submit" value="${motel == null ? 'Create' : 'Update'}" />
    </form>
    <a href="/Project/owner">Back to List</a>
</div>
</body>

</html>
