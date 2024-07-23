<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, model.Renter, context.DBcontext" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản Lý Người Thuê</title>
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
    <h1>Quản Lý Người Thuê</h1>

    <%
        Integer motelId = null;
        if (session.getAttribute("motelId") != null) {
            motelId = (Integer) session.getAttribute("motelId");
        } else if (session.getAttribute("currentMotelId") != null) {
            motelId = (Integer) session.getAttribute("currentMotelId");
        }

        SimpleDateFormat dateFormatter = new SimpleDateFormat("dd/MM/yyyy");
    %>

    <table class="table table-bordered">
        <thead>
        <tr>
            <th>ID Người Thuê</th>
            <th>Tên Phòng</th>
            <th>Ngày Thuê</th>
            <th>Họ Tên</th>
            <th>Email</th>
            <th>Giới Tính</th>
            <th>Ngày Sinh</th>
            <th>Số CCCD</th>
        </tr>
        </thead>
        <tbody>
        <%
            if (motelId != null) {
                String sql = "SELECT r.renter_id, mr.name AS room_name, r.renter_date, " +
                        "a.fullname, a.email, a.gender, a.dob, a.citizen_id " +
                        "FROM dbo.renter r " +
                        "JOIN dbo.motel_room mr ON r.motel_room_id = mr.motel_room_id " +
                        "JOIN dbo.accounts a ON r.renter_id = a.account_id " +
                        "WHERE mr.motel_id = ? " +
                        "ORDER BY r.renter_date DESC";

                try (Connection conn = DBcontext.getConnection();
                     PreparedStatement pstmt = conn.prepareStatement(sql)) {

                    pstmt.setInt(1, motelId);
                    ResultSet rs = pstmt.executeQuery();

                    boolean hasRows = false;
                    while (rs.next()) {
                        hasRows = true;
                        int renterId = rs.getInt("renter_id");
                        String roomName = rs.getString("room_name");
                        Date renterDate = rs.getDate("renter_date");
                        String fullname = rs.getString("fullname");
                        String email = rs.getString("email");
                        boolean gender = rs.getBoolean("gender");
                        Date dob = rs.getDate("dob");
                        String citizenId = rs.getString("citizen_id");

                        String formattedRenterDate = renterDate != null ? dateFormatter.format(renterDate) : "";
                        String formattedDob = dob != null ? dateFormatter.format(dob) : "";
        %>
        <tr>
            <td><%= renterId %></td>
            <td><%= roomName %></td>
            <td><%= formattedRenterDate %></td>
            <td><%= fullname %></td>
            <td><%= email %></td>
            <td><%= gender ? "Nam" : "Nữ" %></td>
            <td><%= formattedDob %></td>
            <td><%= citizenId %></td>
        </tr>
        <%
                    }
                    if (!hasRows) {
                        out.println("<tr><td colspan='8'>Không tìm thấy người thuê nào cho trọ/chung cư này!</td></tr>");
                    }
                } catch (SQLException e) {
                    e.printStackTrace();
                    out.println("<tr><td colspan='8'>Có lỗi xảy ra khi truy vấn dữ liệu: " + e.getMessage() + "</td></tr>");
                }
            } else {
                out.println("<tr><td colspan='8'>Không tìm thấy ID của Motel trong session.</td></tr>");
            }
        %>
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html>