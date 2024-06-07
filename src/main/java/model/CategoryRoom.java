package model;

public class CategoryRoom {
    private int categoryRoomId;
    private String descriptions;
    private int quantity;
    private boolean status;

    // Getters and Setters
    public int getCategoryRoomId() {
        return categoryRoomId;
    }

    public void setCategoryRoomId(int categoryRoomId) {
        this.categoryRoomId = categoryRoomId;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        return "CategoryRoom{" +
                "categoryRoomId=" + categoryRoomId +
                ", descriptions='" + descriptions + '\'' +
                ", quantity=" + quantity +
                ", status=" + status +
                '}';
    }
}
