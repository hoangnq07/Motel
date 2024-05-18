<%-- Document : header.jsp Created on : 28-02-2024, 20:30:36 Author : PC --%>

    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <!DOCTYPE html>
            <html>

            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
                <title>JSP Page</title>



                <!-------------------------------------------------------------------------------->
                <link rel="stylesheet" type="text/css" href="assets/css/bootstrap.min.css">
                <!-- style css -->
                <link rel="stylesheet" type="text/css" href="assets/css/style.css">
                <!-- Responsive-->
                <link rel="stylesheet" href="assets/css/responsive.css">
                <!-- fevicon -->
                <link rel="icon" href="assets/images/fevicon.png" type="image/gif" />
                <!-- Scrollbar Custom CSS -->
                <link rel="stylesheet" href="assets/css/jquery.mCustomScrollbar.min.css">
                <!-- Tweaks for older IEs-->
                <link rel="stylesheet" href="https://netdna.bootstrapcdn.com/font-awesome/4.0.3/css/font-awesome.css">
                <!-- owl stylesheets -->
                <link rel="stylesheet" href="assets/css/owl.carousel.min.css">
                <link rel="stylesheet" href="assets/css/owl.theme.default.min.css">
                <link rel="stylesheet"
                    href="https://cdnjs.cloudflare.com/ajax/libs/fancybox/2.1.5/jquery.fancybox.min.css" media="screen">
                <link href="https://unpkg.com/gijgo@1.9.13/css/gijgo.min.css" rel="stylesheet" type="text/css" />
                <!-------------------------------------------------------------------------------->
                <style>
                    .cart-overlay {
                        position: absolute;
                        top: 0;
                        right: 0;

                        width: 25px;
                        height: 25px;

                        background: red;
                        color: #fff;

                        display: flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 50%;
                    }

                    #dropdown-menu {
                        position: fixed;
                        z-index: 2;
                        background-color: orange;
                    }

                    #dropdown-menu {
                        display: none;
                        position: absolute;
                        min-width: 160px;
                        box-shadow: #df9911;
                        z-index: 1;
                    }

                    .dropdown-toggle {
                        background-color: #df9911;
                    }

                    .dropdown {
                        margin-right: 40px;
                    }

                    .dropdown:hover #dropdown-menu {
                        display: block;
                    }

                    #search_input_wrapper {
                        display: none;
                    }

                    #search_input_wrapper.show {
                        display: block;
                    }
                </style>
            </head>

            <body>
                <header class="header_section">
                    <nav class="navbar navbar-expand-lg navbar-light bg-light">
                        <a class="logo" href="home"><img src="assets/images/logo.png"></a>
                        <button class="navbar-toggler" type="button" data-toggle="collapse"
                            data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent"
                            aria-expanded="false" aria-label="Toggle navigation">
                            <span class="navbar-toggler-icon"></span>
                        </button>

                        <div class="collapse navbar-collapse" id="navbarSupportedContent">
                            <ul class="navbar-nav mr-auto">
                                <li class="row nav-item active menu">
                                    <div class="dropdown" onmouseover="openDropdown()" onmouseout="closeDropdown()">
                                        <button class="btn btn-secondary dropdown-toggle" type="button"
                                            aria-expanded="false">
                                            CATEGORIES
                                        </button>
                                        <ul id="dropdown-menu">
                                            <li><a href="product"><button class="dropdown-item" type="button">All
                                                        Book</button></a></li>
                                            <li><a href="product?action=newArrival"><button class="dropdown-item"
                                                        type="button">New Arrivals</button></a></li>
                                            <li>
                                                <a href="product?action=category&category=Genre&input=Fiction"><button class="dropdown-item"
                                                    type="button">Fiction</button></a></li>
                                            </li>
                                            <li>
                                                <a href="product?action=category&category=Genre&input=Non-Fiction"><button class="dropdown-item"
                                                    type="button">Non-Fiction</button></a></li>
                                            </li>
                                            <li>
                                                <a href="product?action=category&category=Genre&input=Mystery"><button class="dropdown-item"
                                                    type="button">Mystery</button></a></li>
                                            </li>
                                            <li>
                                                <a href="product?action=category&category=Genre&input=Fantasy"><button class="dropdown-item"
                                                    type="button">Fantasy</button></a></li>
                                            </li>
                                        </ul>
                                    </div>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link single-line" href="product">All BOOKS</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link single-line" href="product?action=newArrival">NEW ARRIVALS</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link single-line" href="faq.jsp">FAQ</a>
                                </li>
                                <li class="nav-item">
                                    <a class="nav-link single-line" href="contact.jsp">CONTACT</a>
                                </li>
                                <li class="nav-item ">
                                    <a class="nav-link single-line" href="about-us.jsp">ABOUT US</a>
                                </li>
                            </ul>
                            <div class="search_icon">
                                <div id="search_input_wrapper row">
                                    <form action="product" method="get">
                                        <input type="hidden" name="action" value="search">
                                        <input type="text" id="search_input" name="input" placeholder="Search..."
                                            onblur="hideSearch() " required>
                                        <button type="submit" class="btn btn-outline-primary"
                                            data-mdb-ripple-init>search</button>
                                    </form>

                                </div>
                            </div>
                            <div class="search_icon"><a href="registration.jsp"><img
                                        src="assets/images/eye-icon.png"><span
                                        class="padding_left_15">Register</span></a></div>
                            <div class="search_icon"><a href="login.jsp"><img src="assets/images/user-icon.png"><span
                                        class="padding_left_15">login</span></a></div>
                            <div class="search_icon">
                                <a href="cart">
                                    <img class="image_cart" src="assets/images/image-cart_90604.png">
                                    <c:if test="${not empty sessionScope.cart}">
                                        <div class="cart-overlay">

                                            ${sessionScope.cart.size()}

                                        </div>
                                    </c:if>
                                    <span class="padding_left_15">Cart</span>
                                </a>
                            </div>
                        </div>
                    </nav>
                    <script src="js/scripts.js"></script>
                </header>
            </body>

            </html>