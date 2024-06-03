package dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Post;
import context.DBcontext;

public class PostDAO {

    public List<Post> getAllPosts() throws SQLException {
        List<Post> posts = new ArrayList<>();
        String sql = "SELECT * FROM dbo.posts";
        try (Connection conn = DBcontext.getConnection(); Statement stmt = conn.createStatement(); ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Post post = new Post();
                post.setPostId(rs.getInt("post_id"));
                post.setCreateDate(rs.getDate("create_date"));
                post.setStatus(rs.getBoolean("status"));
                post.setTitle(rs.getString("title"));
                post.setMotelId(rs.getInt("motel_id"));
                posts.add(post);
            }
        }
        return posts;
    }

    public void addPost(Post post) throws SQLException {
        String sql = "INSERT INTO dbo.posts (create_date, status, title, motel_id) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBcontext.getConnection(); PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setDate(1, new java.sql.Date(System.currentTimeMillis()));
            stmt.setBoolean(2, post.isStatus());
            stmt.setString(3, post.getTitle());
            stmt.setInt(4, post.getMotelId());
            stmt.executeUpdate();
        }
    }

    // Các phương thức khác như updatePost, deletePost, ...
}