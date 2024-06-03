package model;

import java.util.Date;

public class Renter {
    private int renterId;
    private Date changeRoomDate;
    private Date checkOutDate;
    private Date renterDate;
    private int motelRoomId;

    // Các getter và setter cho các thuộc tính

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

    public Date getRenterDate() {
        return renterDate;
    }

    public void setRenterDate(Date renterDate) {
        this.renterDate = renterDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public Date getChangeRoomDate() {
        return changeRoomDate;
    }

    public void setChangeRoomDate(Date changeRoomDate) {
        this.changeRoomDate = changeRoomDate;
    }

    // Constructor
    public Renter() {
    }

    public Renter(int renterId, Date changeRoomDate, Date checkOutDate, Date renterDate, int motelRoomId) {
        this.renterId = renterId;
        this.changeRoomDate = changeRoomDate;
        this.checkOutDate = checkOutDate;
        this.renterDate = renterDate;
        this.motelRoomId = motelRoomId;
    }
    // Các phương thức khác nếu cần

    @Override
    public String toString() {
        return "Renter{" +
                "renterId=" + renterId +
                ", changeRoomDate=" + changeRoomDate +
                ", checkOutDate=" + checkOutDate +
                ", renterDate=" + renterDate +
                ", motelRoomId=" + motelRoomId +
                '}';
    }
}