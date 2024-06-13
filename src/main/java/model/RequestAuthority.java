package model;

import java.sql.Date;

public class RequestAuthority {
    private int requestAuthorityId;
    private String image;
    private Date createDate;
    private String descriptions;
    private String respDescriptions;
    private Date responseDate;
    private int accountId;
    private String requestAuthorityStatus;

    // Getters and Setters
    public int getRequestAuthorityId() {
        return requestAuthorityId;
    }

    public void setRequestAuthorityId(int requestAuthorityId) {
        this.requestAuthorityId = requestAuthorityId;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
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

    public String getRespDescriptions() {
        return respDescriptions;
    }

    public void setRespDescriptions(String respDescriptions) {
        this.respDescriptions = respDescriptions;
    }

    public Date getResponseDate() {
        return responseDate;
    }

    public void setResponseDate(Date responseDate) {
        this.responseDate = responseDate;
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

    @Override
    public String toString() {
        return "RequestAuthority{" +
                "requestAuthorityId=" + requestAuthorityId +
                ", image='" + image + '\'' +
                ", createDate=" + createDate +
                ", descriptions='" + descriptions + '\'' +
                ", respDescriptions='" + respDescriptions + '\'' +
                ", responseDate=" + responseDate +
                ", accountId=" + accountId +
                ", requestAuthorityStatus='" + requestAuthorityStatus + '\'' +
                '}';
    }
}