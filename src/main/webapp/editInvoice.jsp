<%@ page import="model.Invoice" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Invoice</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            width: 300px;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }
        .error {
            color: red;
            margin-bottom: 10px;
        }
        form {
            display: flex;
            flex-direction: column;
        }
        label {
            margin-bottom: 5px;
            font-weight: bold;
        }
        input[type="text"] {
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        input[type="submit"] {
            background-color: #4CAF50;
            color: white;
            border: none;
            padding: 10px;
            cursor: pointer;
            border-radius: 4px;
            font-size: 16px;
        }
        input[type="submit"]:hover {
            background-color: #45a049;
        }
    </style>
</head>
<body>
<div class="container">
    <%
        Invoice invoice = (Invoice) request.getAttribute("invoice");
        String errorMessage = (String) request.getAttribute("errorMessage");
    %>
    <h1>Edit Invoice</h1>
    <% if (errorMessage != null && !errorMessage.isEmpty()) { %>
    <p class="error"><%= errorMessage %></p>
    <% } %>
    <form action="editInvoice" method="post">
        <input type="hidden" name="invoiceId" value="<%= invoice.getInvoiceId() %>" />
        <label>Total Price:</label>
        <input type="text" name="totalPrice" value="<%= invoice.getTotalPrice() %>" />
        <label>Invoice Status:</label>
        <input type="text" name="invoiceStatus" value="<%= invoice.getInvoiceStatus() %>" />
        <label>Electricity Index:</label>
        <input type="text" name="electricityIndex" value="<%= invoice.getElectricityIndex() %>" />
        <label>Water Index:</label>
        <input type="text" name="waterIndex" value="<%= invoice.getWaterIndex() %>" />
        <input type="submit" value="Update" />
    </form>
</div>
</body>
</html>
