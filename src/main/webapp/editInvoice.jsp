<%@ page import="model.Invoice" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Invoice</title>
</head>
<body>
<%
    Invoice invoice = (Invoice) request.getAttribute("invoice");
    String errorMessage = (String) request.getAttribute("errorMessage");
%>
<h1>Edit Invoice</h1>
<% if (errorMessage != null && !errorMessage.isEmpty()) { %>
<p style="color: red;"><%= errorMessage %></p>
<% } %>
<form action="editInvoice" method="post">
    <input type="hidden" name="invoiceId" value="<%= invoice.getInvoiceId() %>" />
    <label>Total Price:</label>
    <input type="text" name="totalPrice" value="<%= invoice.getTotalPrice() %>" /><br />
    <label>Invoice Status:</label>
    <input type="text" name="invoiceStatus" value="<%= invoice.getInvoiceStatus() %>" /><br />
    <label>Electricity Index:</label>
    <input type="text" name="electricityIndex" value="<%= invoice.getElectricityIndex() %>" /><br />
    <label>Water Index:</label>
    <input type="text" name="waterIndex" value="<%= invoice.getWaterIndex() %>" /><br />
    <input type="submit" value="Update" />
</form>
</body>
</html>