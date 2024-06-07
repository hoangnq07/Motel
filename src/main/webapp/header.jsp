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
        <a href="index.jsp" class="navbar-brand ms-4 ms-lg-0">
            <h1 class="fw-bold text-primary mb-4">H<span class="text-secondary">O</span>ME</h1>
        </a>
        <button type="button" class="navbar-toggler me-4" data-bs-toggle="collapse" data-bs-target="#navbarCollapse">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarCollapse">
            <div class="navbar-nav ms-auto p-4 p-lg-0">
                <a href="index.jsp" class="nav-item nav-link active">Home</a>
                <a href="product.jsp" class="nav-item nav-link">Products</a>
                <a href="about.jsp" class="nav-item nav-link">About Us</a>
                <div class="nav-item dropdown">
                    <a href="#" class="nav-link dropdown-toggle" data-bs-toggle="dropdown">Pages</a>
                    <div class="dropdown-menu m-0">
                        <a href="blog.jsp" class="dropdown-item">Blog Grid</a>
                        <a href="feature.jsp" class="dropdown-item">Our Features</a>
                        <a href="testimonial.jsp" class="dropdown-item">Testimonial</a>
                        <a href="404.jsp" class="dropdown-item">404 Page</a>
                    </div>
                </div>
                <a href="contact.jsp" class="nav-item nav-link">Contact Us</a>
            </div>
            <div class="d-none d-lg-flex ms-2">
                <a class="btn-sm-square bg-white rounded-circle ms-3" href="">
                    <small class="fa fa-search text-body"></small>
                </a>
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item dropdown">
                            <a class="nav-link nav-icon-hover" href="javascript:void(0)" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
                                <c:choose>
                                    <c:when test="${empty sessionScope.user.avatar}">
                                        <small class="fa fa-user text-body"></small>
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" alt="" width="35" height="35" class="rounded-circle">
                                    </c:otherwise>
                                </c:choose>
                            </a>
                            <div class="dropdown-menu dropdown-menu-end dropdown-menu-animate-up" aria-labelledby="userDropdown">
                                <div class="message-body">
                                    <a href="account_info.jsp" class="d-flex align-items-center gap-2 dropdown-item">
                                        <i class="ti ti-user fs-6"></i>
                                        <p class="mb-0 fs-3">User Profile</p>
                                    </a>
                                    <a href="change_password.jsp" class="d-flex align-items-center gap-2 dropdown-item">
                                        <i class="ti ti-mail fs-6"></i>
                                        <p class="mb-0 fs-3">Change Password</p>
                                    </a>
                                    <a href="logout" class="btn btn-outline-primary mx-3 mt-2 d-block">Log Out</a>
                                </div>
                            </div>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <a class="btn btn-outline-primary ms-3" href="login.jsp">Đăng nhập</a>
                        <a class="btn btn-primary ms-3" href="register.jsp">Đăng ký</a>
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

<script>
    document.addEventListener("DOMContentLoaded", function() {
        const userDropdown = document.getElementById("userDropdown");
        const dropdownMenu = document.querySelector(".dropdown-menu-animate-up");

        userDropdown.addEventListener("click", function(event) {
            event.stopPropagation();
            dropdownMenu.classList.toggle("show");
        });

        document.addEventListener("click", function(event) {
            if (!dropdownMenu.contains(event.target) && !userDropdown.contains(event.target)) {
                dropdownMenu.classList.remove("show");
            }
        });
    });
</script>
</body>
</html>
