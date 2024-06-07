<%@ page import="java.util.List" %>
<%@ page import="model.MotelRoom" %>
<%@ page import="dao.MotelRoomDAO" %>
<%@ page import="dao.CategoryRoomDAO" %>
<%@ page import="dao.MotelDAO" %>

<%
    MotelRoomDAO motelRoomDAO = new MotelRoomDAO();
    List<MotelRoom> motelRooms = motelRoomDAO.getAllMotelRooms();

    CategoryRoomDAO categoryRoomDAO = new CategoryRoomDAO();
    MotelDAO motelDAO = new MotelDAO();
%>

<table>
    <tr>
        <th>ID</th>
        <th>Mô tả</th>
        <th>Chiều dài</th>
        <th>Chiều rộng</th>
        <th>Trạng thái</th>
        <th>Loại phòng</th>
        <th>Nhà trọ</th>
        <th>Tình trạng</th>
        <th>Hành động</th>
    </tr>
    <% for (MotelRoom room : motelRooms) { %>
    <tr>
        <td><%= room.getMotelRoomId() %></td>
        <td><%= room.getDescriptions() %></td>
        <td><%= room.getLength() %></td>
        <td><%= room.getWidth() %></td>
        <td><%= room.isStatus() ? "Đang hoạt động" : "Ngừng hoạt động" %></td>
        <td><%= categoryRoomDAO.getCategoryRoomById(room.getCategoryRoomId()).getDescriptions() %></td>
        <td><%= motelDAO.getMotelById(room.getMotelId()).getDescriptions() %></td>
        <td><%= room.getRoomStatus() %></td>
        <td>
            <a href="room-edit.jsp?id=<%= room.getMotelRoomId() %>">Sửa</a>
            <a href="room-delete.jsp?id=<%= room.getMotelRoomId() %>">Xóa</a>
        </td>
    </tr>
    <% } %>
</table>