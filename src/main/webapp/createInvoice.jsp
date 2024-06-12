<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="dao.InvoiceDAO" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Tạo Hóa Đơn</title>
</head>
<body>
<%
    String invoiceIdParam = request.getParameter("invoiceId");
    int invoiceId = invoiceIdParam != null ? Integer.parseInt(invoiceIdParam) : 0;
    float electricityIndex = 0;
    float waterIndex = 0;
    boolean showInvoiceForm = false;

    if (invoiceId != 0) {
        try {
            InvoiceDAO invoiceDAO = new InvoiceDAO();
            float[] indexes = invoiceDAO.getIndexesByInvoiceId(invoiceId);
            electricityIndex = indexes[0];
            waterIndex = indexes[1];
            showInvoiceForm = true;
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<h3>Thông tin chỉ số</h3>
<form action="createInvoice.jsp" method="post">
    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
    <label for="electricityIndex">Chỉ số điện:</label>
    <input type="number" id="electricityIndex" name="electricityIndex" step="0.01" required><br>
    <label for="waterIndex">Chỉ số nước:</label>
    <input type="number" id="waterIndex" name="waterIndex" step="0.01" required><br>
    <button type="submit">Tạo hóa đơn</button>
</form>

<% if (showInvoiceForm) { %>
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
<% } %>
</body>
</html>
