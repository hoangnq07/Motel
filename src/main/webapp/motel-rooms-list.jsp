<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Motel Room List</title>
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
    </style>
    <script>
        var contextPath = '${pageContext.request.contextPath}';
    </script>
    <script>
        function showForm(action, roomId, motelId){
            document.getElementById('form-container').classList.remove('hidden');
            document.getElementById('form-action').value = action;
            document.getElementById('motelId').value = motelId;
            if (action === 'edit' && roomId) {
                document.getElementById('roomId').value = roomId;
                fetchRoomDetails(roomId);
            } else {
                document.getElementById('roomForm').reset();
            }
        }


        function hideForm() {
            document.getElementById('form-container').classList.add('hidden');
            document.getElementById('roomForm').reset();
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
                    document.getElementById('category').value = room.category;
                    document.getElementById('categoryRoomId').value = room.categoryRoomId;
                    document.getElementById('roomStatus').checked = room.roomStatus;
                })
                .catch(function(error) {
                    console.error('Error:', error);
                    alert('Failed to fetch room details: ' + error.message);
                });
        }
    </script>
</head>
<body>
<div class="container">
    <h2>Motel Room List</h2>

    <a href="javascript:void(0);" onclick="showForm('create');" class="btn">Add New Room</a>
    <table>
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
                <td class="image"><img src="${pageContext.request.contextPath}/uploads/${room.image.get(1)}" width="100px" height="100px"/></td>
                <td class="roomStatus">
                    <c:choose>
                        <c:when test="${room.roomStatus}">Available</c:when>
                        <c:otherwise>Unavailable</c:otherwise>
                    </c:choose>
                </td>
                <td class="actions">
                    <a href="javascript:void(0);" onclick="showForm('edit', ${room.motelRoomId},${room.motelId});">Edit</a>
                    <a href="${pageContext.request.contextPath}/motel-rooms?action=delete&id=${room.motelRoomId}" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div id="form-container" class="form-container hidden">
        <form id="roomForm" action="${pageContext.request.contextPath}/motel-rooms" method="post">
            <input type="hidden" name="action" id="form-action" value="create">
            <input type="hidden" name="id" id="roomId">
            <label for="name">Name:</label>
            <input type="text" id="name" name="name" required><br>
            <label for="description">Description:</label>
            <input type="text" id="description" name="description"><br>
            <label for="length">Length:</label>
            <input type="number" id="length" name="length" step="0.01" required><br>
            <label for="width">Width:</label>
            <input type="number" id="width" name="width" step="0.01" required><br>
            <label for="roomPrice">Room Price:</label>
            <input type="number" id="roomPrice" name="roomPrice" step="0.01" required><br>
            <label for="electricityPrice">Electricity Price:</label>
            <input type="number" id="electricityPrice" name="electricityPrice" step="0.01" required><br>
            <label for="waterPrice">Water Price:</label>
            <input type="number" id="waterPrice" name="waterPrice" step="0.01" required><br>
            <label for="wifiPrice">Wifi Price:</label>
            <input type="number" id="wifiPrice" name="wifiPrice" step="0.01" required><br>
            <label for="category">Category:</label>
            <input type="text" id="category" name="category" required><br>
            <input type="hidden" id="categoryRoomId" name="categoryRoomId"><br>
            <label for="roomStatus">Room Status:</label>
            <input type="checkbox" id="roomStatus" name="roomStatus"><br>
            <input type="hidden" name="motelId" id="motelId"><br>
            <button type="submit">Save</button>
            <button type="button" onclick="hideForm();">Cancel</button>
        </form>
    </div>
</div>
</body>
</html>
