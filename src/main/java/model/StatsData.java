package model;

public class StatsData {
    private int numberOfRenters;
    private int numberOfMotels;
    private int numberOfRooms;

    public StatsData(int numberOfRenters, int numberOfMotels, int numberOfRooms) {
        this.numberOfRenters = numberOfRenters;
        this.numberOfMotels = numberOfMotels;
        this.numberOfRooms = numberOfRooms;
    }

    // Getter và Setter
    public int getNumberOfRenters() {
        return numberOfRenters;
    }

    public void setNumberOfRenters(int numberOfRenters) {
        this.numberOfRenters = numberOfRenters;
    }

    public int getNumberOfMotels() {
        return numberOfMotels;
    }

    public void setNumberOfMotels(int numberOfMotels) {
        this.numberOfMotels = numberOfMotels;
    }

    public int getNumberOfRooms() {
        return numberOfRooms;
    }

    public void setNumberOfRooms(int numberOfRooms) {
        this.numberOfRooms = numberOfRooms;
    }
}
