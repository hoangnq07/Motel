package model;

import java.util.Date;
import Account.Account;
public class Renter {
    private int renterId;
    private Date changeRoomDate;
    private Date checkOutDate;
    private Date renterDate;
    private int motelRoomId;
    private String roomName;
    private String motelName;
    private Account account;

    // Constructors
    public Renter() {}

    public Renter(int renterId, Date changeRoomDate, Date checkOutDate, Date renterDate, int motelRoomId, Account account) {
        this.renterId = renterId;
        this.changeRoomDate = changeRoomDate;
        this.checkOutDate = checkOutDate;
        this.renterDate = renterDate;
        this.motelRoomId = motelRoomId;
        this.account = account;
    }

    // Getters and Setters
    public int getRenterId() {
        return renterId;
    }

    public String getRoomName() {
        return roomName;
    }

    public void setRoomName(String roomName) {
        this.roomName = roomName;
    }

    public String getMotelName() {
        return motelName;
    }

    public void setMotelName(String motelName) {
        this.motelName = motelName;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public Date getChangeRoomDate() {
        return changeRoomDate;
    }

    public void setChangeRoomDate(Date changeRoomDate) {
        this.changeRoomDate = changeRoomDate;
    }

    public Date getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(Date checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public Date getRenterDate() {
        return renterDate;
    }

    public void setRenterDate(Date renterDate) {
        this.renterDate = renterDate;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
    }

    public Account getAccount() {
        return account;
    }

    public void setAccount(Account account) {
        this.account = account;
    }
}
