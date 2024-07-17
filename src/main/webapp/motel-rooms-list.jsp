<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html>
<head>
    <title>Motel Room List</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
        }

        th, td {
            border: 1px solid black;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f2f2f2;
        }

        .hidden {
            display: none;
        }

        .form-container {
            margin-top: 20px;
        }

        .image-preview {
            position: relative;
            display: inline-block;
        }

        .image-preview img {
            width: 100px;
            height: 100px;
            margin-right: 10px;
        }

        .remove-image {
            position: absolute;
            top: 0;
            right: 0;
            background: red;
            color: white;
            border: none;
            border-radius: 50%;
            cursor: pointer;
        }
        #pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            margin-top: 20px;
            font-family: Arial, sans-serif;
        }
    </style>
    <script>
        var contextPath = '${pageContext.request.contextPath}';

        function showForm(action, roomId, motelId){
            $('#roomModal').modal('show');
            document.getElementById('form-action').value = action;
            loadCategories();
            if (action === 'edit' && roomId) {
                document.getElementById('roomId').value = roomId;
                fetchRoomDetails(roomId);
            } else {
                document.getElementById('roomForm').reset();
                document.getElementById('image-previews').innerHTML = '';
            }
        }

        function hideForm() {
            $('#roomModal').modal('hide');
            document.getElementById('roomForm').reset();
            document.getElementById('image-previews').innerHTML = '';
        }

        function fetchRoomDetails(roomId) {
            if (!roomId) {
                alert('Room ID is required');
                return;
            }

            var url = contextPath + "/motel-rooms?action=getRoomDetails&id=" + roomId;

            fetch(url)
                .then(function(response) {
                    if (!response.ok) {
                        return response.json().then(function(errorData) {
                            throw new Error(errorData.error || 'Unknown error occurred');
                        });
                    }
                    return response.json();
                })
                .then(function(room) {
                    document.getElementById('name').value = room.name;
                    document.getElementById('description').value = room.description;
                    document.getElementById('length').value = room.length;
                    document.getElementById('width').value = room.width;
                    document.getElementById('roomPrice').value = room.roomPrice;
                    document.getElementById('electricityPrice').value = room.electricityPrice;
                    document.getElementById('waterPrice').value = room.waterPrice;
                    document.getElementById('wifiPrice').value = room.wifiPrice;
                    document.getElementById('category').value = room.categoryRoomId;
                    if (room.roomStatus) {
                        document.getElementById('statusTrue').checked = true;
                    } else {
                        document.getElementById('statusFalse').checked = true;
                    }
                    // displayUploadedImages(room.images);
                })
                .catch(function(error) {
                    console.error('Error:', error);
                });
        }

        function loadCategories() {
            var url = contextPath + "/categories";

            fetch(url)
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('Failed to load categories');
                    }
                    return response.json();
                })
                .then(function(categories) {
                    var categorySelect = document.getElementById('category');
                    categorySelect.innerHTML = '';
                    categories.forEach(function(category) {
                        var option = document.createElement('option');
                        option.value = category.categoryRoomId;
                        option.textContent = category.descriptions;
                        categorySelect.appendChild(option);
                    });
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('Failed to load categories: ' + error.message);
                });
        }

        let selectedFiles = [];

        function handleImageUpload(event) {
            var files = event.target.files;
            var previewsContainer = document.getElementById('image-previews');

            for (var i = 0; i < files.length; i++) {
                var file = files[i];
                selectedFiles.push(file);
                var reader = new FileReader();

                reader.onload = (function(file, index) {
                    return function(e) {
                        var preview = document.createElement('div');
                        preview.classList.add('image-preview');
                        preview.innerHTML = '<img src="' + e.target.result + '"><button class="remove-image" onclick="removeImage(this, ' + index + ')">X</button>';
                        previewsContainer.appendChild(preview);
                    }
                })(file, selectedFiles.length - 1);

                reader.readAsDataURL(file);
            }

            updateFileCountDisplay(event.target);
        }

        function removeImage(button, index) {
            button.parentElement.remove();
            selectedFiles.splice(index, 1);
            updateFileInput();
        }

        function updateFileInput() {
            var dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => {
                dataTransfer.items.add(file);
            });
            var fileInput = document.getElementById('images');
            fileInput.files = dataTransfer.files;

            // Cập nhật text hiển thị số lượng file
            updateFileCountDisplay(fileInput);
        }

        function updateFileCountDisplay(input) {
            var fileCount = input.files.length;
            var fileCountDisplay = document.getElementById('file-count-display');
            if (fileCountDisplay) {
                fileCountDisplay.textContent = fileCount + (fileCount === 1 ? ' tệp' : ' tệp');
            }
        }

        function displayUploadedImages(images) {
            var previewsContainer = document.getElementById('image-previews');
            previewsContainer.innerHTML = '';
            selectedFiles = [];

            images.forEach(function(image, index) {
                var preview = document.createElement('div');
                preview.classList.add('image-preview');
                preview.innerHTML = '<img src="' + contextPath + '/uploads/' + image + '"><button class="remove-image" onclick="removeUploadedImage(this, \'' + image + '\', ' + index + ')">X</button>';
                previewsContainer.appendChild(preview);
            });
        }

        function removeUploadedImage(button, imageName, index) {
            button.parentElement.remove();
            // Thêm logic để xóa hình ảnh trên server nếu cần
            // Ví dụ: gửi request đến server để xóa file
        }

        function requestPost(roomId) {
            var url = contextPath + "/motel-rooms?action=requestPost&roomId=" + roomId;
            fetch(url)
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    console.log('Response Data:', data); // Log response data for debugging
                    if (data.success) {
                        document.querySelector('tr[data-room-id="' + roomId + '"] .postRequestStatus').textContent = 'pending';
                        alert('Request for posting was successful.');
                    } else {
                        alert('Failed to request for posting.');
                    }
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('An error occurred while requesting for posting.');
                });
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Motel Room List</h2>

    <a href="javascript:void(0);" onclick="showForm('create');" class="btn btn-primary mb-2">Add New Room</a>
    <table class="table">
        <thead>
        <tr>
            <th>Name</th>
            <th>Descriptions</th>
            <th>Length</th>
            <th>Width</th>
            <th>Room Price</th>
            <th>Electricity Price</th>
            <th>Water Price</th>
            <th>Wifi Price</th>
            <th>Category</th>
            <th>Image</th>
            <th>Room Status</th>
            <th>Actions</th>
            <th>Post Status</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="room" items="${rooms}">
            <tr data-room-id="${room.motelRoomId}">
                <td class="name">${room.name}</td>
                <td class="description">${room.description}</td>
                <td class="length">${room.length}</td>
                <td class="width">${room.width}</td>
                <td class="roomPrice">${room.roomPrice}</td>
                <td class="electricityPrice">${room.electricityPrice}</td>
                <td class="waterPrice">${room.waterPrice}</td>
                <td class="wifiPrice">${room.wifiPrice}</td>
                <td class="category">${room.category}</td>
                <c:choose>
                    <c:when test="${not empty room.image}">
                        <td><img src="${pageContext.request.contextPath}/images/${room.image[0]}" width="100px" height="100px"/></td>
                    </c:when>
                    <c:otherwise>
                        <td><img src="${pageContext.request.contextPath}/images/default-room.jpg" width="100px" height="100px"/></td>
                    </c:otherwise>
                </c:choose>
                <td class="roomStatus">
                    <c:choose>
                        <c:when test="${room.roomStatus}">Available</c:when>
                        <c:otherwise>Unavailable</c:otherwise>
                    </c:choose>
                </td>
                <td class="actions">
                    <a href="javascript:void(0);" onclick="showForm('edit', ${room.motelRoomId},${room.motelId});">Edit</a>
                    <!-- <a href="${pageContext.request.contextPath}/motel-rooms?action=delete&id=${room.motelRoomId}" onclick="return confirm('Are you sure?');">Delete</a> -->
                    <a href="${pageContext.request.contextPath}/add_tenants.jsp?motel_room_id=${room.motelRoomId}">Manage</a>
                    <a href="javascript:void(0);" onclick="requestPost(${room.motelRoomId});">Request for Posting</a>
                </td>
                <td class="postRequestStatus">${room.postRequestStatus}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
    <nav>
        <ul id="pagination" class="pagination">
            <!-- Các nút phân trang sẽ được thêm vào đây bởi JavaScript -->
        </ul>
    </nav>

    <!-- Modal -->
    <div class="modal fade" id="roomModal" tabindex="-1" aria-labelledby="roomModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="roomModalLabel">Room Form</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <form id="roomForm" action="${pageContext.request.contextPath}/motel-rooms" method="post" enctype="multipart/form-data">
                        <input type="hidden" name="action" id="form-action" value="create">
                        <input type="hidden" name="id" id="roomId">
                        <div class="row">
                            <div class="col-md-6">
                                <label for="name">Name:</label>
                                <input type="text" id="name" name="name" class="form-control" required><br>
                                <label for="description">Description:</label>
                                <input type="text" id="description" name="description" class="form-control"><br>
                                <label for="length">Length:</label>
                                <input type="number" id="length" name="length" class="form-control" step="0.01" required><br>
                                <label for="width">Width:</label>
                                <input type="number" id="width" name="width" class="form-control" step="0.01" required><br>
                                <label for="roomPrice">Room Price:</label>
                                <input type="number" id="roomPrice" name="roomPrice" class="form-control" step="0.01" required><br>
                                <label for="electricityPrice">Electricity Price:</label>
                                <input type="number" id="electricityPrice" name="electricityPrice" class="form-control" step="0.01" required><br>
                                <label for="waterPrice">Water Price:</label>
                                <input type="number" id="waterPrice" name="waterPrice" class="form-control" step="0.01" required><br>
                                <label for="wifiPrice">Wifi Price:</label>
                                <input type="number" id="wifiPrice" name="wifiPrice" class="form-control" step="0.01" required><br>
                                <label for="category">Category:</label>
                                <select id="category" name="category" class="form-control" required></select><br>
                                <label>Room Status:</label>
                                <div class="radio-group">
                                    <input type="radio" id="statusTrue" name="status" value="true">
                                    <label for="statusTrue">Available</label>
                                    <input type="radio" id="statusFalse" name="status" value="false">
                                    <label for="statusFalse">Unavailable</label>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <label for="images">Upload Images:</label>
                                <input type="file" id="images" name="images" class="form-control-file" multiple onchange="handleImageUpload(event)"><br>
                                <span id="file-count-display"></span>
                                <div id="image-previews" class="d-flex flex-wrap"></div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="submit" class="btn btn-primary">Save</button>
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        var roomsPerPage = 5;
        var currentPage = 1;
        var rooms = Array.from(document.querySelectorAll("tbody tr"));
        var totalPages = Math.ceil(rooms.length / roomsPerPage);

        function showPage(page) {
            // Ẩn tất cả các hàng
            rooms.forEach(function(row) {
                row.style.display = 'none';
            });

            // Tính toán các hàng cần hiển thị cho trang hiện tại
            var startIndex = (page - 1) * roomsPerPage;
            var endIndex = Math.min(startIndex + roomsPerPage, rooms.length);

            for (var i = startIndex; i < endIndex; i++) {
                rooms[i].style.display = '';
            }
        }

        function createPagination() {
            var pagination = document.getElementById("pagination");
            pagination.innerHTML = '';

            // Nút Previous
            var prev = document.createElement("li");
            prev.classList.add("page-item");
            if (currentPage === 1) {
                prev.classList.add("disabled");
            }
            prev.innerHTML = '<a class="page-link" href="#">Previous</a>';
            prev.onclick = function() {
                if (currentPage > 1) {
                    currentPage--;
                    showPage(currentPage);
                    createPagination();
                }
            };
            pagination.appendChild(prev);

            // Các nút số trang
            for (var i = 1; i <= totalPages; i++) {
                var pageItem = document.createElement("li");
                pageItem.classList.add("page-item");
                if (i === currentPage) {
                    pageItem.classList.add("active");
                }
                pageItem.innerHTML = '<a class="page-link" href="#">' + i + '</a>';
                pageItem.onclick = (function(page) {
                    return function() {
                        currentPage = page;
                        showPage(currentPage);
                        createPagination();
                    };
                })(i);
                pagination.appendChild(pageItem);
            }

            // Nút Next
            var next = document.createElement("li");
            next.classList.add("page-item");
            if (currentPage === totalPages) {
                next.classList.add("disabled");
            }
            next.innerHTML = '<a class="page-link" href="#">Next</a>';
            next.onclick = function() {
                if (currentPage < totalPages) {
                    currentPage++;
                    showPage(currentPage);
                    createPagination();
                }
            };
            pagination.appendChild(next);
        }

        // Hiển thị trang đầu tiên và tạo các nút phân trang
        if (rooms.length > 0) {
            showPage(currentPage);
            createPagination();
        }
    });

</script>
<script>

    // Add this function to your JavaScript
    function showForm(action, roomId, motelId) {
        $('#roomModal').modal('show');
        document.getElementById('form-action').value = action;
        loadCategories();
        if (action === 'edit' && roomId) {
            document.getElementById('roomId').value = roomId;
            fetchRoomDetails(roomId);
        } else {
            document.getElementById('roomForm').reset();
            document.getElementById('image-previews').innerHTML = '';
        }
        // Set the motelId in the form
        document.getElementById('motelId').value = motelId;
    }
</script>

</body>
</html>
