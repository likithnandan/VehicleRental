package model;

public class Vehicle {

    private int vehicleId;
    private String vehicleNumber;
    private String brand;
    private String model;
    private String vehicleType;
    private String category;
    private String fuelType;
    private String transmission;
    private int seats;
    private double pricePerDay;
    private String location;
    private String status;
    private String imagePath;
    private String description;

    public Vehicle() {
    }

    public Vehicle(int vehicleId, String vehicleNumber, String brand, String model,
                   String vehicleType, String category, String fuelType,
                   String transmission, int seats, double pricePerDay,
                   String location, String status, String imagePath,
                   String description) {

        this.vehicleId = vehicleId;
        this.vehicleNumber = vehicleNumber;
        this.brand = brand;
        this.model = model;
        this.vehicleType = vehicleType;
        this.category = category;
        this.fuelType = fuelType;
        this.transmission = transmission;
        this.seats = seats;
        this.pricePerDay = pricePerDay;
        this.location = location;
        this.status = status;
        this.imagePath = imagePath;
        this.description = description;
    }

    public int getVehicleId() {
        return vehicleId;
    }

    public void setVehicleId(int vehicleId) {
        this.vehicleId = vehicleId;
    }

    public String getVehicleNumber() {
        return vehicleNumber;
    }

    public void setVehicleNumber(String vehicleNumber) {
        this.vehicleNumber = vehicleNumber;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public String getVehicleType() {
        return vehicleType;
    }

    public void setVehicleType(String vehicleType) {
        this.vehicleType = vehicleType;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getFuelType() {
        return fuelType;
    }

    public void setFuelType(String fuelType) {
        this.fuelType = fuelType;
    }

    public String getTransmission() {
        return transmission;
    }

    public void setTransmission(String transmission) {
        this.transmission = transmission;
    }

    public int getSeats() {
        return seats;
    }

    public void setSeats(int seats) {
        this.seats = seats;
    }

    public double getPricePerDay() {
        return pricePerDay;
    }

    public void setPricePerDay(double pricePerDay) {
        this.pricePerDay = pricePerDay;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getFullName() {
        if (brand != null && model != null) {
            return brand + " " + model;
        }
        return brand != null ? brand : "Vehicle #" + vehicleId;
    }
}