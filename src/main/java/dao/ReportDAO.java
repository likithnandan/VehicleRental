package dao;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class ReportDAO {

    public int getTotalCustomers() {

        return getCount(
                "SELECT COUNT(*) FROM users " +
                "WHERE role = 'CUSTOMER'");
    }


    public int getTotalVehicles() {

        return getCount(
                "SELECT COUNT(*) FROM vehicles");
    }


    public int getAvailableVehicles() {

        return getCount(
                "SELECT COUNT(*) FROM vehicles " +
                "WHERE status = 'AVAILABLE'");
    }


    public int getRentedVehicles() {

        return getCount(
                "SELECT COUNT(*) FROM vehicles " +
                "WHERE status = 'RENTED'");
    }


    public int getMaintenanceVehicles() {

        return getCount(
                "SELECT COUNT(*) FROM vehicles " +
                "WHERE status = 'MAINTENANCE'");
    }


    public int getTotalBookings() {

        return getCount(
                "SELECT COUNT(*) FROM bookings");
    }


    public int getPendingBookings() {

        return getCount(
                "SELECT COUNT(*) FROM bookings " +
                "WHERE booking_status = 'PENDING'");
    }


    public int getCompletedBookings() {

        return getCount(
                "SELECT COUNT(*) FROM bookings " +
                "WHERE booking_status = 'COMPLETED'");
    }


    public double getTotalRevenue() {

        String sql =
                "SELECT COALESCE(SUM(amount), 0) " +
                "FROM payments " +
                "WHERE payment_status = 'PAID'";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs =
                     ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }


    private int getCount(String sql) {

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs =
                     ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return 0;
    }
}