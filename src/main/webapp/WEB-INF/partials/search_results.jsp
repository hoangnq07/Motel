<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:if test="${not empty requestScope.accounts}">
    <h2>Search Results:</h2>
    <table>
        <tr>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Citizen ID</th>
            <th>Action</th>
        </tr>
        <c:forEach var="account" items="${requestScope.accounts}">
            <c:if test="${account.role != 'admin'}">
                <tr>
                    <td>${account.fullname}</td>
                    <td>${account.email}</td>
                    <td>${account.phone}</td>
                    <td>${account.citizenId}</td>
                    <td>
                        <button onclick="openAddTenantModal(${account.accountId}, ${requestScope.motelRoomId})">Add Tenant</button>
                    </td>
                </tr>
            </c:if>
        </c:forEach>
    </table>
</c:if>

<c:if test="${empty accounts}">
    <p>No results found.</p>
</c:if>