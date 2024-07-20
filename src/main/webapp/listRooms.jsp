<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<%@ page import="model.CategoryRoom" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<!DOCTYPE html>
<html>
<head>
    <title>Danh Sách Phòng</title>
    <!-- Include Bootstrap CSS -->
    <link href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .favorite {
            cursor: pointer;
            color: #ccc; /* Default color */
            font-size: 24px;
            position: absolute;
            bottom: 10px;
            right: 10px;
        }
        .favorite.active {
            color: red; /* Active color */
        }
        .body {
            margin-top: 80px;
        }
        .room-card {
            border: none;
            margin-bottom: 20px;
            position: relative;
        }
        .room-card img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            border-radius: 5px;
        }
        .room-card .room-details {
            padding: 10px;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-top: none;
            border-radius: 0 0 5px 5px;
        }
        .room-card .room-details h5 {
            font-weight: bold;
            font-size: 18px;
            margin-bottom: 5px;
        }
        .room-card .room-details p {
            margin-bottom: 5px;
        }
        .room-card .room-details .price {
            font-weight: bold;
            color: #dc3545;
        }
    </style>
</head>
<body class="body">
<jsp:include page="header.jsp"></jsp:include>

<div class="container mt-5">
    <form id="searchForm" method="GET" action="${pageContext.request.contextPath}/motel-rooms">
        <input type="hidden" name="action" value="search">
        <div class="row mb-3">
            <div class="col-md-10">
                <input type="text" id="search" name="search" class="form-control" placeholder="Tìm theo tên..." value="${param.search}">
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-primary w-100">Tìm</button>
            </div>
        </div>

        <div class="row">
            <div class="form-group col-md-2">
                <label for="province">Tỉnh:</label>
                <select id="province" name="province" class="form-control" onchange="updateHiddenInputs()">
                    <option value="-1">Chọn tỉnh thành</option>
                    <!-- Populate with provinces -->
                </select>
            </div>
            <div class="form-group col-md-2">
                <label for="district">Quận/Huyện:</label>
                <select id="district" name="district" class="form-control" onchange="updateHiddenInputs()">
                    <option value="-1">Chọn quận/huyện</option>
                    <!-- Populate with districts -->
                </select>
            </div>
            <div class="form-group col-md-2">
                <label for="town">Phường/Xã:</label>
                <select id="town" name="town" class="form-control" onchange="updateHiddenInputs()">
                    <option value="-1">Chọn phường/xã</option>
                    <!-- Populate with towns -->
                </select>
            </div>
            <div class="form-group col-md-2">
                <label for="category">Phân Loại:</label>
                <select id="category" name="category" class="form-control">
                    <option value="-1">Chọn loại phòng</option>
                </select>
            </div>

        </div>

        <div class="row">
            <div class="form-group col-md-2">
                <label for="sortPrice">Sắp xếp theo Giá:</label>
                <select id="sortPrice" name="sortPrice" class="form-control">
                    <option value="-1">Chọn</option>
                    <option value="asc" ${param.sortPrice == 'asc' ? 'selected' : ''}>Thấp đến Cao</option>
                    <option value="desc" ${param.sortPrice == 'desc' ? 'selected' : ''}>Cao đến Thấp</option>
                </select>
            </div>
            <div class="form-group col-md-2">
                <label for="sortArea">Sắp xếp theo khu vực:</label>
                <select id="sortArea" name="sortArea" class="form-control">
                    <option value="-1">Chọn</option>
                    <option value="asc" ${param.sortArea == 'asc' ? 'selected' : ''}>Nhỏ đến Lớn</option>
                    <option value="desc" ${param.sortArea == 'desc' ? 'selected' : ''}>Lớn đến Nhỏ</option>
                </select>
            </div>
            <div class="form-group col-md-2">
                <label for="sortDate">Sắp xếp theo thời gian:</label>
                <select id="sortDate" name="sortDate" class="form-control">
                    <option value="-1">Select</option>
                    <option value="newest" ${param.sortDate == 'newest' ? 'selected' : ''}>Mới nhất</option>
                    <option value="oldest" ${param.sortDate == 'oldest' ? 'selected' : ''}>Cũ nhất</option>
                </select>
            </div>
        </div>

        <input type="hidden" id="provinceText" name="provinceText" value="">
        <input type="hidden" id="districtText" name="districtText" value="">
        <input type="hidden" id="townText" name="townText" value="">

        <input type="hidden" id="minPrice" name="minPrice" value="${param.minPrice}">
        <input type="hidden" id="maxPrice" name="maxPrice" value="${param.maxPrice}">
        <input type="hidden" id="minArea" name="minArea" value="${param.minArea}">
        <input type="hidden" id="maxArea" name="maxArea" value="${param.maxArea}">
        <div class="form-group col-md-2 align-self-end">
            <button type="submit" class="btn btn-primary w-100">Filter</button>
        </div>
    </form>
    <!-- Room Listings -->
    <div class="row mt-4" id="roomList">
        <c:forEach var="room" items="${rooms}">
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="room-card">
                    <c:if test="${not empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/${room.image.get(0)}" alt="Room Image">
                    </c:if>
                    <c:if test="${empty room.image}">
                        <img src="${pageContext.request.contextPath}/images/default-room.jpg" alt="Default Room Image">
                    </c:if>
                    <div class="room-details">
                        <h5>${room.description}</h5>
                        <p>${room.length * room.width} m²</p>
                        <p class="price">
                            <fmt:formatNumber value="${room.roomPrice}" type="number" groupingUsed="true"/> VND/tháng
                        </p>
                        <p>${room.detailAddress}, ${room.ward}, ${room.district}, ${room.province}</p>
                        <i class="favorite ${room.favorite ? 'fas text-danger' : 'far'} fa-heart" onclick="toggleFavorite(this, ${room.motelRoomId})"></i>
                        <a href="room-details?roomId=${room.motelRoomId}" class="btn btn-primary">Xem chi tiết</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>


    <!-- Pagination -->
    <nav aria-label="Page navigation example">
        <ul class="pagination justify-content-center">
            <c:forEach var="i" begin="1" end="${totalPages}">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <c:choose>
                        <c:when test="${param.action == 'search'}">
                            <a class="page-link" href="${pageContext.request.contextPath}/motel-rooms?action=search&search=${param.search}&province=${param.province}&district=${param.district}&town=${param.town}&category=${param.category}&minPrice=${param.minPrice}&maxPrice=${param.maxPrice}&minArea=${param.minArea}&maxArea=${param.maxArea}&sortPrice=${param.sortPrice}&sortArea=${param.sortArea}&sortDate=${param.sortDate}&page=${i}">${i}</a>
                        </c:when>
                        <c:otherwise>
                            <a class="page-link" href="${pageContext.request.contextPath}/motel-rooms?page=${i}">${i}</a>
                        </c:otherwise>
                    </c:choose>
                </li>
            </c:forEach>
        </ul>
    </nav>
</div>
<jsp:include page="footer.jsp" />

<script>
    function submitSearchForm() {
        document.getElementById('searchForm').submit();
    }

    function toggleFavorite(element, roomId) {
        const isFavorite = element.classList.contains('fas'); // Check if already favorite
        const action = isFavorite ? 'remove' : 'add'; // Determine action based on current state

        fetch("favorite?action=" + action + "&roomId=" + roomId, { method: 'POST' })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    element.classList.toggle('far'); // Toggle the empty heart
                    element.classList.toggle('fas'); // Toggle the filled heart
                } else {
                    alert('An error occurred while processing your request');
                }
            })
            .catch(error => {
                console.error('Error:', error);
            });
    }

    $(document).ready(function() {
        $('#searchForm').submit(function(e) {
            e.preventDefault();
            submitSearchForm();
        });

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

        // Populate province, district, and town dropdowns (fetch data from backend)
        $.getJSON('${pageContext.request.contextPath}/assets/province/data.json', function(data) {
            let provinceOptions = '<option value="-1">Chọn tỉnh thành</option>';
            $.each(data.provinces, function(key, value) {
                provinceOptions += '<option value="' + value.name + '">' + value.name + '</option>';
            });
            $('#province').html(provinceOptions);
        });

        $('#province').change(function() {
            const provinceName = $(this).val();
            if (provinceName != "-1") {
                $.getJSON('${pageContext.request.contextPath}/assets/districts/' + provinceName + '.json', function(data) {
                    let districtOptions = '<option value="-1">Chọn quận/huyện</option>';
                    $.each(data.districts, function(key, value) {
                        districtOptions += '<option value="' + value.name + '">' + value.name + '</option>';
                    });
                    $('#district').html(districtOptions);
                    $('#town').html('<option value="-1">Chọn phường/xã</option>');
                });
            } else {
                $('#district').html('<option value="-1">Chọn quận/huyện</option>');
                $('#town').html('<option value="-1">Chọn phường/xã</option>');
            }
        });

        $('#district').change(function() {
            const districtName = $(this).val();
            if (districtName != "-1") {
                $.getJSON('${pageContext.request.contextPath}/assets/towns/' + districtName + '.json', function(data) {
                    let townOptions = '<option value="-1">Chọn phường/xã</option>';
                    $.each(data.towns, function(key, value) {
                        townOptions += '<option value="' + value.name + '">' + value.name + '</option>';
                    });
                    $('#town').html(townOptions);
                });
            } else {
                $('#town').html('<option value="-1">Chọn phường/xã</option>');
            }
        });

        // Populate inputs with selected values if any
        if('${param.province}' != '') {
            $('#province').val('${param.province}');
        }
        if('${param.district}' != '') {
            $('#district').val('${param.district}');
        }
        if('${param.town}' != '') {
            $('#town').val('${param.town}');
        }
        if('${param.category}' != '') {
            $('#category').val('${param.category}');
        }

        updateHiddenInputs();
    });

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
    $(document).ready(function() {
        // Fetch categories on page load
        fetchCategories();

        // Fetch and populate categories
        function fetchCategories() {
            $.ajax({
                url: '${pageContext.request.contextPath}/categories',
                method: 'GET',
                dataType: 'json',
                success: function(data) {
                    var categoryDropdown = $('#category');
                    categoryDropdown.empty(); // Clear existing options
                    categoryDropdown.append('<option value="-1">Chọn loại phòng</option>');
                    $.each(data, function(index, category) {
                        var selected = category.categoryRoomId == '${param.category}' ? 'selected="selected"' : '';
                        categoryDropdown.append('<option value="' + category.categoryRoomId + '" ' + selected + '>' + category.descriptions + '</option>');
                    });
                },
                error: function(error) {
                    console.error('Error fetching categories:', error);
                }
            });
        }

        // Other existing scripts
    });
</script>

<!-- jQuery first, then Popper.js, then Bootstrap JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"
        integrity="sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDzwrnQq4xF86dIHNDz0W1"
        crossorigin="anonymous"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"
        integrity="sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM"
        crossorigin="anonymous"></script>
<script src="${pageContext.request.contextPath}/assets/province/data.json"></script>
<script src="${pageContext.request.contextPath}/assets/province/api1.js"></script>
</body>
</html>
