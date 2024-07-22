<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty accounts}">
    <h2>Search Results:</h2>
    <table>
        <tr>
            <th>Họ Tên</th>
            <th>Email</th>
            <th>Số Điện Thoại</th>
            <th>CCCD</th>
            <th>Ngày Thuê</th>
            <th>Hành Động</th>
        </tr>
        <c:forEach var="account" items="${accounts}">
            <tr>
                <td>${account.fullname}</td>
                <td>${account.email}</td>
                <td>${account.phone}</td>
                <td>${account.citizenId}</td>
                <td>
                    <input type="date" id="startDate_${account.accountId}" required>
                    <span id="dateError_${account.accountId}" style="color: red; display: none;">Vui lòng chọn ngày thuê.</span>
                </td>
                <td>
                    <button onclick="addTenant(${account.accountId}, ${motelRoomId})">Thêm vào phòng.</button>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<c:if test="${empty accounts}">
    <p>No results found.</p>
</c:if>