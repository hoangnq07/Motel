package model;

public class RevenueData {
    private int month;
    private double totalRevenue;

    public RevenueData(int month, double totalRevenue) {
        this.month = month;
        this.totalRevenue = totalRevenue;
    }

    // Getters and setters
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
}
