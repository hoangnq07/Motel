<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng Người Chủ</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .sidebar {
            background-color: #343a40;
            min-height: 100vh;
            padding-top: 20px;
        }
        .sidebar a {
            color: #f8f9fa;
            padding: 10px 15px;
            display: block;
            transition: all 0.3s;
        }
        .sidebar a:hover, .sidebar a.active {
            background-color: #495057;
            text-decoration: none;
        }
        .content-area {
            padding: 20px;
        }
        .nav-link {
            border-radius: 0;
        }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <div class="col-md-2 sidebar">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link " href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home mr-2"></i>Trang Chủ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'motel-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=motel-list">
                        <i class="fas fa-building mr-2"></i>Quản lý Trọ
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'room-list' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=room-list">
                        <i class="fas fa-door-open mr-2"></i>Quản lý Phòng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'all-renters' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=all-renters">
                        <i class="fas fa-users mr-2"></i>Danh sách người thuê
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'createinvoice' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=bill">
                        <i class="fas fa-file-invoice-dollar mr-2"></i>Hóa Đơn
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'notifications' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=notify">
                        <i class="fas fa-bell mr-2"></i>Thông Báo
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'feedback' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=feedback">
                        <i class="fas fa-comments mr-2"></i>Đánh Giá
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.page == 'statics' ? 'active' : ''}" href="${pageContext.request.contextPath}/owner?page=statics">
                        <i class="fas fa-chart-bar mr-2"></i>Doanh Thu
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/logout">
                        <i class="fas fa-sign-out-alt mr-2"></i>Đăng Xuất
                    </a>
                </li>
            </ul>
        </div>
        <div class="col-md-10 content-area">
            <c:choose>
                <c:when test="${param.page == 'motel-list'}">
                    <jsp:include page="motel-list.jsp"/>
                </c:when>
                <c:when test="${param.page == 'room-list'}">
                    <jsp:include page="motel-rooms-list.jsp"/>
                </c:when>
                <c:when test="${param.page == 'all-renters'}">
                    <jsp:include page="all-renters.jsp"/>
                </c:when>
                <c:when test="${param.page == 'notify'}">
                    <jsp:include page="notify.jsp"/>
                </c:when>
                <c:when test="${param.page == 'bill'}">
                    <jsp:include page="manageInvoices.jsp"/>
                </c:when>
                <c:when test="${param.page == 'feedback'}">
                    <jsp:include page="listFeedbackOwner.jsp"/>
                </c:when>
                <c:when test="${param.page == 'statics'}">
                    <jsp:include page="revenue.jsp"/>
                </c:when>
                <c:when test="${param.page == 'renter'}">
                    <jsp:include page="add_tenants.jsp?motel_room_id=${param.motel_room_id}"/>
                </c:when>
            </c:choose>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>