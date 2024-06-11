<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gửi hóa đơn</title>
</head>
<body>
<h2>Gửi hóa đơn cho người thuê</h2>
<form action="SendBillServlet" method="post">
    <label for="email">Nhập email của người thuê:</label>
    <input type="email" id="email" name="email" required>
    <br><br>
    <label for="roomBill">Tiền phòng:</label>
    <input type="number" step="0.01" id="roomBill" name="roomBill" required>
    <br><br>
    <label for="electricityBill">Tiền điện:</label>
    <input type="number" step="0.01" id="electricityBill" name="electricityBill" required>
    <br><br>
    <label for="waterBill">Tiền nước:</label>
    <input type="number" step="0.01" id="waterBill" name="waterBill" required>
    <br><br>
    <label for="wifiBill">Tiền wifi:</label>
    <input type="number" step="0.01" id="wifiBill" name="wifiBill" required>
    <br><br>
    <input type="submit" value="Gửi hóa đơn">
</form>

<script type="text/javascript">
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');
        if (status === 'success') {
            alert('Gửi hóa đơn thành công.');
            window.location.href='owner-body.jsp';
        } else if (status === 'not_found') {
            alert('Email không tồn tại trong hệ thống.');
        } else if (status === 'sql_error') {
            alert('Đã xảy ra lỗi khi kết nối cơ sở dữ liệu.');
        } else if (status === 'empty_email') {
            alert('Email không được để trống.');
        } else if (status === 'not_logged_in') {
            alert('Bạn chưa đăng nhập.');
        }
    };
</script>
</body>
</html>
