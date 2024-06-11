<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.InvoiceDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo Hóa Đơn</title>
</head>
<body>
<%
    int invoiceId = Integer.parseInt(request.getParameter("invoiceId"));
    float electricityIndex = 0;
    float waterIndex = 0;

    try {
        InvoiceDAO invoiceDAO = new InvoiceDAO();
        float[] indexes = invoiceDAO.getIndexesByInvoiceId(invoiceId);
        electricityIndex = indexes[0];
        waterIndex = indexes[1];
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<h3>Thông tin chỉ số</h3>
<p>Chỉ số điện: <%= electricityIndex %></p>
<p>Chỉ số nước: <%= waterIndex %></p>

<form action="CreateInvoiceServlet" method="post">
    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
    <label for="roomPrice">Tiền phòng:</label>
    <input type="number" id="roomPrice" name="roomPrice" required><br>

    <label for="wifiPrice">Tiền wifi:</label>
    <input type="number" id="wifiPrice" name="wifiPrice" required><br>

    <label for="waterPrice">Tiền nước:</label>
    <input type="number" id="waterPrice" name="waterPrice" required><br>

    <label for="electricityPrice">Tiền điện:</label>
    <input type="number" id="electricityPrice" name="electricityPrice" required><br>

    <label for="motelRoomId">ID phòng:</label>
    <input type="number" id="motelRoomId" name="motelRoomId" required><br>

    <button type="submit">Gửi</button>
</form>
</body>
</html>
