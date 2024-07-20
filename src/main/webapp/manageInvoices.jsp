<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.Invoice, context.DBcontext" %>
<%@ page import="java.util.Date" %>
<%@ page import="Account.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Hóa Đơn</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
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
<div class="container">
    <h1>Quản Lý Hóa Đơn</h1>
    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID của Hóa Đơn</th>
            <th>Ngày tạo</th>
            <th>Ngày kết thúc</th>
            <th>Tổng Giá</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody>
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
                <form action="editInvoice" method="get" class="d-inline">
                    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                    <input type="submit" class="btn btn-warning btn-sm" value="Chỉnh sửa">
                </form>
                <form action="deleteInvoice" method="post" class="d-inline" onsubmit="return confirm('Bạn có chắc là muốn xóa hóa đơn này không?');">
                    <input type="hidden" name="invoiceId" value="<%= invoiceId %>">
                    <input type="submit" class="btn btn-danger btn-sm" value="Xóa">
                </form>
            </td>
        </tr>
        <%
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            } else {
                out.println("<tr><td colspan='6'>Không tìm thấy ID của Tài khoản.</td></tr>");
            }
        %>
        </tbody>
    </table>

    <!-- Nút để mở modal -->
    <button id="createBillButton" class="btn btn-primary">Tạo Hóa Đơn</button>

    <!-- Modal để hiển thị createBill.jsp -->
    <div class="modal fade" id="createBillModal" tabindex="-1" role="dialog" aria-labelledby="createBillModalLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <jsp:include page="createBill.jsp"/>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        $('#createBillButton').click(function() {
            $('#createBillModal').modal('show');
        });
    });
</script>
</body>
</html>
