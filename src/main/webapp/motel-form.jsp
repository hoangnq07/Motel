<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Motel Form</title>
</head>
<body>
<h1>${motel == null ? "Create New Motel" : "Edit Motel"}</h1>
<form action="motel/${motel == null ? 'create' : 'update'}" method="post">
    <input type="hidden" name="id" value="${motel.motelId}" />
    <label>Descriptions:</label>
    <input type="text" name="descriptions" value="${motel.descriptions}" /><br/>
    <label>Detail Address:</label>
    <input type="text" name="detailAddress" value="${motel.detailAddress}" /><br/>
    <label>District:</label>
    <input type="text" name="district" value="${motel.district}" /><br/>
    <label>District ID:</label>
    <input type="text" name="districtId" value="${motel.districtId}" /><br/>
    <label>Image:</label>
    <input type="text" name="image" value="${motel.image}" /><br/>
    <label>Province:</label>
    <input type="text" name="province" value="${motel.province}" /><br/>
    <label>Province ID:</label>
    <input type="text" name="provinceId" value="${motel.provinceId}" /><br/>
    <label>Status:</label>
    <input type="checkbox" name="status" ${motel.status ? "checked" : ""} /><br/>
    <label>Ward:</label>
    <input type="text" name="ward" value="${motel.ward}" /><br/>
    <label>Account ID:</label>
    <input type="text" name="accountId" value="${motel.accountId}" /><br/>
    <input type="submit" value="${motel == null ? 'Create' : 'Update'}" />
</form>
<a href="motel">Back to List</a>
</body>
</html>
