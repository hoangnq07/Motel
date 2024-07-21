<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Pending Requests</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <style>
        .action-buttons {
            display: flex;
            justify-content: space-between;
        }
        .action-buttons button {
            flex: 1;
            margin-right: 5px;
        }
        .action-buttons button:last-child {
            margin-right: 0;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Những Yêu Cầu Đang Chờ</h2>
    <c:if test="${not empty pendingRequests}">
        <table class="table table-bordered">
            <thead>
            <tr>
                <th>ID của Yêu cầu</th>
                <th>Ngày Tạo</th>
                <th>Thông Tin Mô Tả</th>
                <th>ID của Tài Khoản</th>
                <th>Trạng Thái</th>
                <th>Ảnh CCCD</th>
                <th>Ảnh Văn Bản</th>
                <th>Hành Động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="request" items="${pendingRequests}">
                <tr id="requestRow_${request.requestId}">
                    <td><c:out value="${request.requestId}"/></td>
                    <td><c:out value="${request.createDate}"/></td>
                    <td><c:out value="${request.descriptions}"/></td>
                    <td><c:out value="${request.accountId}"/></td>
                    <td id="status_${request.requestId}"><c:out value="${request.requestAuthorityStatus}"/></td>
                    <td><img src="<c:url value='/${request.imageIdCard}' />" alt="ID Card" style="max-width: 100px;"></td>
                    <td><img src="<c:url value='/${request.imageDoc}' />" alt="Document" style="max-width: 100px;"></td>
                    <td id="action_${request.requestId}">
                        <div class="action-buttons">
                            <button type="button" onclick="handleRequestAction(${request.requestId}, ${request.accountId}, 'accept')" class="btn btn-success btn-sm">Chấp nhận</button>
                            <button type="button" onclick="handleRequestAction(${request.requestId}, ${request.accountId}, 'reject')" class="btn btn-danger btn-sm">Từ chối</button>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </c:if>
    <c:if test="${empty pendingRequests}">
        <p>Hiện không có Yêu Cầu nào</p>
    </c:if>
</div>

<script>
    function handleRequestAction(requestId, accountId, action) {
        $.ajax({
            type: "POST",
            url: "${pageContext.request.contextPath}/handleRequestActionServlet",
            data: {
                requestId: requestId,
                accountId: accountId,
                action: action
            },
            success: function(response) {
                if (response.success) {
                    location.reload(); // Tải lại trang sau khi xử lý thành công
                } else {
                    alert(response.message);
                }
            },
            error: function() {
                alert("There was an error processing the request.");
            }
        });
    }
</script>

</body>
</html>

