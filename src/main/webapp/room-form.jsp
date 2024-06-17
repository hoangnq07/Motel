<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>${room.id == null ? "Add New Room" : "Edit Room"}</title>
</head>
<body>
<h2>${room.id == null ? "Add New Room" : "Edit Room"}</h2>
<form action="motel-rooms" method="post">
    <input type="hidden" name="action" value="${room.id == null ? 'create' : 'edit'}">
    <input type="hidden" name="id" value="${room.id}">
    <label for="createDate">Create Date:</label>
    <input type="text" id="createDate" name="createDate" value="${room.createDate}"><br>
    <label for="description">Description:</label>
    <input type="text" id="description" name="description" value="${room.description}"><br>
    <label for="length">Length:</label>
    <input type="text" id="length" name="length" value="${room.length}"><br>
    <label for="width">Width:</label>
    <input type="text" id="width" name="width" value="${room.width}"><br>
    <label for="roomPrice">Room Price:</label>
    <input type="text" id="roomPrice" name="roomPrice" value="${room.roomPrice}"><br>
    <label for="electricityPrice">Electricity Price:</label>
    <input type="text" id="electricityPrice" name="electricityPrice" value="${room.electricityPrice}"><br>
    <label for="waterPrice">Water Price:</label>
    <input type="text" id="waterPrice" name="waterPrice" value="${room.waterPrice}"><br>
    <label for="wifiPrice">Wifi Price:</label>
    <input type="text" id="wifiPrice" name="wifiPrice" value="${room.wifiPrice}"><br>
    <label for="roomStatus">Room Status:</label>
    <input type="text" id="roomStatus" name="roomStatus" value="${room.roomStatus}"><br>
    <button type="submit">Save</button>
    <a href="motel-rooms">Cancel</a>
</form>
</body>
</html>
