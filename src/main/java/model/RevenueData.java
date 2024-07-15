package model;

public class RevenueData {
    private int month;
    private double totalRevenue;
    private int year;  // Thêm biến năm nếu muốn

    public RevenueData(int month, double totalRevenue, int year) {
        this.month = month;
        this.totalRevenue = totalRevenue;
        this.year = year;
    }

    public int getMonth() {
        return month;
    }

    public void setMonth(int month) {
        this.month = month;
    }

    public double getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(double totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public int getYear() {
        return year;  // Getter cho năm
    }

    public void setYear(int year) {  // Setter cho năm
        this.year = year;
    }

    @Override
    public String toString() {
        return "Month: " + month + " - Total Revenue: " + totalRevenue + " - Year: " + year;
    }
}
