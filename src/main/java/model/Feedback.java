package model;

import java.util.Date;

public class Feedback {
    private int feedbackId;
    private String feedbackText;
    private Date createDate;
    private int accountId; // ID of the user who sent the feedback
    private int toUserId;  // ID of the user who received the feedback
    private String tag;    // Tag to identify feedback recipient role (owner/admin)

    // Constructors
    public Feedback() {}

    public Feedback(int feedbackId, String feedbackText, Date createDate, int accountId, int toUserId, String tag) {
        this.feedbackId = feedbackId;
        this.feedbackText = feedbackText;
        this.createDate = createDate;
        this.accountId = accountId;
        this.toUserId = toUserId;
        this.tag = tag;
    }

    // Getter and Setter methods
    public int getFeedbackId() {
        return feedbackId;
    }

    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }

    public String getFeedbackText() {
        return feedbackText;
    }

    public void setFeedbackText(String feedbackText) {
        this.feedbackText = feedbackText;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public int getToUserId() {
        return toUserId;
    }

    public void setToUserId(int toUserId) {
        this.toUserId = toUserId;
    }

    public String getTag() {
        return tag;
    }

    public void setTag(String tag) {
        this.tag = tag;
    }
}
