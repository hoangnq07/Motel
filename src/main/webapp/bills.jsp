<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext" %>
<%@ page import="jakarta.servlet.http.*, jakarta.servlet.*" %>
<%@ page import="Account.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xem Hóa Đơn</title>
</head>
<body style="            margin-top: 50px;">
<jsp:include page="header.jsp" />

<h1>Hóa Đơn của bạn</h1>

<%
    String paymentMessage = (String) session.getAttribute("paymentMessage");
    if (paymentMessage != null) {
%>
<%= paymentMessage %>
<%
        session.removeAttribute("paymentMessage");
    }
%>

<%
    Integer accountId = ((Account) session.getAttribute("user")).getAccountId();
    boolean hasRentedRoom = false;

    try (Connection connection = DBcontext.getConnection()) {
        String checkRenterSQL = "SELECT COUNT(*) AS count FROM dbo.renter WHERE renter_id = ?";
        try (PreparedStatement psCheckRenter = connection.prepareStatement(checkRenterSQL)) {
            psCheckRenter.setInt(1, accountId);
            ResultSet rsCheckRenter = psCheckRenter.executeQuery();
            if (rsCheckRenter.next()) {
                hasRentedRoom = rsCheckRenter.getInt("count") > 0;
            }
        }

        if (!hasRentedRoom) {
%>
<p>Bạn chưa thuê vào phòng trọ nào cả!</p>
<%
} else {
    String selectInvoicesSQL = "SELECT * FROM dbo.invoice WHERE renter_id = ?";
    try (PreparedStatement psInvoices = connection.prepareStatement(selectInvoicesSQL)) {
        psInvoices.setInt(1, accountId);
        ResultSet rsInvoices = psInvoices.executeQuery();
%>
<table>
    <tr>
        <th>ID của Hóa Đơn</th>
        <th>Ngày Tạo</th>
        <th>Ngày kết thúc</th>
        <th>Tổng giá</th>
        <th>Trạng Thái</th>
        <th>Hành Động</th>
    </tr>
    <%
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
                <input type="hidden" name="amount" value="<%= totalPrice %>">
                <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                <button type="submit">Thanh toán với VNPAY</button>
            </form>
        </td>
    </tr>
    <%
        }
    %>
</table>
<%
        }
    }
} catch (SQLException e) {
    e.printStackTrace();
%>
<p>Error fetching bills.</p>
<%
    }
%>
</table>
<jsp:include page="footer.jsp" />
</body>
</html>