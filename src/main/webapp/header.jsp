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
    <link href="${pageContext.request.contextPath}/assets/lib/animate/animate.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/assets/css/style.css" rel="stylesheet">
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
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="motel-rooms?action=list" class="nav-item nav-link">Danh Sách Phòng</a>
                <a href="feedback.jsp" class="nav-item nav-link">Đánh Giá</a>
                <a href="viewNotifications" class="nav-item nav-link">Thông Báo</a>
            </div>
            <div class="d-none d-lg-flex ms-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown" style="list-style-type: none">
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
                            <div class="dropdown-menu dropdown-menu-end show" aria-labelledby="userDropdown" data-bs-popper="none">
                                <div class="message-body">
                                    <a href="account_info.jsp" class="dropdown-item">Trang Cá Nhân</a>
                                    <c:if test="${sessionScope.user.role == 'owner'}">
                                        <a href="owner" class="dropdown-item">Quản Lý</a>
                                    </c:if>
                                    <c:if test="${sessionScope.user.role == 'admin'}">
                                        <a href="admincheckrequest.jsp" class="dropdown-item">Yêu Cầu</a>
                                    </c:if>
                                    <c:if test="${sessionScope.user.role == 'user'}">
                                        <a href="${pageContext.request.contextPath}/checkRequest" class="dropdown-item">Yêu Cầu</a>
                                        <a href="bills.jsp" class="dropdown-item">Hóa Đơn</a>
                                    </c:if>
                                    <a href="favorite-rooms" class="dropdown-item">Phòng Yêu Thích</a>
                                    <a href="change_password.jsp" class="dropdown-item">Đổi Mật Khẩu</a>
                                    <a href="logout" class="btn btn-outline-primary mx-3 mt-2 d-block">Đăng Xuất</a>
                                </div>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-outline-primary ms-3" href="login.jsp">Đăng Nhập</a>
                        <a class="btn btn-primary ms-3" href="registration.jsp">Đăng Ký</a>
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
<script src="${pageContext.request.contextPath}/assets/lib/wow/wow.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/easing/easing.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/lib/waypoints/waypoints.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
</body>
</html>
