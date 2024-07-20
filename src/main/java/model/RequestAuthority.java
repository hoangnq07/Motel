package model;

import java.util.Date;

public class RequestAuthority {
    private int requestId;
    private Date createDate;
    private String descriptions;
    private int accountId;
    private String requestAuthorityStatus;
    private String imageIdCard;
    private String imageDoc;

    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getRequestAuthorityStatus() {
        return requestAuthorityStatus;
    }

    public void setRequestAuthorityStatus(String requestAuthorityStatus) {
        this.requestAuthorityStatus = requestAuthorityStatus;
    }

    public String getImageIdCard() {
        return imageIdCard;
    }

    public void setImageIdCard(String imageIdCard) {
        this.imageIdCard = imageIdCard;
    }

    public String getImageDoc() {
        return imageDoc;
    }

    public void setImageDoc(String imageDoc) {
        this.imageDoc = imageDoc;
    }
}
