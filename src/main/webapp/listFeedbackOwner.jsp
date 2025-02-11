<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="utf-8">
    <title>Danh Sách Đánh Giá</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <style>
        .feedback-table {
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ddd;
            border-radius: 5px;
            background-color: #f8f9fa;
        }
        .feedback-table h3 {
            text-align: center;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            margin-top: 20px;
            border-collapse: collapse;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .body{
            margin-top: 50px !important;
        }
    </style>
</head>
<body>
<!-- Feedback List Start -->
<div class="container feedback-table">
    <h3>Đánh Giá Đã Nhận</h3>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>Ngày Nhận</th>
            <th>Nội Dung</th>
            <th>Tên Người Gửi</th>
            <th>Nhà Trọ</th>
            <th>Phòng</th>
        </tr>
        </thead>
        <tbody id="feedbackList">
        <!-- Dữ liệu sẽ được load vào đây thông qua AJAX -->
        </tbody>
    </table>
</div>

<!-- JavaScript Libraries -->
<script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function() {
        fetchFeedbackList();

        function fetchFeedbackList() {
            $.ajax({
                url: 'getOwnerFeedbacks', // Đường dẫn đến servlet để lấy danh sách feedback
                type: 'GET',
                dataType: 'json',
                success: function(data) {
                    const tbody = $('#feedbackList');
                    tbody.empty();
                    if (data.length > 0) {
                        data.forEach(fb => {
                            const formattedDate = new Date(fb.createDate).toLocaleString();
                            $('<tr>')
                                .append($('<td>').text(formattedDate))
                                .append($('<td>').text(fb.feedbackText))
                                .append($('<td>').text(fb.senderName))
                                .append($('<td>').text(fb.motelName)) // Hiển thị tên nhà trọ
                                .append($('<td>').text(fb.roomName)) // Hiển thị tên phòng
                                .appendTo(tbody);
                        });
                    } else {
                        $('<tr>').append($('<td>').attr('colspan', '5').text('Không có feedback nào.')).appendTo(tbody);
                    }
                },
                error: function(error) {
                    console.error('Error fetching feedback list:', error);
                }
            });
        }
    });
</script>
</body>
</html>
