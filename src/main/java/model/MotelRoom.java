package model;

import java.util.Date;

public class MotelRoom {
    private int motelRoomId;
    private Date createDate;
    private String descriptions;
    private double length;
    private boolean status;
    private String video;
    private double width;
    private int categoryRoomId;
    private int motelId;
    private String roomStatus;


    // Constructor
    public MotelRoom() {
    }

    public MotelRoom(int motelRoomId, String roomStatus, int categoryRoomId, int motelId, double width, String video, boolean status, double length, String descriptions, Date createDate) {
        this.motelRoomId = motelRoomId;
        this.roomStatus = roomStatus;
        this.categoryRoomId = categoryRoomId;
        this.motelId = motelId;
        this.width = width;
        this.video = video;
        this.status = status;
        this.length = length;
        this.descriptions = descriptions;
        this.createDate = createDate;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
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

    public double getLength() {
        return length;
    }

    public void setLength(double length) {
        this.length = length;
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public double getWidth() {
        return width;
    }

    public void setWidth(double width) {
        this.width = width;
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
                ", status=" + status +
                ", video='" + video + '\'' +
                ", width=" + width +
                ", categoryRoomId=" + categoryRoomId +
                ", motelId=" + motelId +
                ", roomStatus='" + roomStatus + '\'' +
                '}';
    }
}