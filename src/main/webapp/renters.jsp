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
        <input type="text" name="searchQuery" placeholder="Search by name" value="${param.searchQuery != null ? param.searchQuery : ''}">
        <input type="hidden" name="action" value="search">
        <input type="submit" value="Search">
    </form>
    <br>
    <table class="table table-bordered">
        <tr>
            <th>ID</th>
            <th>Full Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Renter Date</th>
            <th>Check Out Date</th>
        </tr>
        <c:forEach var="renter" items="${rentersList}">
            <tr>
                <td>${renter.renterId}</td>
                <td>${renter.fullname}</td>
                <td>${renter.email}</td>
                <td>${renter.phone}</td>
                <td>${renter.renterDate}</td>
                <td>${renter.checkOutDate}</td>
                <td>
                    <form method="post" action="RentersServlet" style="display:inline;">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="renterId" value="${renter.renterId}">
                        <input type="submit" value="Delete" class="btn btn-danger">
                    </form>
                    <form method="post" action="RentersServlet" style="display:inline;">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="renterId" value="${renter.renterId}">
                        <input type="hidden" name="fullname" value="${renter.fullname}">
                        <input type="hidden" name="email" value="${renter.email}">
                        <input type="hidden" name="phone" value="${renter.phone}">
                        <input type="hidden" name="renterDate" value="${renter.renterDate}">
                        <input type="hidden" name="checkOutDate" value="${renter.checkOutDate}">
                        <input type="submit" value="Edit" class="btn btn-primary">
                    </form>
                </td>
            </tr>
        </c:forEach>
    </table>

    <h3>Add a New Renter</h3>
    <form method="post" action="RentersServlet">
        <input type="hidden" name="action" value="add">
        <div class="form-group">
            <label>Full Name:</label>
            <input type="text" name="fullname" class="form-control" required>
        </div>
        <div class="form-group">
            <label>Email:</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="form-group">
            <label>Phone:</label>
            <input type="text" name="phone" class="form-control" required>
        </div>
        <div class="form-group">
            <label>Renter Date:</label>
            <input type="date" name="renterDate" class="form-control" required>
        </div>
        <div class="form-group">
            <label>Check Out Date:</label>
            <input type="date" name="checkOutDate" class="form-control" required>
        </div>
        <input type="submit" value="Add Renter" class="btn btn-success">
    </form>
</div>
</body>
</html>
