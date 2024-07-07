// RequestAuthority.java
package model;

public class RequestAuthority {
    private int requestId;
    private String image;
    private String descriptions;
    private String status;
    private String responseDescriptions;
    private int accountId;

    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getResponseDescriptions() {
        return responseDescriptions;
    }

    public void setResponseDescriptions(String responseDescriptions) {
        this.responseDescriptions = responseDescriptions;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }
}
