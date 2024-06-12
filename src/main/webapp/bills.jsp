<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>All Bills</title>
</head>
<body>
<h1>All Bills</h1>
<table border="1">
    <tr>
        <th>Invoice ID</th>
        <th>Create Date</th>
        <th>End Date</th>
        <th>Total Price</th>
        <th>Status</th>
        <th>Motel Room ID</th>
        <th>Renter ID</th>
    </tr>
    <%
        try (Connection connection = DBcontext.getConnection()) {
            String selectSQL = "SELECT * FROM dbo.invoice";
            try (Statement statement = connection.createStatement(); ResultSet resultSet = statement.executeQuery(selectSQL)) {
                while (resultSet.next()) {
                    int invoiceId = resultSet.getInt("invoice_id");
                    Date createDate = resultSet.getDate("create_date");
                    Date endDate = resultSet.getDate("end_date");
                    float totalPrice = resultSet.getFloat("total_price");
                    String status = resultSet.getString("invoice_status");
                    int motelRoomId = resultSet.getInt("motel_room_id");
                    int renterId = resultSet.getInt("renter_id");
    %>
    <tr>
        <td><%= invoiceId %></td>
        <td><%= createDate %></td>
        <td><%= endDate %></td>
        <td><%= totalPrice %></td>
        <td><%= status %></td>
        <td><%= motelRoomId %></td>
        <td><%= renterId %></td>
    </tr>
    <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    %>
</table>
</body>
</html>
