package model;

import java.sql.Date;

public class RentalReturn {

    private int returnId;
    private int bookingId;
    private Date actualReturnDate;
    private String vehicleCondition;
    private int lateDays;
    private double lateFee;
    private double damageCharge;
    private double finalAmount;
    private String remarks;
    private int processedBy;
    private String processedByName;

    public RentalReturn() {
    }

    public RentalReturn(int returnId, int bookingId, Date actualReturnDate, String vehicleCondition,
                        int lateDays, double lateFee, double damageCharge, double finalAmount,
                        String remarks, int processedBy) {
        this.returnId = returnId;
        this.bookingId = bookingId;
        this.actualReturnDate = actualReturnDate;
        this.vehicleCondition = vehicleCondition;
        this.lateDays = lateDays;
        this.lateFee = lateFee;
        this.damageCharge = damageCharge;
        this.finalAmount = finalAmount;
        this.remarks = remarks;
        this.processedBy = processedBy;
    }

    public int getReturnId() {
        return returnId;
    }

    public void setReturnId(int returnId) {
        this.returnId = returnId;
    }

    public int getBookingId() {
        return bookingId;
    }

    public void setBookingId(int bookingId) {
        this.bookingId = bookingId;
    }

    public Date getActualReturnDate() {
        return actualReturnDate;
    }

    public void setActualReturnDate(Date actualReturnDate) {
        this.actualReturnDate = actualReturnDate;
    }

    public String getVehicleCondition() {
        return vehicleCondition;
    }

    public void setVehicleCondition(String vehicleCondition) {
        this.vehicleCondition = vehicleCondition;
    }

    public int getLateDays() {
        return lateDays;
    }

    public void setLateDays(int lateDays) {
        this.lateDays = lateDays;
    }

    public double getLateFee() {
        return lateFee;
    }

    public void setLateFee(double lateFee) {
        this.lateFee = lateFee;
    }

    public double getDamageCharge() {
        return damageCharge;
    }

    public void setDamageCharge(double damageCharge) {
        this.damageCharge = damageCharge;
    }

    public double getFinalAmount() {
        return finalAmount;
    }

    public void setFinalAmount(double finalAmount) {
        this.finalAmount = finalAmount;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public int getProcessedBy() {
        return processedBy;
    }

    public void setProcessedBy(int processedBy) {
        this.processedBy = processedBy;
    }

    public String getProcessedByName() {
        return processedByName;
    }

    public void setProcessedByName(String processedByName) {
        this.processedByName = processedByName;
    }
}
