package model;

import java.util.Date;

public class Account {
    private int accountId;
    private String role;
    private String phone;
    private String password;
    private boolean gender;
    private String fullname;
    private String email;
    private Date dob;
    private Date createDate;
    private String citizenId;
    private String avatar;
    private boolean active;

    // Constructors
    public Account() {}

    public Account(int accountId, String role, String phone, String password, boolean gender, String fullname, String email, Date dob, Date createDate, String citizenId, String avatar, boolean active) {
        this.accountId = accountId;
        this.role = role;
        this.phone = phone;
        this.password = password;
        this.gender = gender;
        this.fullname = fullname;
        this.email = email;
        this.dob = dob;
        this.createDate = createDate;
        this.citizenId = citizenId;
        this.avatar = avatar;
        this.active = active;
    }

    // Getter and Setter methods
    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
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

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(String citizenId) {
        this.citizenId = citizenId;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
