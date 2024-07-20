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
    private String motelName; // Tên của nhà trọ
    private String roomName; // Tên của phòng

    public Feedback() {}

    public Feedback(int feedbackId, String feedbackText, Date createDate, int accountId, int toUserId, String tag, String senderName, int motelId, int motelRoomId, String motelName, String roomName) {
        this.feedbackId = feedbackId;
        this.feedbackText = feedbackText;
        this.createDate = createDate;
        this.accountId = accountId;
        this.toUserId = toUserId;
        this.tag = tag;
        this.senderName = senderName;
        this.motelId = motelId;
        this.motelRoomId = motelRoomId;
        this.motelName = motelName;
        this.roomName = roomName;
    }

    public Feedback(String feedbackText, int feedbackId, Date createDate, int accountId, int toUserId, String tag, int motelRoomId, String senderName, int motelId) {
        this.feedbackText = feedbackText;
        this.feedbackId = feedbackId;
        this.createDate = createDate;
        this.accountId = accountId;
        this.toUserId = toUserId;
        this.tag = tag;
        this.motelRoomId = motelRoomId;
        this.senderName = senderName;
        this.motelId = motelId;
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

    public void setMotelId(int motelId) {
        this.motelId = motelId;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
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

    public String getMotelName() {
        return motelName;
    }

    public void setMotelName(String motelName) {
        this.motelName = motelName;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }
}
