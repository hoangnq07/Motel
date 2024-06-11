<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
          integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
          integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ" crossorigin="anonymous">
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" rel="stylesheet">
    <title>Owner Dashboard</title>
</head>
<body>
<!-- mymotel -->
<jsp:include page="owner-header.jsp"></jsp:include>
<div class="container mt-4">
    <div class="row">
        <div class="col-2">
            <ul class="nav flex-column">
                <li class="nav-item">
                    <a class="nav-link active" href="#" data-target="customer-management">Quản lý Thành viên</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-target="notifications">Thông báo</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-target="sendBill">Hóa Đơn</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" data-target="addMeterReading">Thêm Chỉ Số Điện & Nước</a>
                </li>
            </ul>
        </div>
        <div class="col-10">
            <div id="customer-management" class="content">
                <jsp:include page="renters.jsp"></jsp:include>
            </div>
            <div id="notifications" class="content d-none">
                <jsp:include page="notify.jsp"></jsp:include>
            </div>
            <div id="sendBill" class="content d-none">
                <jsp:include page="sendBill.jsp"></jsp:include>
            </div>
            <div id="addMeterReading" class="content d-none">
                <jsp:include page="addMeterReading.jsp"></jsp:include>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yfoRSJoZ+n" crossorigin="anonymous"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
<script>
    $(document).ready(function(){
        $('.nav-link').click(function(e){
            e.preventDefault();
            $('.nav-link').removeClass('active');
            $(this).addClass('active');

            const target = $(this).data('target');
            $('.content').addClass('d-none');
            $('#' + target).removeClass('d-none');
        });
    });
</script>
</body>
</html>
