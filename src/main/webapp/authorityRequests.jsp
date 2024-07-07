<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext, Account.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Authority Requests</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
</head>
<body>
<div class="container">
    <h2 class="my-4">Authority Requests</h2>

    <%
        // Check if the user is an admin
        HttpSession currentSession = request.getSession();
        Account user = (Account) currentSession.getAttribute("user");

        if (user == null || !"admin".equals(user.getRole())) {
            out.println("<div class='alert alert-danger'>Access Denied</div>");
            return;
        }

        // Get status filter from request
        String statusFilter = request.getParameter("statusFilter");
        if (statusFilter == null) {
            statusFilter = "Pending"; // Default filter
        }

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DBcontext.getConnection();
            String sql = "SELECT * FROM dbo.request_authority WHERE request_authority_status = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, statusFilter);
            rs = stmt.executeQuery();

            while (rs.next()) {
                int requestId = rs.getInt("request_authority_id");
                String image = rs.getString("image");
                String descriptions = rs.getString("descriptions");
                String status = rs.getString("request_authority_status");
                String responseDescriptions = rs.getString("respdescriptions"); // Assuming this column exists
                int accountId = rs.getInt("account_id");

                HttpServletRequest httpRequest = (HttpServletRequest) pageContext.getRequest();
                String contextPath = httpRequest.getContextPath();
    %>

    <!-- Filter Form -->
    <form action="<%= ((HttpServletRequest) pageContext.getRequest()).getContextPath() %>/authorityRequests.jsp" method="get" class="form-inline my-4">
        <label class="my-1 mr-2" for="statusFilter">Filter by Status:</label>
        <select class="custom-select my-1 mr-sm-2" id="statusFilter" name="statusFilter">
            <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
            <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
            <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
        </select>
        <button type="submit" class="btn btn-primary my-1">Filter</button>
    </form>

    <div class="card mb-3">
        <div class="card-body">
            <h5 class="card-title">Request ID: <%= requestId %></h5>
            <p class="card-text"><strong>Image:</strong> <img src="<%= image %>" alt="Image" class="img-thumbnail" width="100"></p>
            <p class="card-text"><strong>Descriptions:</strong> <%= descriptions %></p>
            <p class="card-text"><strong>Status:</strong> <%= status %></p>

            <% if ("Pending".equals(status)) { %>
            <form action="<%= contextPath %>/approveAuthority" method="post">
                <input type="hidden" name="requestId" value="<%= requestId %>">
                <div class="form-group">
                    <label for="respDescriptions">Response Descriptions:</label>
                    <textarea class="form-control" id="respDescriptions" name="respDescriptions" required></textarea>
                </div>
                <div class="form-group">
                    <label for="status">Status:</label>
                    <select class="form-control" id="status" name="status" required>
                        <option value="Approved">Approved</option>
                        <option value="Rejected">Rejected</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary">Submit</button>
            </form>
            <% } else { %>
            <p class="card-text"><strong>Response Descriptions:</strong> <%= responseDescriptions %></p>
            <% } %>
        </div>
    </div>
    <%
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>


</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
