package model;

public class Notification {
    private String message;
    private String createDate;

    public Notification(String message, String createDate) {
        this.message = message;
        this.createDate = createDate;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getCreateDate() {
        return createDate;
    }

    public void setCreateDate(String createDate) {
        this.createDate = createDate;
    }
}
