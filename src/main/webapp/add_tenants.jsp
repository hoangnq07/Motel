<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="dao.RenterDAO" %>
<%@ page import="model.Renter" %>
<%@ page import="java.util.List" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Tenants</title>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 20px;
            background-color: #f4f4f4;
        }
        .container {
            display: flex;
            justify-content: space-between;
            max-width: 1500px;
            margin: 0 auto;
        }
        .left-column {
            width: 60%;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        .right-column {
            width: 40%;
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1, h2 {
            color: #333;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        input[type="text"], input[type="date"], input[type="button"], button {
            padding: 8px;
            margin: 5px 0;
        }
        input[type="button"], button {
            background-color: #4CAF50;
            color: white;
            border: none;
            cursor: pointer;
        }
        input[type="button"]:hover, button:hover {
            background-color: #45a049;
        }

    </style>
</head>
<body>
<div class="container">
    <div class="left-column">
        <h2>Add New Tenant</h2>
        <%
            if (request.getAttribute("currentTenants") == null) {
                int motelRoomId = Integer.parseInt(request.getParameter("motel_room_id"));
                RenterDAO renterDAO = new RenterDAO();
                List<Renter> currentTenants = renterDAO.getCurrentTenants(motelRoomId);
                request.setAttribute("currentTenants", currentTenants);
                request.setAttribute("motelRoomId", motelRoomId);
            }
        %>

        <form id="searchForm">
            <input type="text" id="searchTerm" name="searchTerm" placeholder="Search by email, phone, or citizen ID" required>
            <input type="hidden" id="motelRoomId" name="motelRoomId" value="${motelRoomId}">
            <input type="button" value="Search" onclick="searchAccounts()">
        </form>

        <div id="searchResults"></div>
    </div>

    <div class="right-column" style="padding-top: 135px">
        <h2>Current Tenants</h2>

        <c:if test="${empty currentTenants}">
            <p>This room is currently empty.</p>
        </c:if>
        <c:if test="${not empty currentTenants}">
            <table>
                <tr>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Rent Start Date</th>
                </tr>
                <c:forEach var="renter" items="${currentTenants}">
                    <tr>
                        <td>${renter.account.fullname}</td>
                        <td>${renter.account.email}</td>
                        <td>${renter.account.phone}</td>
                        <td><fmt:formatDate value="${renter.renterDate}" pattern="yyyy-MM-dd"/></td>
                    </tr>
                </c:forEach>
            </table>
        </c:if>
    </div>
</div>

<script>
    function searchAccounts() {
        var searchTerm = $('#searchTerm').val();
        var motelRoomId = $('#motelRoomId').val();

        $.ajax({
            url: 'searchAccounts',
            method: 'GET',
            data: { searchTerm: searchTerm, motelRoomId: motelRoomId },
            success: function(response) {
                $('#searchResults').html(response);
            },
            error: function() {
                $('#searchResults').html('<p>An error occurred while searching.</p>');
            }
        });
    }

    function addTenant(accountId) {
        var motelRoomId = $('#motelRoomId').val();
        var startDate = $('#startDate_' + accountId).val();
        var errorSpan = $('#dateError_' + accountId);

        if (startDate === '') {
            errorSpan.show();
            return;
        }

        errorSpan.hide();

        $.ajax({
            url: 'addTenant',
            method: 'POST',
            data: { accountId: accountId, motelRoomId: motelRoomId, startDate: startDate },
            success: function(response) {
                if (response === 'success') {
                    alert('Tenant added successfully');
                    location.reload();  // Reload the page to show updated tenant list
                } else {
                    alert('Error: ' + response);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert('Error adding tenant: ' + textStatus + ' - ' + errorThrown);
            }
        });
    }
</script>
</body>
</html>