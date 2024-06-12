<%@ page import="model.MotelRoom" %>
<%@ page import="java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Available Motel Rooms</title>
</head>
<body>
<h1>Available Motel Rooms</h1>
<%
    List<MotelRoom> rooms = (List<MotelRoom>) request.getAttribute("rooms");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");

    System.out.println("Rooms received in JSP: " + (rooms != null ? rooms.size() : "null"));
%>
<%
    if (rooms != null && !rooms.isEmpty()) {
%>
<table border="1">
    <tr>
        <th>Room ID</th>
        <th>Description</th>
        <th>Price</th>
        <th>Location</th>
        <th>Image</th>
    </tr>
    <%
        for (MotelRoom room : rooms) {
    %>
    <tr>
        <td><a href="room-details?roomId=<%= room.getMotelRoomId() %>"><%= room.getMotelRoomId() %></a></td>
        <td><%= room.getDescription() %></td>
        <td><%= room.getRoomPrice() %></td>
        <td><%= room.getDetailAddress() %>, <%= room.getWard() %>, <%= room.getDistrict() %>, <%= room.getProvince() %></td>
        <td>
            <% if (room.getImage() != null && !room.getImage().isEmpty()) { %>
            <img src="images/<%= room.getImage() %>" alt="Room Image" width="100" height="100"/>
            <% } %>
        </td>
    </tr>
    <%
        }
    %>
</table>
<div>
    <% if (currentPage > 1) { %>
    <a href="motel-rooms?action=list&page=<%= currentPage - 1 %>">Previous</a>
    <% } %>
    <% if (currentPage < totalPages) { %>
    <a href="motel-rooms?action=list&page=<%= currentPage + 1 %>">Next</a>
    <% } %>
</div>
<%
} else {
%>
<p>No rooms available.</p>
<%
    }
%>
</body>
</html>
