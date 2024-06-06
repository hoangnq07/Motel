package model;

public class MotelRoom {
    private int motelRoomId;
    private java.sql.Date createDate;
    private String descriptions;
    private double length;
    private double width;
    private boolean status;
    private String video;
    private int categoryRoomId;
    private int motelId;
    private String roomStatus;

    // Getters and Setters
    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
    }

    public java.sql.Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(java.sql.Date createDate) {
        this.createDate = createDate;
    }

    public String getDescriptions() {
        return descriptions;
    }

    public void setDescriptions(String descriptions) {
        this.descriptions = descriptions;
    }

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public int getCategoryRoomId() {
        return categoryRoomId;
    }

    public void setCategoryRoomId(int categoryRoomId) {
        this.categoryRoomId = categoryRoomId;
    }

    public int getMotelId() {
        return motelId;
    }

    public void setMotelId(int motelId) {
        this.motelId = motelId;
    }

    public String getRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(String roomStatus) {
        this.roomStatus = roomStatus;
    }

    @Override
    public String toString() {
        return "MotelRoom{" +
                "motelRoomId=" + motelRoomId +
                ", createDate=" + createDate +
                ", descriptions='" + descriptions + '\'' +
                ", length=" + length +
                ", width=" + width +
                ", status=" + status +
                ", video='" + video + '\'' +
                ", categoryRoomId=" + categoryRoomId +
                ", motelId=" + motelId +
                ", roomStatus='" + roomStatus + '\'' +
                '}';
    }
}
