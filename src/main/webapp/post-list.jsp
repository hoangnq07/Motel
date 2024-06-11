<%@ page import="java.util.List" %>
<%@ page import="model.Post" %>
<%@ page import="dao.PostDAO" %>

<%
    PostDAO postDAO = new PostDAO();
    List<Post> posts = postDAO.getAllPosts();
%>

<table>
    <tr>
        <th>ID</th>
        <th>Tiêu đề</th>
        <th>Trạng thái</th>
        <!-- Thêm các cột khác -->
    </tr>
    <% for (Post post : posts) { %>
    <tr>
        <td><%= post.getPostId() %></td>
        <td><%= post.getTitle() %></td>
        <td><%= post.isStatus() ? "Hiển thị" : "Ẩn" %></td>
        <!-- Hiển thị các thuộc tính khác của đối tượng Post -->
    </tr>
    <% } %>
</table>