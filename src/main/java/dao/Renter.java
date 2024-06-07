package dao;

public class Renter {
    private int renterId;
    private String fullname;
    private String email;
    private String phone;
    private String renterDate;
    private String checkOutDate;
    private int motelRoomId;

    // Getters và setters cho tất cả các thuộc tính
    public int getRenterId() {
        return renterId;
    }

    public void setRenterId(int renterId) {
        this.renterId = renterId;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRenterDate() {
        return renterDate;
    }

    public void setRenterDate(String renterDate) {
        this.renterDate = renterDate;
    }

    public String getCheckOutDate() {
        return checkOutDate;
    }

    public void setCheckOutDate(String checkOutDate) {
        this.checkOutDate = checkOutDate;
    }

    public int getMotelRoomId() {
        return motelRoomId;
    }

    public void setMotelRoomId(int motelRoomId) {
        this.motelRoomId = motelRoomId;
    }
}
