package model;
import java.util.Date;

public class Electricity {
    private int electricityId;
    private Date createDate;
    private float electricityIndex;
    private int invoiceId;

    public Electricity(int electricityId, Date createDate, float electricityIndex, int invoiceId) {
        this.electricityId = electricityId;
        this.createDate = createDate;
        this.electricityIndex = electricityIndex;
        this.invoiceId = invoiceId;
    }

    public Electricity() {

    }

    public int getElectricityId() {
        return electricityId;
    }

    public void setElectricityId(int electricityId) {
        this.electricityId = electricityId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public float getElectricityIndex() {
        return electricityIndex;
    }

    public void setElectricityIndex(float electricityIndex) {
        this.electricityIndex = electricityIndex;
    }

    public int getInvoiceId() {
        return invoiceId;
    }

    public void setInvoiceId(int invoiceId) {
        this.invoiceId = invoiceId;
    }
}