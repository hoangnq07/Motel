<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Motel Management</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 90%;
            margin: 20px auto;
            background-color: #fff;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            border-radius: 5px;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #f2f2f2;
        }
        .actions a {
            margin-right: 10px;
        }
        .create-btn {
            margin-bottom: 20px;
        }
        .modal-body {
            max-height: calc(100vh - 200px);
            overflow-y: auto;
        }
    </style>
</head>
<body>
<div class="container">
    <h1>Motel List</h1>
    <button type="button" class="btn btn-primary create-btn" data-toggle="modal" data-target="#addMotelModal">
        Add New Motel
    </button>
    <table class="table table-striped">
        <thead>
        <tr>
            <th>Name</th>
            <th>Description</th>
            <th>Address</th>
            <th>Image</th>
            <th>Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody id="motelList">
        <c:forEach var="motel" items="${motels}">
            <tr>
                <td>${motel.name}</td>
                <td>${motel.descriptions}</td>
                <td>${motel.detailAddress}, ${motel.ward}, ${motel.district}, ${motel.province}</td>
                <td>
                    <c:choose>
                        <c:when test="${motel.image == null}">
                            <img src="${pageContext.request.contextPath}/images/default-room.jpg" width="100" height="100" alt="Default Room">
                        </c:when>
                        <c:otherwise>
                            <img src="${pageContext.request.contextPath}/images/${motel.image}" width="100" height="100" alt="Motel Image">
                        </c:otherwise>
                    </c:choose>
                </td>
                <td>
                    <c:choose>
                        <c:when test="${motel.status}">Available</c:when>
                        <c:otherwise>Unavailable</c:otherwise>
                    </c:choose>
                </td>
                <td class="actions">
                    <a href="${pageContext.request.contextPath}/motel/update?id=${motel.motelId}" class="btn btn-sm btn-warning">Edit</a>
                    <a href="${pageContext.request.contextPath}/owner?id=${motel.motelId}&page=room-list" class="btn btn-sm btn-info">Manage</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <div id="pagination" class="mt-3">
        <!-- Các nút phân trang sẽ được thêm vào đây -->
    </div>
</div>

<!-- Add Motel Modal -->
<div class="modal fade" id="addMotelModal" tabindex="-1" role="dialog" aria-labelledby="addMotelModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="addMotelModalLabel">Add New Motel</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form id="addMotelForm" action="${pageContext.request.contextPath}/motel/create" method="post" enctype="multipart/form-data">
                    <div class="form-group">
                        <label for="name">Name:</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    <div class="form-group">
                        <label for="descriptions">Descriptions:</label>
                        <textarea class="form-control" id="descriptions" name="descriptions" rows="3"></textarea>
                    </div>
                    <div class="form-group">
                        <label for="province">Province:</label>
                        <select class="form-control"  id="province" name="province" onchange="updateHiddenInputs()">
                            <option value="-1">Chọn tỉnh thành</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="district">District:</label>
                        <select class="form-control"  id="district" name="district" onchange="updateHiddenInputs()">
                            <option value="-1">Chọn quận/huyện</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="town">Town:</label>
                        <select class="form-control"  id="town" name="town" onchange="updateHiddenInputs()">
                            <option value="-1">Chọn phường/xã</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="detailAddress">Detail Address:</label>
                        <input type="text" class="form-control" id="detailAddress" name="detailAddress" required>
                    </div>
                    <div class="form-group">
                        <label>Status:</label>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="statusTrue" value="true" checked>
                            <label class="form-check-label" for="statusTrue">Available</label>
                        </div>
                        <div class="form-check">
                            <input class="form-check-input" type="radio" name="status" id="statusFalse" value="false">
                            <label class="form-check-label" for="statusFalse">Unavailable</label>
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="image">Image:</label>
                        <input type="file" class="form-control-file" id="image" name="image" onchange="previewImage(event)">
                    </div>
                    <div class="form-group">
                        <label>Image Preview:</label>
                        <div class="image-preview-container">
                            <img id="preview" class="img-fluid" src="#" alt="" style="display: none; max-height: 200px;">
                        </div>
                    </div>
                    <input type="hidden" id="provinceText" name="provinceText">
                    <input type="hidden" id="districtText" name="districtText">
                    <input type="hidden" id="townText" name="townText">
                    <input type="hidden" name="accountId" value="${user.accountId}">
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Add Motel</button>
                    </div>
                </form>
            </div>

        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/province/data.json"></script>
<script src="${pageContext.request.contextPath}/assets/province/api1.js"></script>
<script>
    function previewImage(event) {
        var input = event.target;
        var reader = new FileReader();
        reader.onload = function() {
            var img = document.getElementById('preview');
            img.src = reader.result;
            img.style.display = 'block';
        };
        reader.readAsDataURL(input.files[0]);
    }

    function updateHiddenInputs() {
        var provinceSelect = document.getElementById('province');
        var districtSelect = document.getElementById('district');
        var townSelect = document.getElementById('town');

        var selectedProvinceText = provinceSelect.selectedIndex > 0 ? provinceSelect.options[provinceSelect.selectedIndex].text : '';
        var selectedDistrictText = districtSelect.selectedIndex > 0 ? districtSelect.options[districtSelect.selectedIndex].text : '';
        var selectedTownText = townSelect.selectedIndex > 0 ? townSelect.options[townSelect.selectedIndex].text : '';

        document.getElementById('provinceText').value = selectedProvinceText;
        document.getElementById('districtText').value = selectedDistrictText;
        document.getElementById('townText').value = selectedTownText;
    }
</script>
</body>
</html>