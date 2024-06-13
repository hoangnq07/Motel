<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Your Bills</title>
</head>
<body>
<h1>Your Bills</h1>

<%
    String paymentMessage = (String) session.getAttribute("paymentMessage");
    if (paymentMessage != null) {
%>
<p style="color: green;"><%= paymentMessage %></p>
<%
        session.removeAttribute("paymentMessage");
    }
%>

<table border="1">
    <tr>
        <th>Invoice ID</th>
        <th>Create Date</th>
        <th>End Date</th>
        <th>Total Price</th>
        <th>Status</th>
        <th>Action</th>
    </tr>
    <%
        int accountId = (int) session.getAttribute("accountId");

        try (Connection connection = DBcontext.getConnection()) {
            // Get the renter's invoices
            String selectInvoicesSQL = "SELECT * FROM dbo.invoice WHERE renter_id = ?";
            try (PreparedStatement psInvoices = connection.prepareStatement(selectInvoicesSQL)) {
                psInvoices.setInt(1, accountId);
                ResultSet rsInvoices = psInvoices.executeQuery();
                while (rsInvoices.next()) {
                    int invoiceId = rsInvoices.getInt("invoice_id");
                    Date createDate = rsInvoices.getDate("create_date");
                    Date endDate = rsInvoices.getDate("end_date");
                    float totalPrice = rsInvoices.getFloat("total_price");
                    String status = rsInvoices.getString("invoice_status");
    %>
    <tr>
        <td><%= invoiceId %></td>
        <td><%= createDate %></td>
        <td><%= endDate %></td>
        <td><%= totalPrice %></td>
        <td><%= status %></td>
        <td>
            <form action="vnpayajax" method="post">
                <input type="hidden" name="amount" value="<%= totalPrice %>" />
                <input type="hidden" name="invoiceId" value="<%= invoiceId %>" />
                <button type="submit">Pay with VNPAY</button>
            </form>
        </td>
    </tr>
    <%
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            out.println("<tr><td colspan='6'>Error fetching bills.</td></tr>");
        }
    %>
</table>
</body>
</html>