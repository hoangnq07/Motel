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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Tenants</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <style>
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

        body {
            font-family: Arial, sans-serif;
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }
        h1, h2 {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .actions a {
            margin-right: 10px;
        }
        .create-btn {
            margin-bottom: 20px;
        }
        .modal-body {
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }

        .sidebar {
            background-color: #343a40;
            min-height: 100vh;
            padding-top: 20px;
        }
        .sidebar a {
            color: #f8f9fa;
            padding: 10px 15px;
            display: block;
            transition: all 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
            text-decoration: none;
        }
        .content-area {
            padding: 20px;
        }
        .nav-link {
            border-radius: 0;
        }

    </style>
</head>
<body>
<div class="container-fluid">
    <div class="container">
        <div class="col-md-10 content-area">
            <div>
                <div>

                    <%
                        if (request.getAttribute("currentTenants") == null) {
                            int motelRoomId = Integer.parseInt(request.getParameter("motel_room_id"));
                            RenterDAO renterDAO = new RenterDAO();
                            List<Renter> currentTenants = renterDAO.getCurrentTenants(motelRoomId);
                            request.setAttribute("currentTenants", currentTenants);
                            request.setAttribute("motelRoomId", motelRoomId);
                        }
                    %>

                    <div>
                        <h2>Những người đang thuê</h2>

                        <c:if test="${empty currentTenants}">
                            <p>Phòng này hiện đang trống!</p>
                        </c:if>
                        <c:if test="${not empty currentTenants}">
                            <table>
                                <tr>
                                    <th>Tên</th>
                                    <th>Email</th>
                                    <th>Số Điện Thoại</th>
                                    <th>Ngày Thuê</th>
                                    <th>Hành Động</th>
                                </tr>
                                <c:forEach var="renter" items="${currentTenants}">
                                    <tr>
                                        <td>${renter.account.fullname}</td>
                                        <td>${renter.account.email}</td>
                                        <td>${renter.account.phone}</td>
                                        <td><fmt:formatDate value="${renter.renterDate}" pattern="yyyy-MM-dd"/></td>
                                        <td>
                                            <button onclick="kickOutTenant(${renter.renterId})">Xóa Khỏi Phòng</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </table>
                        </c:if>
                    </div>

                    <h2>Thêm Người Thuê</h2>
                    <form id="searchForm">
                        <input type="text" id="searchTerm" name="searchTerm" placeholder="Tìm email, số điện thoại và cccd" required>
                        <input type="hidden" id="motelRoomId" name="motelRoomId" value="${motelRoomId}">
                        <input type="button" value="Search" onclick="searchAccounts()">
                    </form>
                    <div id="searchResults"></div>
                </div>
            </div>
        </div>
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

    function kickOutTenant(renterId) {
        if (confirm('Are you sure you want to kick out this tenant?')) {
            $.ajax({
                url: 'kickOutTenant',
                method: 'POST',
                data: { renterId: renterId },
                success: function(response) {
                    if (response === 'success') {
                        alert('Tenant kicked out successfully');
                        location.reload();  // Reload the page to show updated tenant list
                    } else {
                        alert('Error kicking out tenant');
                    }
                },
                error: function() {
                    alert('Error occurred while kicking out tenant');
                }
            });
        }
    }
</script>
</body>
</html>