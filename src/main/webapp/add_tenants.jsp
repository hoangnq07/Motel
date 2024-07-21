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
        /* Modal background */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow-x: hidden;
            overflow-y: auto;
            background-color: rgba(0,0,0,0.4);
        }

        /* Modal content */
        .modal-content {
            background-color: #fefefe;
            margin: 5% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 5px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
            max-height: 90vh;
            overflow-y: auto;
        }


        /* Prevent body scrolling when modal is open */
        body.modal-open {
            overflow: hidden;
        }
        .modal-content {
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.1);
        }

        .modal-header {
            background-color: #007bff;
            color: white;
            border-bottom: none;
            border-top-left-radius: 8px;
            border-top-right-radius: 8px;
            padding: 20px;
        }

        .modal-title {
            font-weight: bold;
        }

        .modal-body {
            padding: 20px;
        }

        .modal-footer {
            border-top: none;
            padding: 20px;
        }

        #addTenantForm label {
            font-weight: 600;
            color: #495057;
        }

        #addTenantForm input[type="date"],
        #addTenantForm input[type="number"] {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
            border: 1px solid #ced4da;
            border-radius: 4px;
            transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
        }

        #addTenantForm input[type="date"]:focus,
        #addTenantForm input[type="number"]:focus {
            border-color: #80bdff;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }

        #addTenantForm button[type="submit"] {
            background-color: #28a745;
            border: none;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            transition: background-color 0.15s ease-in-out;
        }

        #addTenantForm button[type="submit"]:hover {
            background-color: #218838;
        }

        /* Return room button style */
        .btn-return-room {
            background-color: #dc3545;
            color: white;
            border: none;
            padding: 5px 10px;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.15s ease-in-out;
        }

        .btn-return-room:hover {
            background-color: #c82333;
        }
        /* Responsive design */
        @media screen and (max-width: 600px) {
            .modal-content {
                width: 95%;
                margin: 10% auto;
            }
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
            <h2>Current Tenants</h2>

            <c:if test="${empty currentTenants}">
                <p>This room is currently empty.</p>
            </c:if>
            <c:if test="${not empty currentTenants}">
                <table id="currentTenantsTable">
                    <tr>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Rent Start Date</th>
                        <th>Actions</th>
                    </tr>
                    <c:forEach var="renter" items="${currentTenants}">
                        <tr>
                            <td>${renter.account.fullname}</td>
                            <td>${renter.account.email}</td>
                            <td>${renter.account.phone}</td>
                            <td><fmt:formatDate value="${renter.renterDate}" pattern="yyyy-MM-dd"/></td>
                            <td>
                                <button class="btn-return-room" onclick="returnRoom(${renter.renterId}, ${motelRoomId})">Return Room</button>
                            </td>
                        </tr>
                    </c:forEach>
                </table>
            </c:if>
        </div>

        <h2>Add New Tenant</h2>


        <form id="searchForm">
            <input type="text" id="searchTerm" name="searchTerm" placeholder="Search user here!" required>
            <input type="hidden" id="motelRoomId" name="motelRoomId" value="${motelRoomId}">
            <input type="button" value="Search" onclick="searchAccounts()">
        </form>

        <div id="searchResults"></div>
    </div>

        <div id="addTenantModal" class="modal">
            <div class="modal-content">
                <span class="close">&times;</span>
                <h2>Add New Tenant</h2>
                <form id="addTenantForm" method="POST">
                    <input type="hidden" id="modalAccountId" name="accountId">
                    <input type="hidden" id="modalMotelRoomId" name="motelRoomId">
                    <label for="modalStartDate">Start Date:</label>
                    <input type="date" id="modalStartDate" name="startDate" required>
                    <div id="utilityIndexInputs" style="display: none;">
                        <label for="modalElectricityIndex">Current Electricity Index:</label>
                        <input type="number" id="modalElectricityIndex" name="electricityIndex">
                        <label for="modalWaterIndex">Current Water Index:</label>
                        <input type="number" id="modalWaterIndex" name="waterIndex">
                    </div>
                    <input type="hidden" id="modalIsRoomOccupied" name="isRoomOccupied">
                    <button type="submit">Add Tenant</button>
                </form>
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
</script>


<script>
    // Get the modal
    var modal = document.getElementById("addTenantModal");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];


    function openAddTenantModal(accountId, motelRoomId) {
        document.getElementById("modalAccountId").value = accountId;
        document.getElementById("modalMotelRoomId").value = motelRoomId;
        var currentTenantsTable = document.getElementById("currentTenantsTable");
        var isRoomOccupied = currentTenantsTable && currentTenantsTable.rows.length > 1;
        document.getElementById("modalIsRoomOccupied").value = isRoomOccupied;
        // Check if room is occupied
        $.ajax({
            url: 'motel-rooms',
            method: 'GET',
            data: { action : 'checkRoomOccupancy', motelRoomId: motelRoomId},
            success: function(response) {
                if (response === 'occupied') {
                    alert('Phòng đã đầy, không thể thêm người thuê!');
                } else {
                    // If room is not occupied, show utility input fields
                    if(isRoomOccupied) {
                        document.getElementById("utilityIndexInputs").style.display = "none";
                    }
                    else {
                        document.getElementById("utilityIndexInputs").style.display = "block";
                    }
                    modal.style.display = "block";
                    document.body.classList.add('modal-open');
                }
            },
            error: function() {
                alert('Error checking room occupancy');
            }
        });
    }

    // Modify the existing close functions
    span.onclick = function() {
        modal.style.display = "none";
        document.body.classList.remove('modal-open');
    }

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
            document.body.classList.remove('modal-open');
        }
    }

    document.getElementById("addTenantForm").onsubmit = function(e) {
        e.preventDefault();
        if (validateStartDate()) {
            addTenant();
        } else {
            alert("Start date cannot be in the past.");
        }
    };

    function validateStartDate() {
        var startDate = new Date($('#modalStartDate').val());
        var today = new Date();

        // Thiết lập giờ, phút, giây, và mili giây của ngày hiện tại về 0
        today.setHours(0, 0, 0, 0);

        // So sánh ngày bắt đầu với ngày hiện tại
        return startDate >= today;
    }

    function addTenant() {
        var accountId = $('#modalAccountId').val();
        var motelRoomId = $('#modalMotelRoomId').val();
        var startDate = $('#modalStartDate').val();
        var electricityIndex = $('#modalElectricityIndex').val();
        var waterIndex = $('#modalWaterIndex').val();
        var isRoomOccupied = $('#modalIsRoomOccupied').val();

        var data = {
            accountId: accountId,
            motelRoomId: motelRoomId,
            startDate: startDate,
            isHasRenter: isRoomOccupied
        };

        // Only add utility indices if they are visible (i.e., room was unoccupied)
        if (document.getElementById("utilityIndexInputs").style.display !== "none") {
            data.electricityIndex = electricityIndex;
            data.waterIndex = waterIndex;
        }

        $.ajax({
            url: 'addTenant',
            method: 'POST',
            data: data,
            success: function(response) {
                if (response === 'success') {
                    alert('Tenant added successfully');
                    var modal = document.getElementById("addTenantModal");
                    modal.style.display = "none";
                    location.reload();
                } else {
                    alert('Error: ' + response);
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                alert('Error adding tenant: ' + textStatus + ' - ' + errorThrown);
            }
        });

    }
    function returnRoom(renterId, motelRoomId) {
        if (confirm('Bạn có muốn thực hiện trả phòng?')) {
            $.ajax({
                url: 'checkOut',
                method: 'POST',
                data: { renterId: renterId, motelRoomId: motelRoomId },
                success: function(response) {
                    if (response === 'success') {
                        alert('Trả phòng thành công');
                        location.reload();
                    } else {
                        alert('Error: ' + response);
                    }
                },
                error: function() {
                    alert('An error occurred while processing your request.');
                }
            });
        }
    }
</script>
</body>
</html>