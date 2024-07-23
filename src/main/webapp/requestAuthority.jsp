<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Yêu Cầu Trở Thành Người Chủ</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            margin-top: 120px !important;
            background-color: #f8f9fa;
        }
        .container-1 {
            max-width: 600px;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        h2 {
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .btn-primary {
            width: 100%;
        }
    </style>
</head>
<body>
<jsp:include page="header.jsp" />
<div class="container container-1">
    <h2>Yêu Cầu Trở Thành Người Chủ</h2>
    <c:choose>
        <c:when test="${not empty requestAuthorities}">
            <c:forEach var="requestAuthority" items="${requestAuthorities}">
                <table class="table mt-3">
                    <thead>
                    <tr>
                        <th scope="col">Thông Tin</th>
                        <th scope="col">Chi Tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Ảnh CCCD</td>
                        <td><img src="<c:out value='${pageContext.request.contextPath}/${requestAuthority.imageIdCard}' />" alt="Căn cước công dân" style="max-width: 100px;"/></td>
                    </tr>
                    <tr>
                        <td>Ảnh Quyền Sở Hữu</td>
                        <td><img src="<c:out value='${pageContext.request.contextPath}/${requestAuthority.imageDoc}' />" alt="Giấy tờ chứng minh" style="max-width: 100px;"/></td>
                    </tr>
                    <tr>
                        <td>Mô Tả</td>
                        <td><c:out value="${requestAuthority.descriptions}" /></td>
                    </tr>
                    <tr>
                        <td>Trạng Thái</td>
                        <td><c:out value="${requestAuthority.requestAuthorityStatus}" /></td>
                    </tr>
                    </tbody>
                </table>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger" role="alert">
                        ${errorMessage}
                </div>
            </c:if>
            <form action="${pageContext.request.contextPath}/userRequestAuthorityServlet" method="post" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="imageidcard">CCCD:</label>
                    <input type="file" class="form-control-file" id="imageidcard" name="imageidcard" accept="image/*" required>
                </div>
                <div class="form-group">
                    <label for="imagedoc">Ảnh Quyền Sở Hữu:</label>
                    <input type="file" class="form-control-file" id="imagedoc" name="imagedoc" accept="image/*" required>
                </div>
                <div class="form-group">
                    <label for="descriptions">Mô Tả:</label>
                    <textarea class="form-control" id="descriptions" name="descriptions" rows="3" required></textarea>
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="agreement" name="agreement" required>
                    <label class="form-check-label" for="agreement">Mọi văn bản và ảnh cung cấp đều thật và minh bạch?</label>
                </div>
                <div class="g-recaptcha" data-sitekey="6LcjshIqAAAAAIn5SQVQnEPk9n3Vq95RtAGP_zcG"></div>
                <button type="submit" class="btn btn-primary">Gửi Yêu Cầu</button>
            </form>
            <% if (request.getAttribute("success") != null && (Boolean) request.getAttribute("success")) { %>
            <div class="alert alert-success mt-3" role="alert">
                Gửi Thành Công!
            </div>
            <% } %>
        </c:otherwise>
    </c:choose>
</div>
<jsp:include page="footer.jsp" />
<!-- Bootstrap JS and dependencies -->
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="https://www.google.com/recaptcha/api.js" async defer></script>
<script>
    $(document).ready(function(){
        $('.owl-carousel').owlCarousel();
    });
</script>
</body>
</html>
