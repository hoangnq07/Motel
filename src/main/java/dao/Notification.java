package dao;

public class Notification {
    private int notificationId;
    private String message;
    private String createDate;

    public Notification() {}

    public Notification(int notificationId, String message, String createDate) {
        this.notificationId = notificationId;
        this.message = message;
        this.createDate = createDate;
    }

    public int getNotificationId() {
        return notificationId;
    }

    public void setNotificationId(int notificationId) {
        this.notificationId = notificationId;
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
