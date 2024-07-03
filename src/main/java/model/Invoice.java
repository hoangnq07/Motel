package model;

import java.util.Date;

public class Invoice {
    private int invoiceId;
    private Date createDate;
    private Date endDate;
    private float totalPrice;
    private String invoiceStatus;
    private int renterId;
    private int motelRoomId;
    private float electricityIndex;
    private float waterIndex;

    public Invoice() {}

    public Invoice(int invoiceId, Date createDate, Date endDate, float totalPrice,
                   String invoiceStatus, int renterId, int motelRoomId,
                   float electricityIndex, float waterIndex) {
        this.invoiceId = invoiceId;
        this.createDate = createDate;
        this.endDate = endDate;
        this.totalPrice = totalPrice;
        this.invoiceStatus = invoiceStatus;
        this.renterId = renterId;
        this.motelRoomId = motelRoomId;
        this.electricityIndex = electricityIndex;
        this.waterIndex = waterIndex;
    }

    public float getElectricityIndex() {
        return electricityIndex;
    }

    public void setElectricityIndex(float electricityIndex) {
        this.electricityIndex = electricityIndex;
    }

    public float getWaterIndex() {
        return waterIndex;
    }

    public void setWaterIndex(float waterIndex) {
        this.waterIndex = waterIndex;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public float getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(float totalPrice) {
        this.totalPrice = totalPrice;
    }

    public String getInvoiceStatus() {
        return invoiceStatus;
    }

    public void setInvoiceStatus(String invoiceStatus) {
        this.invoiceStatus = invoiceStatus;
    }

    public int getRenterId() {
        return renterId;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
    }
}