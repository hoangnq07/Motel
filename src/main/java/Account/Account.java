package Account;

import dao.AccountDAO;

import java.io.Serializable;
import java.sql.Date;

public class Account implements Serializable {

    private int accountId;
    private boolean active;
    private String avatar;
    private String citizenId;
    private Date createDate;
    private Date dob;
    private String email;
    private String fullname;
    private boolean gender;
    private String password;
    private String phone;
    private String role;

    public Account() {
    }

    public Account(String email, String password, boolean gender, String phone) {
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.phone = phone;
    }
     public Account(String email, String role) {
        this.email = email;
        this.role = role;
    }

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

    public Account(String email, String pass, String phone) {
        this.email = email;
        this.password = pass;
        this.phone = phone;
    }

    public int getAccountId() {
        return accountId;
    }

    public void setAccountId(int accountId) {
        this.accountId = accountId;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getAvatar() {
        return avatar;
    }

    public void setAvatar(String avatar) {
        this.avatar = avatar;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public boolean isGender() {
        return gender;
    }

    public void setGender(boolean gender) {
        this.gender = gender;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public String getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(String citizenId) {
        this.citizenId = citizenId;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public boolean registerUser() {
        return AccountDAO.registerUser(this);
    }

    public boolean updateUser() {
        return AccountDAO.updateUser(this);
    }

}
