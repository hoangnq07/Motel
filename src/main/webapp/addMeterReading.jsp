<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thêm Chỉ Số Điện & Nước</title>
</head>
<body>
<h2>Thêm Chỉ Số Điện & Nước</h2>
<form action="AddMeterReadingServlet" method="post">
    <label for="room">ID Phòng:</label>
    <input type="text" id="room" name="room" required>
    <br><br>
    <label for="electricityIndex">Chỉ số điện:</label>
    <input type="number" id="electricityIndex" name="electricityIndex" required>
    <br><br>
    <label for="waterIndex">Chỉ số nước:</label>
    <input type="number" id="waterIndex" name="waterIndex" required>
    <br><br>
    <input type="submit" value="Thêm Chỉ Số">
</form>

<script type="text/javascript">
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        if (status === 'success') {
            alert('Thêm chỉ số thành công.');
            window.location.href = 'owner-body.jsp';
        } else if (status === 'error') {
            alert('Lỗi khi thêm chỉ số.');
        }
    };
</script>
</body>
</html>
