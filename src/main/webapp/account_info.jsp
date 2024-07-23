<%-- 
    Document   : update_profile
    Created on : May 18, 2024, 10:06:26 PM
    Author     : BAO
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cập nhật Profile cá nhân</title>
    <script>
        function validateForm() {
            const fullName = document.getElementById('fullName').value;
            const phone = document.getElementById('phone').value;
            const dob = document.getElementById('dob').value;
            const citizen = document.getElementById('citizen').value;
            const avatar = document.getElementById('avatar').value;
            const nameRegex = /^[^0-9]*$/;
            const phoneRegex = /^0\d{9,10}$/;
            const citizenRegex = /^0\d{11}$/;
            const validImageExtensions = ['jpg', 'jpeg', 'png', 'gif'];

            // Họ tên không có số
            if (!nameRegex.test(fullName)) {
                alert("Full Name must not contain numbers.");
                return false;
            }

            // Số điện thoại phải từ 10 đến 11 số và bắt đầu bằng số 0
            if (!phoneRegex.test(phone)) {
                alert("Phone number must be 10 to 11 digits long and start with 0.");
                return false;
            }

            // Ngày sinh không vượt qua ngày hiện tại
            const today = new Date().toISOString().split('T')[0];
            if (dob > today) {
                alert("Date of Birth cannot be in the future.");
                return false;
            }

            // Số căn cước phải 12 số và bắt đầu bằng số 0
            if (!citizenRegex.test(citizen)) {
                alert("Citizen ID must be 12 digits long and start with 0.");
                return false;
            }

            // Tệp ảnh phải đúng định dạng ảnh
            if (avatar) {
                const extension = avatar.split('.').pop().toLowerCase();
                if (!validImageExtensions.includes(extension)) {
                    alert("Avatar must be an image file (jpg, jpeg, png, gif).");
                    return false;
                }
            }

            return true;
        }
    </script>
</head>
<body>
<jsp:include page="header.jsp" ></jsp:include>
<div class="container mt-5 " style="margin-top: 120px !important;">
    <h1>Update Profile</h1>

    <form action="UpdateProfileServlet" method="post" enctype="multipart/form-data" onsubmit="return validateForm()">
        <div class="mb-3">
            <label for="fullName" class="form-label">Họ tên</label>
            <input type="text" class="form-control" id="fullName" name="fullName" value="${user.fullname}" required>
        </div>
        <div class="mb-3">
            <label for="email" class="form-label">Email</label>
            <input type="email" class="form-control" id="email" name="email" value="${user.email}" readonly>
        </div>
        <div class="mb-3">
            <%--@declare id="gender"--%><label for="gender">Giới tính</label>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="genderMale" value="1" ${user.gender ? "checked" : ""}>
                <label class="form-check-label" for="genderMale">Nam</label>
            </div>
            <div class="form-check form-check-inline">
                <input class="form-check-input" type="radio" name="gender" id="genderFemale" value="0" ${!user.gender ? "checked" : ""}>
                <label class="form-check-label" for="genderFemale">Nữ</label>
            </div>
        </div>
        <div class="mb-3">
            <label for="phone" class="form-label">Số điện thoại</label>
            <input type="text" class="form-control" id="phone" name="phone" value="${user.phone}" required>
        </div>
        <div class="mb-3">
            <label for="dob" class="form-label">Ngày sinh</label>
            <input type="date" class="form-control" id="dob" name="dob" value="${user.dob}" required>
        </div>
        <div class="mb-3">
            <label for="citizen" class="form-label">Số CCCD</label>
            <input type="text" class="form-control" id="citizen" name="citizen" value="${user.citizenId}" required>
        </div>
        <div class="mb-3">
            <label for="avatar" class="form-label">Ảnh Cá Nhân</label>
            <input type="file" class="form-control" id="avatar" name="avatar">
        </div>
        <button type="submit" class="btn btn-primary">Lưu</button>
    </form>
</div>
<jsp:include page="footer.jsp" ></jsp:include>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
</body>
</html>
