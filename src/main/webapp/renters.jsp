<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
          integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <title>Quản lý Thành viên</title>
</head>
<body>
<div class="container mt-4">
    <h3>Quản lý thành viên</h3>
    <div class="row">
        <div class="col-md-12">
            <form class="form-inline" action="renters" method="get">
                <input type="hidden" name="action" value="search">
                <input class="form-control mr-sm-2" type="search" name="email" placeholder="Search by email" aria-label="Search">
                <button class="btn btn-outline-success my-2 my-sm-0" type="submit">Search</button>
            </form>
        </div>
    </div>
    <div class="row mt-4">
        <div class="col-md-12">
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Fullname</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Gender</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="account" items="${accounts}">
                    <tr>
                        <td>${account.fullname}</td>
                        <td>${account.email}</td>
                        <td>${account.phone}</td>
                        <td>${account.role}</td>
                        <td><c:choose>
                            <c:when test="${account.gender}">Male</c:when>
                            <c:otherwise>Female</c:otherwise>
                        </c:choose></td>
                        <td>
                            <form action="renters" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="add">
                                <input type="hidden" name="account_id" value="${account.accountId}">
                                <button type="submit" class="btn btn-success btn-sm">Add</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <div class="row mt-4">
        <div class="col-md-12">
            <h3>Danh sách người thuê</h3>
            <table class="table table-striped">
                <thead>
                <tr>
                    <th>Fullname</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Gender</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="renter" items="${renters}">
                    <tr>
                        <td>${renter.fullname}</td>
                        <td>${renter.email}</td>
                        <td>${renter.phone}</td>
                        <td>${renter.role}</td>
                        <td><c:choose>
                            <c:when test="${renter.gender}">Male</c:when>
                            <c:otherwise>Female</c:otherwise>
                        </c:choose></td>
                        <td>
                            <form action="renters" method="post" style="display:inline;">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="account_id" value="${renter.accountId}">
                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>
</html>
