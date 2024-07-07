<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
          integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
    <title>Owner Dashboard</title>
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background-color: #343a40;
            min-height: 100vh;
            padding-top: 20px;
        }
        .sidebar .nav-link {
            color: #fff;
            transition: all 0.3s;
            padding: 10px 15px;
            border-radius: 5px;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background-color: #007bff;
        }
        .sidebar .nav-link i {
            margin-right: 10px;
        }
        .content-area {
            padding: 20px;
        }
        .dashboard-header {
            background-color: #007bff;
            color: #fff;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .card {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
        }
        .card:hover {
            box-shadow: 0 6px 8px rgba(0, 0, 0, 0.15);
            transform: translateY(-5px);
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link" href="home"><i class="fas fa-home"></i> Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-target="motel-management"><i class="fas fa-building"></i> Quản lý Nhà trọ</a>
                </li>
                    <a class="nav-link" href="logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                </li>
            </ul>
        </div>
        <div class="col-md-10 content-area">
            <div id="motel-management" class="content">
                <jsp:include page="motel-list.jsp"></jsp:include>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
</body>
</html>