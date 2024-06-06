<%-- Document : header.jsp Created on : 28-02-2024, 20:30:36 Author : PC --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
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
                <a href="about.jsp" class="nav-item nav-link">About Us</a>
                <a href="product.jsp" class="nav-item nav-link">Products</a>
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
                        <div class="btn-sm-square bg-white rounded-circle ms-3">
                            <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" alt="Avatar" class="rounded-circle" onclick="toggleMenu(this)" width="50" height="50">
                        </div>
                        <ul id="menu" class="menu-list">
                            <li><a href="account_info.jsp">User Profile</a></li>
                            <li><a href="change_password.jsp">Change Password</a></li>
                            <li><a href="logout">Log Out</a></li>
                        </ul>
                    </c:when>
                    <c:otherwise>
                        <a class="btn-sm-square bg-white rounded-circle ms-3" href="login.jsp">
                            <small class="fa fa-user text-body"></small>
                        </a>
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
    function toggleMenu(avatar) {
        var menu = document.getElementById("menu");
        if (menu.style.display === "none") {
            menu.style.display = "block";
            document.addEventListener("click", hideMenuOutside);
        } else {
            menu.style.display = "none";
        }
    }

    function hideMenuOutside(event) {
        var menu = document.getElementById("menu");
        var avatar = menu.previousElementSibling;
        var isClickInside = menu.contains(event.target) || avatar === event.target;
        if (!isClickInside) {
            menu.style.display = "none";
            document.removeEventListener("click", hideMenuOutside);
        }
    }
</script>
</body>
</html>
