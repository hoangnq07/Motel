package model;
import java.util.Date;

public class Water {
    private int waterId;
    private Date createDate;
    private float waterIndex;
    private int invoiceId;

    public Water(int waterId, Date createDate, float waterIndex, int invoiceId) {
        this.waterId = waterId;
        this.createDate = createDate;
        this.waterIndex = waterIndex;
        this.invoiceId = invoiceId;
    }

    public Water() {

    }

    public int getWaterId() {
        return waterId;
    }

    public void setWaterId(int waterId) {
        this.waterId = waterId;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
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
}
