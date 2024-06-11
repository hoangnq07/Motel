<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Thành viên</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
</head>
<body>
<div class="container mt-4">
    <h2>Renters List</h2>
    <form method="get" action="RentersServlet">
        <input type="text" name="searchQuery" placeholder="Search by name">
        <button type="submit" class="btn btn-primary">Search</button>
    </form>
    <table class="table table-bordered mt-3">
        <thead>
        <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Renter Date</th>
            <th>Check Out Date</th>
            <th>Motel Room ID</th>
            <th>Action</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="renter" items="${rentersList}">
            <tr>
                <td>${renter.renterId}</td>
                <td>${renter.fullname}</td>
                <td>${renter.email}</td>
                <td>${renter.phone}</td>
                <td>${renter.renterDate}</td>
                <td>${renter.checkOutDate}</td>
                <td>${renter.motelRoomId}</td>
                <td>
                    <form method="post" action="RentersServlet" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="renterId" value="${renter.renterId}">
                        <button type="submit" class="btn btn-danger">Delete</button>
                    </form>
                    <form method="post" action="RentersServlet" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="renterId" value="${renter.renterId}">
                        <button type="submit" class="btn btn-warning">Update</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <h3>Add a New Renter</h3>
    <form method="post" action="RentersServlet">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <%--@declare id="fullname"--%><label for="fullname">Full Name:</label>
            <input type="text" name="fullname" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="email"--%><label for="email">Email:</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="phone"--%><label for="phone">Phone:</label>
            <input type="text" name="phone" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="renterdate"--%><label for="renterDate">Renter Date:</label>
            <input type="date" name="renterDate" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="checkoutdate"--%><label for="checkOutDate">Check Out Date:</label>
            <input type="date" name="checkOutDate" class="form-control" required>
        </div>
        <div class="form-group">
            <%--@declare id="motelroomid"--%><label for="motelRoomId">Motel Room ID:</label>
            <input type="number" id="motelRoomId" name="motelRoomId" class="form-control" required>
        </div>
        <button type="submit" class="btn btn-primary">Add Renter</button>
    </form>
</div>
</body>
</html>
