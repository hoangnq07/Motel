<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Gửi và Xem Lịch Sử Feedback</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <link href="https://fonts.googleapis.com/css2?family=Open+Sans:wght@400;500&family=Lora:wght@600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .feedback-form {
            max-width: 600px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f8f9fa;
        }
        .feedback-form h3 {
            text-align: center;
            margin-bottom: 20px;
        }
        .btn-submit, .btn-view {
            width: 100%;
            margin-bottom: 10px;
        }
        table {
            width: 100%;
            margin-top: 20px;
        }
        .body{
            margin-top: 50px !important;
        }
        #listFeedbackReceivedContainer {
            display: none; /* Ban đầu ẩn phần tử này đi */
            margin-top: 20px;
        }
    </style>
</head>
<body class="body">

<!-- Header Start -->
<jsp:include page="header.jsp"></jsp:include>
<!-- Header End -->

<!-- Feedback Form Start -->
<div class="container feedback-form">
    <h3>Gửi Feedback</h3>
    <div id="notificationArea" style="display: none;"></div>
    <form action="sendFeedback" method="POST">
        <div class="mb-3">
            <label for="feedback" class="form-label">Nội dung Feedback:</label>
            <textarea id="feedback" name="feedback" class="form-control" rows="5" required></textarea>
        </div>
        <div class="mb-3">
            <label for="tag" class="form-label">Gửi đến:</label>
            <select id="tag" name="tag" class="form-select">
                <c:if test="${sessionScope.user.role != 'owner'}">
                    <option value="owner">Owner</option>
                </c:if>
                <option value="admin">Admin</option>
            </select>
        </div>
        <button type="submit" class="btn btn-primary btn-submit">Gửi Feedback</button>
    </form>
    <button id="showHistoryBtn" class="btn btn-info btn-view">Xem Lịch Sử Feedback</button>
    <c:if test="${sessionScope.user.role == 'owner'}">
        <button id="listFeedbackReceivedBtn" class="btn btn-secondary btn-view">List Feedback Received</button>
    </c:if>
    <table id="historyFeedbackTable" class="table table-bordered" style="display:none;">
        <thead>
        <tr>
            <th>Ngày Gửi</th>
            <th>Nội Dung</th>
            <th>Người Nhận</th>
        </tr>
        </thead>
        <tbody></tbody>
    </table>
    <div id="listFeedbackReceivedContainer"></div>
</div>
<!-- Feedback Form End -->

<!-- Footer Start -->
<jsp:include page="footer.jsp"></jsp:include>
<!-- Footer End -->

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function() {
        $('#notificationArea').hide();

        $('form').on('submit', function(e) {
            e.preventDefault();
            var formData = $(this).serialize();

            $.ajax({
                type: 'POST',
                url: 'sendFeedback',
                data: formData,
                success: function(response) {
                    $('#notificationArea').html('<div class="alert alert-success" role="alert">Feedback đã được gửi thành công!</div>');
                    $('#notificationArea').fadeIn();
                    $('#historyFeedbackTable').hide();
                },
                error: function() {
                    $('#notificationArea').html('<div class="alert alert-danger" role="alert">Lỗi khi gửi feedback. Vui lòng thử lại.</div>');
                    $('#notificationArea').fadeIn();
                }
            });
        });

        $('#showHistoryBtn').click(function() {
            toggleFeedbackTable($('#historyFeedbackTable'), 'showFeedbackHistory');
        });

        $('#listFeedbackReceivedBtn').click(function() {
            window.location.href = 'listFeedbackOwner.jsp'; // Thay đổi xử lý sự kiện nhấn nút để chuyển hướng
        });

        function toggleFeedbackTable(table, endpoint) {
            if (table.is(':visible')) {
                table.hide();
            } else {
                fetch(endpoint, {
                    method: 'GET'
                })
                    .then(response => response.json())
                    .then(data => {
                        const tbody = table.find('tbody');
                        tbody.empty();
                        if (data.length > 0) {
                            data.forEach(fb => {
                                const formattedDate = new Date(fb.createDate).toLocaleString();
                                $('<tr>')
                                    .append($('<td>').text(formattedDate))
                                    .append($('<td>').text(fb.feedbackText))
                                    .append($('<td>').text(fb.tag))
                                    .appendTo(tbody);
                            });
                            table.show();
                        } else {
                            $('<tr>').append($('<td>').attr('colspan', '3').text('Không có lịch sử feedback.')).appendTo(tbody);
                            table.show();
                        }
                    })
                    .catch(error => {
                        console.error('Error fetching history:', error);
                    });
            }
        }
    });
</script>
</body>
</html>
