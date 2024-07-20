<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Request Authority</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            margin-top: 50px;
            background-color: #f8f9fa;
        }
        .container {
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
<div class="container">
    <h2>Request Authority</h2>
    <c:choose>
        <c:when test="${not empty requestAuthorities}">
            <c:forEach var="requestAuthority" items="${requestAuthorities}">
                <table class="table mt-3">
                    <thead>
                    <tr>
                        <th scope="col">Thông tin</th>
                        <th scope="col">Chi tiết</th>
                    </tr>
                    </thead>
                    <tbody>
                    <tr>
                        <td>Ảnh Căn cước công dân</td>
                        <td><img src="<c:out value='${pageContext.request.contextPath}/${requestAuthority.imageIdCard}' />" alt="Căn cước công dân" style="max-width: 100px;"/></td>
                    </tr>
                    <tr>
                        <td>Ảnh Giấy tờ chứng minh sở hữu nhà trọ </td>
                        <td><img src="<c:out value='${pageContext.request.contextPath}/${requestAuthority.imageDoc}' />" alt="Giấy tờ chứng minh" style="max-width: 100px;"/></td>
                    </tr>
                    <tr>
                        <td>Description</td>
                        <td><c:out value="${requestAuthority.descriptions}" /></td>
                    </tr>
                    <tr>
                        <td>Trạng thái</td>
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
                    <label for="imageidcard">Căn cước công dân:</label>
                    <input type="file" class="form-control-file" id="imageidcard" name="imageidcard" accept="image/*" required>
                </div>
                <div class="form-group">
                    <label for="imagedoc">Giấy tờ chứng minh sở hữu nhà trọ:</label>
                    <input type="file" class="form-control-file" id="imagedoc" name="imagedoc" accept="image/*" required>
                </div>
                <div class="form-group">
                    <label for="descriptions">Descriptions:</label>
                    <textarea class="form-control" id="descriptions" name="descriptions" rows="3" required></textarea>
                </div>
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="agreement" name="agreement" required>
                    <label class="form-check-label" for="agreement">Đồng ý rằng giấy tờ của bạn đều minh bạch</label>
                </div>
                <div class="g-recaptcha" data-sitekey="6LcjshIqAAAAAIn5SQVQnEPk9n3Vq95RtAGP_zcG"></div>
                <button type="submit" class="btn btn-primary">Submit Request</button>
            </form>
            <% if (request.getAttribute("success") != null && (Boolean) request.getAttribute("success")) { %>
            <div class="alert alert-success mt-3" role="alert">
                Form Submit Successful!
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
