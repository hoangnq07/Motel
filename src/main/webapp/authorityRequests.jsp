<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, context.DBcontext, Account.Account" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Authority Requests</title>
</head>
<body style="margin-top: 50px;">
<jsp:include page="header.jsp" />

<h2>Authority Requests</h2>

<%
    // Check if the user is an admin
    HttpSession currentSession = request.getSession();
    Account user = (Account) currentSession.getAttribute("user");

    if (user == null || !"admin".equals(user.getRole())) {
        out.println("Access Denied");
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

            out.print("<div>");
            out.print("<p>Request ID: " + requestId + "</p>");
            out.print("<p>Image: <img src='" + image + "' alt='Image' width='100'></p>");
            out.print("<p>Descriptions: " + descriptions + "</p>");
            out.print("<p>Status: " + status + "</p>");

            if ("Pending".equals(status)) {
                out.print("<form action='" + contextPath + "/approveAuthority' method='post'>");
                out.print("<input type='hidden' name='requestId' value='" + requestId + "'>");
                out.print("<label for='respDescriptions'>Response Descriptions:</label>");
                out.print("<textarea id='respDescriptions' name='respDescriptions' required></textarea><br><br>");
                out.print("<label for='status'>Status:</label>");
                out.print("<select id='status' name='status' required>");
                out.print("<option value='Approved'>Approved</option>");
                out.print("<option value='Rejected'>Rejected</option>");
                out.print("</select><br><br>");
                out.print("<input type='submit' value='Submit'>");
                out.print("</form>");
            } else {
                out.print("<p>Response Descriptions: " + responseDescriptions + "</p>");
            }

            out.print("</div><hr>");
        }
    } catch (SQLException e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

<!-- Filter Form -->
<form action="<%= ((HttpServletRequest) pageContext.getRequest()).getContextPath() %>/authorityRequests.jsp" method="get">
    <label for="statusFilter">Filter by Status:</label>
    <select id="statusFilter" name="statusFilter">
        <option value="Pending" <%= "Pending".equals(statusFilter) ? "selected" : "" %>>Pending</option>
        <option value="Approved" <%= "Approved".equals(statusFilter) ? "selected" : "" %>>Approved</option>
        <option value="Rejected" <%= "Rejected".equals(statusFilter) ? "selected" : "" %>>Rejected</option>
    </select>
    <input type="submit" value="Filter">
</form>
<jsp:include page="footer.jsp" />
</body>
</html>