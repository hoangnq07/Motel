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
    <div class="row">
    <div class="col-md-2 sidebar">
        <ul class="nav flex-column">
            <li class="nav-item">
                <a class="nav-link " href="${pageContext.request.contextPath}/home">
                    <i class="fas fa-home mr-2"></i>Home
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.page == 'motel-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=motel-list">
                    <i class="fas fa-building mr-2"></i>Quản lý Nhà trọ
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.page == 'room-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=room-list">
                    <i class="fas fa-door-open mr-2"></i>Quản lý Phòng trọ
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.page == 'customer-management' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=customer-management">
                    <i class="fas fa-users mr-2"></i>Quản lý Thành viên
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.page == 'createinvoice' ? 'active' : ''}" href="createBill.jsp">
                    <i class="fas fa-file-invoice-dollar mr-2"></i>Hóa đơn
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${param.page == 'notifications' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=notify">
                    <i class="fas fa-bell mr-2"></i>Thông báo
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                    <i class="fas fa-sign-out-alt mr-2"></i>Logout
                </a>
            </li>
        </ul>
    </div>
<div class="container">
    <div class="col-md-10 content-area">
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

        <h2>Add New Tenant</h2>


        <form id="searchForm">
            <input type="text" id="searchTerm" name="searchTerm" placeholder="Search by email, phone, or citizen ID" required>
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
</script>
</body>
</html>