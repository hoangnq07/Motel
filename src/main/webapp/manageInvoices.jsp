<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.Invoice, context.DBcontext" %>
<%@ page import="java.util.Date" %>
<%@ page import="Account.Account" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
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

        .filter-bar {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        .filter-bar input, .filter-bar button {
            margin-right: 10px;
        }

    </style>
</head>
<body>
<div class="container">
    <div class="d-flex justify-content-between align-items-center">
        <h1>Quản Lý Hóa Đơn</h1>

<%--        <form id="filterForm" action="${pageContext.request.contextPath}/owner" method="get">--%>
<%--            <input type="hidden" name="page" value="bill">--%>
<%--            <input type="hidden" name="fromDate" id="hiddenFromDate">--%>
<%--            <input type="hidden" name="tillDate" id="hiddenTillDate">--%>
<%--        </form>--%>

<%--        <div class="filter-bar">--%>
<%--            <input type="date" id="fromDate" name="fromDate" class="form-control" placeholder="Từ ngày">--%>
<%--            <input type="date" id="tillDate" name="tillDate" class="form-control" placeholder="Đến ngày">--%>
<%--            <button id="filterButton" class="btn btn-primary">Lọc</button>--%>
<%--        </div>--%>
    </div>
    <button id="createBillButton" class="btn btn-primary">Tạo Hóa Đơn</button>

    <%
        Enumeration<String> attributeNames = session.getAttributeNames();
        while (attributeNames.hasMoreElements()) {
            String name = attributeNames.nextElement();
        }

        Integer motelId = null;
        if (session.getAttribute("motelId") != null) {
            motelId = (Integer) session.getAttribute("motelId");
        } else if (session.getAttribute("currentMotelId") != null) {
            motelId = (Integer) session.getAttribute("currentMotelId");
        }

        NumberFormat formatter = NumberFormat.getNumberInstance(new Locale("vi", "VN"));
        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
        String fromDateStr = request.getParameter("fromDate");
        String tillDateStr = request.getParameter("tillDate");
        LocalDate fromDate = null;
        LocalDate tillDate = null;
        DateTimeFormatter dateformatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");

        if (fromDateStr != null && !fromDateStr.isEmpty()) {
            fromDate = LocalDate.parse(fromDateStr, dateformatter);
        }
        if (tillDateStr != null && !tillDateStr.isEmpty()) {
            tillDate = LocalDate.parse(tillDateStr, dateformatter);
        }
    %>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID của Hóa Đơn</th>
            <th>Tên Phòng</th>
            <th>Ngày tạo</th>
            <th>Ngày kết thúc</th>
            <th>Tổng Giá</th>
            <th>Chỉ số Điện</th>
            <th>Chỉ số Nước</th>
            <th>Trạng Thái</th>
            <th>Hành Động</th>
        </tr>
        </thead>
        <tbody id="invoiceTableBody">

            <%
                StringBuilder sqlBuilder = new StringBuilder(
                        "SELECT i.invoice_id, mr.name AS room_name, i.create_date, i.end_date, " +
                                "i.total_price, i.invoice_status, e.electricity_index, w.water_index " +
                                "FROM dbo.motel_room mr " +
                                "JOIN dbo.invoice i ON mr.motel_room_id = i.motel_room_id " +
                                "LEFT JOIN dbo.electricity e ON i.invoice_id = e.invoice_id " +
                                "LEFT JOIN dbo.water w ON i.invoice_id = w.invoice_id " +
                                "WHERE mr.motel_id = ? "
                );

                if (fromDate != null) {
                    sqlBuilder.append("AND i.create_date >= ? ");
                }
                if (tillDate != null) {
                    sqlBuilder.append("AND i.create_date <= ? ");
                }
                sqlBuilder.append("ORDER BY i.create_date DESC");

                String sql = sqlBuilder.toString();

                if (motelId != null) {
                    try (Connection conn = DBcontext.getConnection();
                         PreparedStatement pstmt = conn.prepareStatement(sql)) {

                        int paramIndex = 1;
                        pstmt.setInt(paramIndex++, motelId);
                        if (fromDate != null) {
                            pstmt.setDate(paramIndex++, java.sql.Date.valueOf(fromDate));
                        }
                        if (tillDate != null) {
                            pstmt.setDate(paramIndex++, java.sql.Date.valueOf(tillDate));
                        }

                        ResultSet rs = pstmt.executeQuery();

                        boolean hasRows = false;
                        while (rs.next()) {
                            hasRows = true;
                            int invoiceId = rs.getInt("invoice_id");
                            String roomName = rs.getString("room_name");
                            Date createDate = rs.getDate("create_date");
                            Date endDate = rs.getDate("end_date");
                            float totalPrice = rs.getFloat("total_price");
                            String status = rs.getString("invoice_status");
                            float electricityIndex = rs.getFloat("electricity_index");
                            float waterIndex = rs.getFloat("water_index");

                            String formattedPrice = formatter.format(totalPrice);
                            String formattedCreateDate = dateFormatter.format(createDate);
                            String formattedEndDate = dateFormatter.format(endDate);
                            String displayStatus = status.equals("PAID") ? "Đã Thanh Toán" : "Chưa Thanh Toán";
            %>
        <tr>
            <td><%= invoiceId %></td>
            <td><%= roomName %></td>
            <td><%= formattedCreateDate %></td>
            <td><%= formattedEndDate %></td>
            <td><%= formattedPrice %> VNĐ</td>
            <td><%= electricityIndex %></td>
            <td><%= waterIndex %></td>
            <td><%= displayStatus %></td>
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
                    if (!hasRows) {
                        out.println("<tr><td colspan='6'>Không tìm thấy hóa đơn nào cho trọ/chung cư này!</td></tr>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='6'>Có lỗi xảy ra khi truy vấn dữ liệu: " + e.getMessage() + "</td></tr>");
                }
            } else {
                out.println("<tr><td colspan='6'>Không tìm thấy ID của Motel trong session.</td></tr>");
            }
        %>
        </tbody>
    </table>



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
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
<script>
    $(document).ready(function() {
        console.log("Document ready function executed");

        // Create bill button click event
        $('#createBillButton').click(function() {
            console.log("Create bill button clicked");
            $('#createBillModal').modal('show');
        });

        // Filter button click event
        $('#filterButton').click(function(e) {
            console.log("Filter button clicked");
            e.preventDefault(); // Prevent any default action

            var fromDate = $('#fromDate').val();
            var tillDate = $('#tillDate').val();

            console.log("From Date:", fromDate);
            console.log("Till Date:", tillDate);

            // Set the values in the hidden form fields
            $('#hiddenFromDate').val(fromDate);
            $('#hiddenTillDate').val(tillDate);

            console.log("Form action:", $('#filterForm').attr('action'));
            console.log("Form method:", $('#filterForm').attr('method'));

            // Submit the form
            $('#filterForm').submit();
        });

        // Set initial values if they exist in the URL
        var urlParams = new URLSearchParams(window.location.search);
        $('#fromDate').val(urlParams.get('fromDate'));
        $('#tillDate').val(urlParams.get('tillDate'));

        console.log("Initial fromDate:", $('#fromDate').val());
        console.log("Initial tillDate:", $('#tillDate').val());
    });
</script>
</body>
</html>
