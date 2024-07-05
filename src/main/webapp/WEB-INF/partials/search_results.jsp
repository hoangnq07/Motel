<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty accounts}">
    <h2>Search Results:</h2>
    <table>
        <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Citizen ID</th>
            <th>Action</th>
        </tr>
        <c:forEach var="account" items="${accounts}">
            <tr>
                <td>${account.fullname}</td>
                <td>${account.email}</td>
                <td>${account.phone}</td>
                <td>${account.citizenId}</td>
                <td>
                    <input type="date" id="startDate_${account.accountId}" required>
                    <input type="hidden" id="motelRoomId_${account.accountId}" value="${param.motel_room_id}">
                    <button onclick="addTenant(${account.accountId}, ${param.motel_room_id})">Add as Tenant</button>
                </td>
            </tr>
        </c:forEach>
    </table>
</c:if>

<c:if test="${empty accounts}">
    <p>No results found.</p>
</c:if>