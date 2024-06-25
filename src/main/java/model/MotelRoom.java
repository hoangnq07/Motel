package model;

import java.sql.Date;
import java.util.List;

public class MotelRoom {
    private int motelRoomId;
    private String name;
    private Date createDate;
    private String description;
    private double length;
    private double width;
    private double roomPrice;
    private double electricityPrice;
    private double waterPrice;
    private double wifiPrice;
    private int categoryRoomId;
    private int motelId;
    private boolean roomStatus;
    private int accountId;
    private List<String> image;
    private String address;
    private String accountFullname;
    private String accountPhone;
    private String detailAddress;
    private String ward;
    private String district;
    private String city;
    private String province;
    private String category;
    private boolean isFavorite;
    public MotelRoom() {
    }

    public MotelRoom(int motelRoomId, String detailAddress, Date createDate, double length, String description, double width, double roomPrice, double waterPrice, double electricityPrice, int categoryRoomId, double wifiPrice, int motelId, boolean roomStatus, List<String> image, int accountId, String address, String accountFullname, String accountPhone, String ward, String district, String city, String category, String province, boolean isFavorite) {
        this.motelRoomId = motelRoomId;
        this.detailAddress = detailAddress;
        this.createDate = createDate;
        this.length = length;
        this.description = description;
        this.width = width;
        this.roomPrice = roomPrice;
        this.waterPrice = waterPrice;
        this.electricityPrice = electricityPrice;
        this.categoryRoomId = categoryRoomId;
        this.wifiPrice = wifiPrice;
        this.motelId = motelId;
        this.roomStatus = roomStatus;
        this.image = image;
        this.accountId = accountId;
        this.address = address;
        this.accountFullname = accountFullname;
        this.accountPhone = accountPhone;
        this.ward = ward;
        this.district = district;
        this.city = city;
        this.category = category;
        this.province = province;
        this.isFavorite = isFavorite;
    }

    public MotelRoom(int motelRoomId, String name, Date createDate, String description, String province) {
        this.motelRoomId = motelRoomId;
        this.name = name;
        this.createDate = createDate;
        this.description = description;
        this.province = province;
    }

    public MotelRoom(int motelRoomId, String name, Date createDate, String description, double length, double width, double roomPrice, double electricityPrice, double waterPrice, double wifiPrice, int categoryRoomId, int motelId, boolean roomStatus, int accountId, List<String> image, String address, String accountFullname, String accountPhone, String detailAddress, String ward, String district, String city, String province, String category, boolean isFavorite) {
        this.motelRoomId = motelRoomId;
        this.name = name;
        this.createDate = createDate;
        this.description = description;
        this.length = length;
        this.width = width;
        this.roomPrice = roomPrice;
        this.electricityPrice = electricityPrice;
        this.waterPrice = waterPrice;
        this.wifiPrice = wifiPrice;
        this.categoryRoomId = categoryRoomId;
        this.motelId = motelId;
        this.roomStatus = roomStatus;
        this.accountId = accountId;
        this.image = image;
        this.address = address;
        this.accountFullname = accountFullname;
        this.accountPhone = accountPhone;
        this.detailAddress = detailAddress;
        this.ward = ward;
        this.district = district;
        this.city = city;
        this.province = province;
        this.category = category;
        this.isFavorite = isFavorite;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public MotelRoom(int motelRoomId, Date createDate, String description, double length, double width, double roomPrice, double electricityPrice, double waterPrice, double wifiPrice, int categoryRoomId, int motelId, boolean roomStatus, int accountId, List<String> image, String detailAddress, String ward, String district, String city, String province, boolean isFavorite) {
        this.motelRoomId = motelRoomId;
        this.createDate = createDate;
        this.description = description;
        this.length = length;
        this.width = width;
        this.roomPrice = roomPrice;
        this.electricityPrice = electricityPrice;
        this.waterPrice = waterPrice;
        this.wifiPrice = wifiPrice;
        this.categoryRoomId = categoryRoomId;
        this.motelId = motelId;
        this.roomStatus = roomStatus;
        this.accountId = accountId;
        this.image = image;
        this.detailAddress = detailAddress;
        this.ward = ward;
        this.district = district;
        this.city = city;
        this.province = province;
        this.isFavorite = isFavorite; // Khởi tạo trạng thái yêu thích
    }


    public boolean isFavorite() {
        return isFavorite;
    }

    public void setFavorite(boolean isFavorite) {
        this.isFavorite = isFavorite;
    }
    public String getDetailAddress() {
        return detailAddress;
    }

    public void setDetailAddress(String detailAddress) {
        this.detailAddress = detailAddress;
    }

    public String getWard() {
        return ward;
    }

    public void setWard(String ward) {
        this.ward = ward;
    }

    public String getDistrict() {
        return district;
    }

    public void setDistrict(String district) {
        this.district = district;
    }

    public String getCity() {
        return city;
    }

    public void setCity(String city) {
        this.city = city;
    }

    public String getProvince() {
        return province;
    }

    public void setProvince(String province) {
        this.province = province;
    }

    public List<String> getImage() {
        return image;
    }

    public void setImage(List<String> image) {
        this.image = image;
    }

    public String getCategory() {
        return category;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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

    public double getRoomPrice() {
        return roomPrice;
    }

    public void setRoomPrice(double roomPrice) {
        this.roomPrice = roomPrice;
    }

    public double getElectricityPrice() {
        return electricityPrice;
    }

    public void setElectricityPrice(double electricityPrice) {
        this.electricityPrice = electricityPrice;
    }

    public double getWaterPrice() {
        return waterPrice;
    }

    public void setWaterPrice(double waterPrice) {
        this.waterPrice = waterPrice;
    }

    public double getWifiPrice() {
        return wifiPrice;
    }

    public void setWifiPrice(double wifiPrice) {
        this.wifiPrice = wifiPrice;
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

    public boolean isRoomStatus() {
        return roomStatus;
    }

    public void setRoomStatus(boolean roomStatus) {
        this.roomStatus = roomStatus;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getAccountFullname() {
        return accountFullname;
    }

    public void setAccountFullname(String accountFullname) {
        this.accountFullname = accountFullname;
    }

    public String getAccountPhone() {
        return accountPhone;
    }

    public void setAccountPhone(String accountPhone) {
        this.accountPhone = accountPhone;
    }

}