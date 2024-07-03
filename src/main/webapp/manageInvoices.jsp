<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.Invoice, context.DBcontext" %>
<%@ page import="java.util.Date" %>
<%@ page import="Account.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Invoices</title>
    <style>
        table {
            border-collapse: collapse;
            width: 100%;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #f2f2f2;
        }
        .action-buttons {
            display: flex;
            justify-content: space-around;
        }
    </style>
</head>
<body>
<h1>Manage Invoices</h1>

<table>
    <tr>
        <th>Invoice ID</th>
        <th>Create Date</th>
        <th>End Date</th>
        <th>Total Price</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>

    <%
        Integer accountId = ((Account) session.getAttribute("user")).getAccountId();
        if (accountId != null) {
            try (Connection conn = DBcontext.getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                         "SELECT \n" +
                                 "    mr.motel_room_id,\n" +
                                 "    i.invoice_id,\n" +
                                 "    i.create_date,\n" +
                                 "    i.end_date,\n" +
                                 "    i.total_price,\n" +
                                 "    i.invoice_status\n" +
                                 "FROM dbo.motel_room mr\n" +
                                 "LEFT JOIN dbo.invoice i ON mr.motel_room_id = i.motel_room_id\n" +
                                 "WHERE mr.account_id = ?\n" +
                                 "ORDER BY i.create_date DESC;")) {

                pstmt.setInt(1, accountId);
                ResultSet rs = pstmt.executeQuery();

                while (rs.next()) {
                    int invoiceId = rs.getInt("invoice_id");
                    if (rs.wasNull()) {
                        continue;
                    }
                    Date createDate = rs.getDate("create_date");
                    Date endDate = rs.getDate("end_date");
                    float totalPrice = rs.getFloat("total_price");
                    String status = rs.getString("invoice_status");
    %>
    <tr>
        <td><%= invoiceId %></td>
        <td><%= createDate %></td>
        <td><%= endDate %></td>
        <td><%= String.format("%.2f", totalPrice) %></td>
        <td><%= status %></td>
        <td class="action-buttons">
            <form action="editInvoice" method="get">
                <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                <input type="submit" value="Edit">
            </form>
            <form action="deleteInvoice" method="post" onsubmit="return confirm('Are you sure you want to delete this invoice?');">
                <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                <input type="submit" value="Delete">
            </form>
        </td>
    </tr>
    <%
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
        } else {
            out.println("<tr><td colspan='6'>Account ID not found in session.</td></tr>");
        }
    %>
</table>
</body>
</html>
