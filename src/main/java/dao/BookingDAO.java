package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Booking;
import util.DBConnection;

public class BookingDAO {

    // Helper to map ResultSet with Joined data to Booking model
    private Booking mapBookingWithJoins(ResultSet rs) throws SQLException {
        Booking booking = new Booking();

        booking.setBookingId(rs.getInt("booking_id"));
        booking.setUserId(rs.getInt("user_id"));
        booking.setVehicleId(rs.getInt("vehicle_id"));
        booking.setPickupDate(rs.getDate("pickup_date"));
        booking.setReturnDate(rs.getDate("return_date"));
        booking.setPickupLocation(rs.getString("pickup_location"));
        booking.setDropLocation(rs.getString("drop_location"));
        booking.setRentalDays(rs.getInt("rental_days"));
        booking.setPricePerDay(rs.getDouble("price_per_day"));
        booking.setTotalAmount(rs.getDouble("total_amount"));
        booking.setBookingStatus(rs.getString("booking_status"));

        try {
            booking.setBookingDate(rs.getTimestamp("booking_date"));
        } catch (SQLException ignored) {}

        // Joined vehicle columns
        try {
            booking.setVehicleBrand(rs.getString("brand"));
            booking.setVehicleModel(rs.getString("model"));
            booking.setVehicleNumber(rs.getString("vehicle_number"));
            booking.setVehicleType(rs.getString("vehicle_type"));
            booking.setVehicleImagePath(rs.getString("image_path"));
        } catch (SQLException ignored) {}

        // Joined user columns
        try {
            booking.setUserName(rs.getString("user_name"));
            booking.setUserEmail(rs.getString("user_email"));
            booking.setUserPhone(rs.getString("user_phone"));
        } catch (SQLException ignored) {}

        // Joined payment status
        try {
            booking.setPaymentStatus(rs.getString("payment_status"));
        } catch (SQLException ignored) {}

        return booking;
    }

    // Create booking
    public boolean createBooking(Booking booking) {
        String checkSql =
                "SELECT COUNT(*) FROM bookings " +
                "WHERE vehicle_id = ? " +
                "AND booking_status IN ('PENDING', 'CONFIRMED') " +
                "AND pickup_date < ? " +
                "AND return_date > ?";

        String insertSql =
                "INSERT INTO bookings " +
                "(user_id, vehicle_id, pickup_date, return_date, " +
                "pickup_location, drop_location, rental_days, " +
                "price_per_day, total_amount, booking_status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setInt(1, booking.getVehicleId());
            checkPs.setDate(2, booking.getReturnDate());
            checkPs.setDate(3, booking.getPickupDate());

            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Conflict found
                }
            }

            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                insertPs.setInt(1, booking.getUserId());
                insertPs.setInt(2, booking.getVehicleId());
                insertPs.setDate(3, booking.getPickupDate());
                insertPs.setDate(4, booking.getReturnDate());
                insertPs.setString(5, booking.getPickupLocation());
                insertPs.setString(6, booking.getDropLocation());
                insertPs.setInt(7, booking.getRentalDays());
                insertPs.setDouble(8, booking.getPricePerDay());
                insertPs.setDouble(9, booking.getTotalAmount());
                insertPs.setString(10, booking.getBookingStatus() != null ? booking.getBookingStatus() : "PENDING");

                return insertPs.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get bookings of a particular customer with vehicle and payment info
    public List<Booking> getBookingsByUser(int userId) {
        List<Booking> bookings = new ArrayList<>();

        String sql =
                "SELECT b.*, " +
                "v.brand, v.model, v.vehicle_number, v.vehicle_type, v.image_path, " +
                "p.payment_status " +
                "FROM bookings b " +
                "LEFT JOIN vehicles v ON b.vehicle_id = v.vehicle_id " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "WHERE b.user_id = ? " +
                "ORDER BY b.booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    bookings.add(mapBookingWithJoins(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookings;
    }

    // Get all bookings with vehicle, customer, and payment info
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();

        String sql =
                "SELECT b.*, " +
                "v.brand, v.model, v.vehicle_number, v.vehicle_type, v.image_path, " +
                "u.name AS user_name, u.email AS user_email, u.phone AS user_phone, " +
                "p.payment_status " +
                "FROM bookings b " +
                "LEFT JOIN vehicles v ON b.vehicle_id = v.vehicle_id " +
                "LEFT JOIN users u ON b.user_id = u.user_id " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "ORDER BY b.booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapBookingWithJoins(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookings;
    }

    // Get active bookings (CONFIRMED) for staff dashboard
    public List<Booking> getActiveBookings() {
        List<Booking> bookings = new ArrayList<>();

        String sql =
                "SELECT b.*, " +
                "v.brand, v.model, v.vehicle_number, v.vehicle_type, v.image_path, " +
                "u.name AS user_name, u.email AS user_email, u.phone AS user_phone, " +
                "p.payment_status " +
                "FROM bookings b " +
                "LEFT JOIN vehicles v ON b.vehicle_id = v.vehicle_id " +
                "LEFT JOIN users u ON b.user_id = u.user_id " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "WHERE b.booking_status = 'CONFIRMED' " +
                "ORDER BY b.pickup_date ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                bookings.add(mapBookingWithJoins(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookings;
    }

    // Get booking by ID with complete details
    public Booking getBookingById(int bookingId) {
        String sql =
                "SELECT b.*, " +
                "v.brand, v.model, v.vehicle_number, v.vehicle_type, v.image_path, " +
                "u.name AS user_name, u.email AS user_email, u.phone AS user_phone, " +
                "p.payment_status " +
                "FROM bookings b " +
                "LEFT JOIN vehicles v ON b.vehicle_id = v.vehicle_id " +
                "LEFT JOIN users u ON b.user_id = u.user_id " +
                "LEFT JOIN payments p ON b.booking_id = p.booking_id " +
                "WHERE b.booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapBookingWithJoins(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // Update booking status
    public boolean updateBookingStatus(int bookingId, String status) {
        String sql = "UPDATE bookings SET booking_status = ? WHERE booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, bookingId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cancel booking
    public boolean cancelBooking(int bookingId, int userId) {
        String sql =
                "UPDATE bookings " +
                "SET booking_status = 'CANCELLED' " +
                "WHERE booking_id = ? " +
                "AND user_id = ? " +
                "AND booking_status IN ('PENDING', 'CONFIRMED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Check vehicle availability for selected dates
    public boolean isVehicleAvailable(int vehicleId, Date pickupDate, Date returnDate) {
        String sql =
                "SELECT COUNT(*) FROM bookings " +
                "WHERE vehicle_id = ? " +
                "AND booking_status IN ('PENDING', 'CONFIRMED') " +
                "AND pickup_date < ? " +
                "AND return_date > ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);
            ps.setDate(2, returnDate);
            ps.setDate(3, pickupDate);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}