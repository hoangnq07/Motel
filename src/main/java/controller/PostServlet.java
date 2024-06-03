package controller;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import dao.PostDAO;
import model.Post;

@WebServlet("/posts")
public class PostServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private PostDAO postDAO;

    public void init() {
        postDAO = new PostDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            List<Post> posts = postDAO.getAllPosts();
            request.setAttribute("posts", posts);
            request.getRequestDispatcher("post-list.jsp").forward(request, response);
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "create";
        }

        switch (action) {
            case "create":
                createPost(request, response);
                break;
            case "update":
//                updatePost(request, response);
                break;
            case "delete":
//                deletePost(request, response);
                break;
        }
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
        Post post = new Post();
        post.setTitle(request.getParameter("title"));
        post.setStatus(Boolean.parseBoolean(request.getParameter("status")));
        post.setMotelId(Integer.parseInt(request.getParameter("motelId")));

        try {
            postDAO.addPost(post);
            response.sendRedirect("posts");
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

//    private void updatePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        int postId = Integer.parseInt(request.getParameter("postId"));
//        Post post = new Post();
//        post.setPostId(postId);
//        post.setTitle(request.getParameter("title"));
//        post.setStatus(Boolean.parseBoolean(request.getParameter("status")));
//        post.setMotelId(Integer.parseInt(request.getParameter("motelId")));
//
//        try {
////            postDAO.updatePost(post);
//            response.sendRedirect("posts");
//        } catch (SQLException ex) {
//            throw new ServletException(ex);
//        }
//    }

//    private void deletePost(HttpServletRequest request, HttpServletResponse response) throws IOException, ServletException {
//        int postId = Integer.parseInt(request.getParameter("postId"));
//
//        try {
//            postDAO.deletePost(postId);
//            response.sendRedirect("posts");
//        } catch (SQLException ex) {
//            throw new ServletException(ex);
//        }
//    }
}