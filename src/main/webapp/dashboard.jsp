<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Dashboard</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        $(document).ready(function() {
            // Hàm AJAX để load nội dung từ các trang con
            function loadContent(url) {
                $.ajax({
                    url: url,
                    type: 'GET',
                    dataType: 'html',
                    success: function(data) {
                        $('#dashboard-content').html(data);
                    },
                    error: function(xhr, status, error) {
                        console.error('AJAX Error:', error);
                    }
                });
            }

            // Bắt sự kiện click vào các liên kết menu
            $('.nav-link').click(function(e) {
                e.preventDefault();
                var target = $(this).attr('href');
                loadContent(target);
            });

            // Mặc định load trang đầu tiên
            loadContent('motel-list.jsp');
        });
    </script>
</head>
<body>
<!-- Menu điều hướng -->
<div class="navigation">
    <ul>
        <li><a href="motel-list.jsp" class="nav-link">Quản lý Nhà trọ</a></li>
        <li><a href="motel-rooms-list.jsp" class="nav-link">Quản lý Phòng trọ</a></li>
        <li><a href="renters.jsp" class="nav-link">Quản lý Thành viên</a></li>
        <!-- Thêm các liên kết menu khác tương tự -->
    </ul>
</div>

<!-- Nội dung dashboard -->
<div id="dashboard-content">
    <!-- Nội dung sẽ được load bằng AJAX -->
</div>
</body>
</html>
