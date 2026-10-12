package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Vehicle;
import util.DBConnection;

public class VehicleDAO {

    // Helper to map ResultSet to Vehicle model
    private Vehicle mapVehicle(ResultSet rs) throws SQLException {
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(rs.getInt("vehicle_id"));
        vehicle.setVehicleNumber(rs.getString("vehicle_number"));
        vehicle.setBrand(rs.getString("brand"));
        vehicle.setModel(rs.getString("model"));
        vehicle.setVehicleType(rs.getString("vehicle_type"));
        vehicle.setCategory(rs.getString("category"));
        vehicle.setFuelType(rs.getString("fuel_type"));
        vehicle.setTransmission(rs.getString("transmission"));
        vehicle.setSeats(rs.getInt("seats"));
        vehicle.setPricePerDay(rs.getDouble("price_per_day"));
        vehicle.setLocation(rs.getString("location"));
        vehicle.setStatus(rs.getString("status"));
        vehicle.setImagePath(rs.getString("image_path"));
        vehicle.setDescription(rs.getString("description"));
        return vehicle;
    }

    // Get all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM vehicles ORDER BY vehicle_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vehicles.add(mapVehicle(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    // Get available vehicles
    public List<Vehicle> getAvailableVehicles() {
        List<Vehicle> vehicles = new ArrayList<>();
        String sql = "SELECT * FROM vehicles WHERE status = 'AVAILABLE' ORDER BY vehicle_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                vehicles.add(mapVehicle(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return vehicles;
    }

    // Add vehicle with image path and status
    public boolean addVehicle(Vehicle vehicle) {
        String sql =
                "INSERT INTO vehicles " +
                "(vehicle_number, brand, model, vehicle_type, category, " +
                "fuel_type, transmission, seats, price_per_day, " +
                "location, status, image_path, description) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String status = vehicle.getStatus() != null && !vehicle.getStatus().trim().isEmpty()
                    ? vehicle.getStatus()
                    : "AVAILABLE";

            ps.setString(1, vehicle.getVehicleNumber());
            ps.setString(2, vehicle.getBrand());
            ps.setString(3, vehicle.getModel());
            ps.setString(4, vehicle.getVehicleType());
            ps.setString(5, vehicle.getCategory());
            ps.setString(6, vehicle.getFuelType());
            ps.setString(7, vehicle.getTransmission());
            ps.setInt(8, vehicle.getSeats());
            ps.setDouble(9, vehicle.getPricePerDay());
            ps.setString(10, vehicle.getLocation());
            ps.setString(11, status);
            ps.setString(12, vehicle.getImagePath());
            ps.setString(13, vehicle.getDescription());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update vehicle including status and image path
    public boolean updateVehicle(Vehicle vehicle) {
        String sql =
                "UPDATE vehicles SET " +
                "vehicle_number = ?, " +
                "brand = ?, " +
                "model = ?, " +
                "vehicle_type = ?, " +
                "category = ?, " +
                "fuel_type = ?, " +
                "transmission = ?, " +
                "seats = ?, " +
                "price_per_day = ?, " +
                "location = ?, " +
                "status = ?, " +
                "image_path = ?, " +
                "description = ? " +
                "WHERE vehicle_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            String status = vehicle.getStatus() != null && !vehicle.getStatus().trim().isEmpty()
                    ? vehicle.getStatus()
                    : "AVAILABLE";

            ps.setString(1, vehicle.getVehicleNumber());
            ps.setString(2, vehicle.getBrand());
            ps.setString(3, vehicle.getModel());
            ps.setString(4, vehicle.getVehicleType());
            ps.setString(5, vehicle.getCategory());
            ps.setString(6, vehicle.getFuelType());
            ps.setString(7, vehicle.getTransmission());
            ps.setInt(8, vehicle.getSeats());
            ps.setDouble(9, vehicle.getPricePerDay());
            ps.setString(10, vehicle.getLocation());
            ps.setString(11, status);
            ps.setString(12, vehicle.getImagePath());
            ps.setString(13, vehicle.getDescription());
            ps.setInt(14, vehicle.getVehicleId());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update vehicle status
    public boolean updateVehicleStatus(int vehicleId, String status) {
        String sql = "UPDATE vehicles SET status = ? WHERE vehicle_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, vehicleId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get vehicle by ID
    public Vehicle getVehicleById(int vehicleId) {
        String sql = "SELECT * FROM vehicles WHERE vehicle_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapVehicle(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    // Delete vehicle with safety check
    public boolean deleteVehicle(int vehicleId) {
        // First check if active bookings exist
        String checkSql = "SELECT COUNT(*) FROM bookings WHERE vehicle_id = ? AND booking_status IN ('PENDING', 'CONFIRMED')";
        String deleteSql = "DELETE FROM vehicles WHERE vehicle_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setInt(1, vehicleId);
            try (ResultSet rs = checkPs.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    return false; // Active bookings exist
                }
            }

            try (PreparedStatement deletePs = con.prepareStatement(deleteSql)) {
                deletePs.setInt(1, vehicleId);
                return deletePs.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Search vehicles with filters and date-based conflict checking
    public List<Vehicle> searchVehicles(String keyword,
                                        String vehicleType,
                                        String location,
                                        Date pickupDate,
                                        Date returnDate) {

        List<Vehicle> vehicles = new ArrayList<>();

        StringBuilder sql = new StringBuilder();
        sql.append("SELECT v.* FROM vehicles v WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (v.brand LIKE ? OR v.model LIKE ? OR v.category LIKE ?) ");
        }

        if (vehicleType != null && !vehicleType.trim().isEmpty()) {
            sql.append("AND v.vehicle_type = ? ");
        }

        if (location != null && !location.trim().isEmpty()) {
            sql.append("AND v.location LIKE ? ");
        }

        // Only search available vehicles
        sql.append("AND v.status = 'AVAILABLE' ");

        // Check booking date overlap only when dates are provided
        if (pickupDate != null && returnDate != null) {
            sql.append("AND NOT EXISTS (")
               .append("SELECT 1 FROM bookings b ")
               .append("WHERE b.vehicle_id = v.vehicle_id ")
               .append("AND b.booking_status IN ('PENDING', 'CONFIRMED') ")
               .append("AND b.pickup_date < ? ")
               .append("AND b.return_date > ?")
               .append(") ");
        }

        sql.append("ORDER BY v.vehicle_id DESC");

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            int paramIndex = 1;

            if (keyword != null && !keyword.trim().isEmpty()) {
                String searchKeyword = "%" + keyword.trim() + "%";
                ps.setString(paramIndex++, searchKeyword);
                ps.setString(paramIndex++, searchKeyword);
                ps.setString(paramIndex++, searchKeyword);
            }

            if (vehicleType != null && !vehicleType.trim().isEmpty()) {
                ps.setString(paramIndex++, vehicleType.trim());
            }

            if (location != null && !location.trim().isEmpty()) {
                String searchLocation = "%" + location.trim() + "%";
                ps.setString(paramIndex++, searchLocation);
            }

            if (pickupDate != null && returnDate != null) {
                ps.setDate(paramIndex++, returnDate);
                ps.setDate(paramIndex++, pickupDate);
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    vehicles.add(mapVehicle(rs));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return vehicles;
    }
}