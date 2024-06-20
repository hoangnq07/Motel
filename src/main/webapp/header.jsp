<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>HOME</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500&family=Lora:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/lib/animate/animate.min.css" rel="stylesheet">
    <link href="assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>
<!-- Spinner Start -->
<div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
    <div class="spinner-border text-primary" role="status"></div>
</div>
<!-- Spinner End -->


<!-- Navbar Start -->
<div class="container-fluid fixed-top px-0 wow fadeIn" data-wow-delay="0.1s">

    <nav class="navbar navbar-expand-lg navbar-light py-lg-0 px-lg-5 wow fadeIn" data-wow-delay="0.1s">
        <a href="home" class="navbar-brand ms-4 ms-lg-0">
            <h1 class="fw-bold text-primary mb-4">H<span class="text-secondary">O</span>ME</h1>
        </a>

        <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="navbarCollapse">

            <form class="d-flex ms-auto me-4">
                <input class="form-control me-2" type="search" placeholder="Search" aria-label="Search">
                <button class="btn btn-outline-primary" type="submit">Search</button>
            </form>
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="index.jsp" class="nav-item nav-link active">Home</a>
                <a href="motel-rooms?action=list" class="nav-item nav-link">Room List</a>
                <a href="about.jsp" class="nav-item nav-link">Contact Us</a>
            </div>
            <div class="d-none d-lg-flex ms-2">

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown " style="list-style-type: none">
                            <a class="nav-link nav-icon-hover" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="true">
                                <c:choose>
                                    <c:when test="${empty sessionScope.user.avatar}">
                                        <small class="fa fa-user text-body"></small>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" alt="" width="35" height="35" class="rounded-circle">
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end show " aria-labelledby="userDropdown" data-bs-popper="none">
                                <div class="message-body">
                                    <a href="account_info.jsp" class="dropdown-item">User Profile</a>
                                    <c:if test="${sessionScope.user.role == 'owner'}">
                                        <a href="owner" class="dropdown-item">Manage Motel</a>
                                    </c:if>
                                    <a href="change_password.jsp" class="dropdown-item">Change Password</a>
                                    <a href="favorite-rooms" class="dropdown-item">My Favorite Room</a> <!-- Thêm dòng này -->
                                    <a href="logout" class="btn btn-outline-primary mx-3 mt-2 d-block">Log Out</a>
                                </div>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-outline-primary ms-3" href="login.jsp">Đăng nhập</a>
                        <a class="btn btn-primary ms-3" href="registration.jsp">Đăng ký</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </nav>
</div>
<!-- Navbar End -->

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script src="assets/lib/wow/wow.min.js"></script>
<script src="assets/lib/easing/easing.min.js"></script>
<script src="assets/lib/waypoints/waypoints.min.js"></script>
<script src="assets/js/main.js"></script>


</body>
</html>
