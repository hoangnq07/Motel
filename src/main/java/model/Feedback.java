package model;

import java.util.Date;

public class Feedback {
    private int feedbackId;
    private String feedbackText;
    private Date createDate;
    private int accountId;
    private int toUserId;  // ID của người nhận feedback
    private String tag;  // Nhãn dùng để phân loại feedback
    private String senderName; // Tên của người gửi feedback
    private int motelId;
    private int motelRoomId;
    public Feedback() {}

    public Feedback(int feedbackId, String feedbackText, Date createDate, int accountId, int toUserId, String tag, String senderName) {
        this.feedbackId = feedbackId;
        this.feedbackText = feedbackText;
        this.createDate = createDate;
        this.accountId = accountId;
        this.toUserId = toUserId;
        this.tag = tag;
        this.senderName = senderName;
        this.motelId = motelId;
        this.motelRoomId = motelRoomId;
    }

    // Getters
    public int getFeedbackId() {
        return feedbackId;
    }

    public String getFeedbackText() {
        return feedbackText;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public int getAccountId() {
        return accountId;
    }

    public int getToUserId() {
        return toUserId;
    }

    public String getTag() {
        return tag;
    }

    public String getSenderName() {
        return senderName;
    }

    public int getMotelId() {
        return motelId;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    // Setters
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public void setFeedbackText(String feedbackText) {
        this.feedbackText = feedbackText;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public void setToUserId(int toUserId) {
        this.toUserId = toUserId;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }

    public void setSenderName(String senderName) {
        this.senderName = senderName;
    }

    public void setMotelId(int motelId) {
        this.motelId = motelId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
    }
}
