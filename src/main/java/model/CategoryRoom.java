package model;

public class CategoryRoom {
    private int categoryRoomId;
    private String descriptions;
    private int quantity;
    private boolean status;

    // Các getter và setter cho các thuộc tính

    public int getCategoryRoomId() {
        return categoryRoomId;
    }

    public void setCategoryRoomId(int categoryRoomId) {
        this.categoryRoomId = categoryRoomId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    // Constructor
    public CategoryRoom() {
    }

    public CategoryRoom(int categoryRoomId, String descriptions, int quantity, boolean status) {
        this.categoryRoomId = categoryRoomId;
        this.descriptions = descriptions;
        this.quantity = quantity;
        this.status = status;
    }
    // Các phương thức khác nếu cần

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