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
        function showForm(action, id) {
            document.getElementById('form-container').classList.remove('hidden');
            document.getElementById('form-action').value = action;
            if (action === 'edit') {
                // Load data for editing
                // This should ideally be done via an AJAX call to load room details based on id
                var room = document.querySelector(`[data-room-id="${id}"]`);
                if (room) {
                    document.getElementById('createDate').value = room.querySelector('.createDate').innerText;
                    document.getElementById('description').value = room.querySelector('.description').innerText;
                    document.getElementById('length').value = room.querySelector('.length').innerText;
                    document.getElementById('width').value = room.querySelector('.width').innerText;
                    document.getElementById('roomPrice').value = room.querySelector('.roomPrice').innerText;
                    document.getElementById('electricityPrice').value = room.querySelector('.electricityPrice').innerText;
                    document.getElementById('waterPrice').value = room.querySelector('.waterPrice').innerText;
                    document.getElementById('wifiPrice').value = room.querySelector('.wifiPrice').innerText;
                    document.getElementById('roomStatus').value = room.querySelector('.roomStatus').innerText;
                }
            }
        }

        function hideForm() {
            document.getElementById('form-container').classList.add('hidden');
            document.getElementById('roomForm').reset();
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
            <th>Create Date</th>
            <th>Descriptions</th>
            <th>Length</th>
            <th>Width</th>
            <th>Room Price</th>
            <th>Electricity Price</th>
            <th>Water Price</th>
            <th>Wifi Price</th>
            <th>Room Status</th>
            <th>Actions</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="room" items="${rooms}">
            <tr data-room-id="${room.motelRoomId}">
                <td class="createDate">${room.createDate}</td>
                <td class="description">${room.description}</td>
                <td class="length">${room.length}</td>
                <td class="width">${room.width}</td>
                <td class="roomPrice">${room.roomPrice}</td>
                <td class="electricityPrice">${room.electricityPrice}</td>
                <td class="waterPrice">${room.waterPrice}</td>
                <td class="wifiPrice">${room.wifiPrice}</td>
                <td class="roomStatus">
                    <c:choose>
                        <c:when test="${room.roomStatus}">Available</c:when>
                        <c:otherwise>Unavailable</c:otherwise>
                    </c:choose>
                </td>
                <td class="actions">
                    <a href="javascript:void(0);" onclick="showForm('edit', ${room.motelRoomId});">Edit</a>
                    <a href="motel-rooms?action=delete&id=${room.motelRoomId}" onclick="return confirm('Are you sure?');">Delete</a>
                </td>
            </tr>
        </c:forEach>
        </tbody>
    </table>

    <div id="form-container" class="form-container hidden">
        <form id="roomForm" action="motel-rooms" method="post">
            <input type="hidden" name="action" id="form-action" value="create">
            <label for="description">Description:</label>
            <input type="text" id="description" name="description"><br>
            <label for="length">Length:</label>
            <input type="text" id="length" name="length"><br>
            <label for="width">Width:</label>
            <input type="text" id="width" name="width"><br>
            <label for="roomPrice">Room Price:</label>
            <input type="text" id="roomPrice" name="roomPrice"><br>
            <label for="electricityPrice">Electricity Price:</label>
            <input type="text" id="electricityPrice" name="electricityPrice"><br>
            <label for="waterPrice">Water Price:</label>
            <input type="text" id="waterPrice" name="waterPrice"><br>
            <label for="wifiPrice">Wifi Price:</label>
            <input type="text" id="wifiPrice" name="wifiPrice"><br>
            <label for="roomStatus">Room Status:</label>
            <input type="text" id="roomStatus" name="roomStatus"><br>
            <button type="submit">Save</button>
            <button type="button" onclick="hideForm();">Cancel</button>
        </form>
    </div>

</div>
</body>
</html>
