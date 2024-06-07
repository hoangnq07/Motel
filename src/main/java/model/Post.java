package model;

import java.util.Date;

public class Post {
    private int postId;
    private Date createDate;
    private boolean status;
    private String title;
    private int motelId;

    public int getPostId() {
        return postId;
    }

    public void setPostId(int postId) {
        this.postId = postId;
    }

    public int getMotelId() {
        return motelId;
    }

    public void setMotelId(int motelId) {
        this.motelId = motelId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    @Override
    public String toString() {
        return "Post{" +
                "postId=" + postId +
                ", createDate=" + createDate +
                ", status=" + status +
                ", title='" + title + '\'' +
                ", motelId=" + motelId +
                '}';
    }

    // Constructor
    public Post() {
    }

    public Post(int postId, int motelId, String title, boolean status, Date createDate) {
        this.postId = postId;
        this.motelId = motelId;
        this.title = title;
        this.status = status;
        this.createDate = createDate;
    }
    // Các phương thức khác nếu cần
}