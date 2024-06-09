<%-- Document : header.jsp Created on : 28-02-2024, 20:30:36 Author : PC --%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Trang chủ</title>
        <style>
            body {
                margin: 0;
                font-family: Arial, sans-serif;
            }
            .navbar {
                display: flex;
                align-items: center;
                justify-content: space-between;
                background-color: #f8f8f8;
                padding: 10px 20px;
                border-bottom: 1px solid #ccc;
            }
            .navbar .logo {
                font-size: 20px;
                font-weight: bold;
            }
            .navbar .menu {
                display: flex;
                gap: 20px;
            }
            .navbar .menu a {
                text-decoration: none;
                color: black;
                font-size: 16px;
            }
            .navbar .buttons {
                display: flex;
                gap: 10px;
            }
            .navbar .buttons a {
                text-decoration: none;
                color: black;
                padding: 5px 10px;
                border: 1px solid #ccc;
                background-color: white;
                display: inline-block;
                text-align: center;
                cursor: pointer;
            }
            .navbar .buttons a:hover {
                background-color: #e0e0e0;
            }
            .navbar .buttons a:visited {
                color: black;
            }
            .menu-list {
                list-style-type: none;
                padding: 0;
                margin: 0;
                position: absolute;
                right: 10px;
                background-color: #f9f9f9;
                box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
                z-index: 1;
                display: none;
                min-width: 200px;
            }

            .menu-list li {
                width: 150px; /* Đặt chiều rộng cho các mục trong menu */
            }

            .menu-list li a {
                color: black;
                padding: 16px 20px;
                text-decoration: none;
                display: block;
                font-size: 16px;
                white-space: nowrap; /* Ngăn chữ bị xuống dòng */
                overflow: hidden; /* Ẩn nội dung vượt quá chiều rộng */
                text-overflow: ellipsis; /* Hiển thị dấu ... cho nội dung vượt quá */
            }

            .menu-list li a:hover {
                background-color: #f1f1f1;
            }
        </style>
    </head>
    <body>
        <div class="navbar">
            <div class="logo">HOME</div>
            <div class="menu">
                <a href="index.jsp">Trang chủ</a>
                <a href="#">Sản phẩm</a>
                <a href="#">Chia sẻ</a>
                <a href="myMotel.jsp">My motel</a>
            </div>
            <div class="buttons">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <div class="user-menu">
                            <c:choose>
                                <c:when test="${empty sessionScope.user.avatar}">
                                    <img src="default_avatar.png" alt="Avatar" class="avatar" onclick="toggleMenu(this)" width="50" height="50">
                                </c:when>
                                <c:otherwise>
                                    <img src="${pageContext.request.contextPath}/uploads/${sessionScope.user.avatar}" alt="Avatar" class="avatar" onclick="toggleMenu(this)" width="50" height="50">
                                </c:otherwise>
                            </c:choose>
                            <ul id="menu" class="menu-list">
                                <li><a href="account_info.jsp">User Profile</a></li>
                                <li><a href="change_password.jsp">Change Password</a></li>
                                <li><a href="logout">Log Out</a></li>
                            </ul>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <a href="login.jsp">Login</a>
                        <a href="registration.jsp">Register</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
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
</html>

