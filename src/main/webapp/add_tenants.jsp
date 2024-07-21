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
    <title>Thêm người thuê</title>
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
            margin-top: 50px;
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

    </style>
</head>
<body>

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
            <h2>Người thuê hiện tại</h2>

            <c:if test="${empty currentTenants}">
                <p>Phòng này hiện đang trống người thuê</p>
            </c:if>
            <c:if test="${not empty currentTenants}">
                <table>
                    <tr>
                        <th>Tên</th>
                        <th>Email</th>
                        <th>Số điện thoại</th>
                        <th>Ngày bắt đầu thuê</th>
                        <th>Action</th>
                    </tr>
                    <c:forEach var="renter" items="${currentTenants}">
                        <tr>
                            <td>${renter.account.fullname}</td>
                            <td>${renter.account.email}</td>
                            <td>${renter.account.phone}</td>
                            <td><fmt:formatDate value="${renter.renterDate}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <button onclick="deleteTenant(${renter.renterId}, ${motelRoomId})">Delete</button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
        </div>

        <h2>Thêm người thuê</h2>


        <form id="searchForm">
            <input type="text" id="searchTerm" name="searchTerm" placeholder="Search by email, phone, or citizen ID" required>
            <input type="hidden" id="motelRoomId" name="motelRoomId" value="${motelRoomId}">
            <input type="button" value="Search" onclick="searchAccounts()">
        </form>

        <div id="searchResults"></div>
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
                $('#searchResults').html('<p>Có lỗi trong quá trình tìm</p>');
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
    function deleteTenant(renterId, motelRoomId) {
        if (confirm('Bạn có chắc chắn muốn xóa người thuê này?')) {
            $.ajax({
                url: 'deleteTenant',
                method: 'POST',
                data: { renterId: renterId, motelRoomId: motelRoomId },
                success: function(response) {
                    if (response === 'success') {
                        alert('Xóa người thuê thành công');
                        location.reload();  // Tải lại trang để cập nhật danh sách
                    } else {
                        alert('Lỗi: ' + response);
                    }
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert('Lỗi khi xóa người thuê: ' + textStatus + ' - ' + errorThrown);
                }
            });
        }
    }
</script>
</body>
</html>