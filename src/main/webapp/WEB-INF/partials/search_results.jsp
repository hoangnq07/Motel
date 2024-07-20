<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty accounts}">
    <h2>Kết Quả:</h2>
    <table>
        <tr>
            <th>Họ Tên</th>
            <th>Email</th>
            <th>SĐT</th>
            <th>CCCD</th>
            <th>Ngày Thuê</th>
            <th>Hành Động</th>
        </tr>
        <c:forEach var="account" items="${accounts}">
            <c:if test="${account.role != 'admin'}">
                <tr>
                    <td>${account.fullname}</td>
                    <td>${account.email}</td>
                    <td>${account.phone}</td>
                    <td>${account.citizenId}</td>
                    <td>
                        <input type="date" id="startDate_${account.accountId}" required>
                        <span id="dateError_${account.accountId}" style="color: red; display: none;">Vui lòng chọn ngày.</span>
                    </td>
                    <td>
                        <button onclick="addTenant(${account.accountId}, ${motelRoomId})">Thêm vào Phòng.</button>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
    </table>
</c:if>

<c:if test="${empty accounts}">
    <p>Không có kết quả.</p>
</c:if>