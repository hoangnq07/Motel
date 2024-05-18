package Account;

import dao.AccountDAO;
import java.io.Serializable;
import java.sql.Date;

public class User implements Serializable {

    private int accountId;
    private boolean active;
    private String avatar;
    private String citizen;
    private Date createDate;
    private String email;
    private String fullname;
    private boolean gender;
    private String password;
    private String phone;
    private String role;

    public User() {
    }

    public User(String email, String password, boolean gender, String phone) {
        this.email = email;
        this.password = password;
        this.gender = gender;
        this.phone = phone;
    }
     public User(String email, String role) {
        this.email = email;
        this.role = role;
    }
    public User(int accountId, boolean active, String avatar, String citizen, Date createDate, String email, String fullname, boolean gender, String password, String phone, String role) {
        this.accountId = accountId;
        this.active = active;
        this.avatar = avatar;
        this.citizen = citizen;
        this.createDate = createDate;
        this.email = email;
        this.fullname = fullname;
        this.gender = gender;
        this.password = password;
        this.phone = phone;
        this.role = role;
    }

    public User(String email, String pass, String phone) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
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

    public String getCitizen() {
        return citizen;
    }

    public void setCitizen(String citizen) {
        this.citizen = citizen;
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
