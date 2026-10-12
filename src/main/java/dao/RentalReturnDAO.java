package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import util.DBConnection;

public class RentalReturnDAO {

    public int getBookingUserId(int bookingId) {

        String sql =
                "SELECT user_id " +
                "FROM bookings " +
                "WHERE booking_id = ?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }

    public boolean processReturn(
            int bookingId,
            java.sql.Date actualReturnDate,
            String vehicleCondition,
            double damageCharge,
            String remarks,
            int processedBy) {

        String bookingSql =
                "SELECT b.vehicle_id, b.return_date, " +
                "b.total_amount " +
                "FROM bookings b " +
                "WHERE b.booking_id = ? " +
                "AND b.booking_status = 'CONFIRMED'";

        String returnSql =
                "INSERT INTO rental_returns " +
                "(booking_id, actual_return_date, " +
                "vehicle_condition, late_days, late_fee, " +
                "damage_charge, final_amount, remarks, processed_by) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

        String bookingUpdateSql =
                "UPDATE bookings " +
                "SET booking_status = 'COMPLETED' " +
                "WHERE booking_id = ?";

        String vehicleUpdateSql =
                "UPDATE vehicles " +
                "SET status = 'AVAILABLE' " +
                "WHERE vehicle_id = ?";

        try (Connection con =
                     DBConnection.getConnection()) {

            con.setAutoCommit(false);

            int vehicleId;
            java.sql.Date expectedReturnDate;
            double bookingAmount;

            try (PreparedStatement ps =
                         con.prepareStatement(bookingSql)) {

                ps.setInt(1, bookingId);

                try (ResultSet rs =
                             ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    vehicleId =
                            rs.getInt("vehicle_id");

                    expectedReturnDate =
                            rs.getDate("return_date");

                    bookingAmount =
                            rs.getDouble("total_amount");
                }
            }

            long difference =
                    actualReturnDate.toLocalDate()
                            .toEpochDay()
                    -
                    expectedReturnDate.toLocalDate()
                            .toEpochDay();

            int lateDays =
                    difference > 0
                    ? (int) difference
                    : 0;

            double lateFee =
                    lateDays * 500.0;

            double finalAmount =
                    bookingAmount +
                    lateFee +
                    damageCharge;

            try (PreparedStatement ps =
                         con.prepareStatement(returnSql)) {

                ps.setInt(1, bookingId);
                ps.setDate(2, actualReturnDate);
                ps.setString(3, vehicleCondition);
                ps.setInt(4, lateDays);
                ps.setDouble(5, lateFee);
                ps.setDouble(6, damageCharge);
                ps.setDouble(7, finalAmount);
                ps.setString(8, remarks);
                ps.setInt(9, processedBy);

                if (ps.executeUpdate() <= 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps =
                         con.prepareStatement(
                                 bookingUpdateSql)) {

                ps.setInt(1, bookingId);

                if (ps.executeUpdate() <= 0) {
                    con.rollback();
                    return false;
                }
            }

            try (PreparedStatement ps =
                         con.prepareStatement(
                                 vehicleUpdateSql)) {

                ps.setInt(1, vehicleId);

                if (ps.executeUpdate() <= 0) {
                    con.rollback();
                    return false;
                }
            }

            con.commit();
            return true;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public model.RentalReturn getReturnByBookingId(int bookingId) {
        String sql = "SELECT r.*, u.name AS processed_by_name FROM rental_returns r " +
                     "LEFT JOIN users u ON r.processed_by = u.user_id " +
                     "WHERE r.booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    model.RentalReturn ret = new model.RentalReturn();
                    ret.setReturnId(rs.getInt("return_id"));
                    ret.setBookingId(rs.getInt("booking_id"));
                    ret.setActualReturnDate(rs.getDate("actual_return_date"));
                    ret.setVehicleCondition(rs.getString("vehicle_condition"));
                    ret.setLateDays(rs.getInt("late_days"));
                    ret.setLateFee(rs.getDouble("late_fee"));
                    ret.setDamageCharge(rs.getDouble("damage_charge"));
                    ret.setFinalAmount(rs.getDouble("final_amount"));
                    ret.setRemarks(rs.getString("remarks"));
                    ret.setProcessedBy(rs.getInt("processed_by"));
                    ret.setProcessedByName(rs.getString("processed_by_name"));
                    return ret;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.util.List<model.RentalReturn> getAllReturns() {
        java.util.List<model.RentalReturn> list = new java.util.ArrayList<>();
        String sql = "SELECT r.*, u.name AS processed_by_name FROM rental_returns r " +
                     "LEFT JOIN users u ON r.processed_by = u.user_id " +
                     "ORDER BY r.return_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                model.RentalReturn ret = new model.RentalReturn();
                ret.setReturnId(rs.getInt("return_id"));
                ret.setBookingId(rs.getInt("booking_id"));
                ret.setActualReturnDate(rs.getDate("actual_return_date"));
                ret.setVehicleCondition(rs.getString("vehicle_condition"));
                ret.setLateDays(rs.getInt("late_days"));
                ret.setLateFee(rs.getDouble("late_fee"));
                ret.setDamageCharge(rs.getDouble("damage_charge"));
                ret.setFinalAmount(rs.getDouble("final_amount"));
                ret.setRemarks(rs.getString("remarks"));
                ret.setProcessedBy(rs.getInt("processed_by"));
                ret.setProcessedByName(rs.getString("processed_by_name"));
                list.add(ret);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}