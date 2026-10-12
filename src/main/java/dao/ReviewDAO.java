package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import util.DBConnection;

public class ReviewDAO {

    public boolean addReview(int userId,
                             int vehicleId,
                             int bookingId,
                             int rating,
                             String comment) {

        String checkSql =
                "SELECT COUNT(*) FROM bookings " +
                "WHERE booking_id = ? " +
                "AND user_id = ? " +
                "AND vehicle_id = ? " +
                "AND booking_status = 'COMPLETED'";

        String insertSql =
                "INSERT INTO reviews " +
                "(user_id, vehicle_id, booking_id, rating, comment) " +
                "VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection()) {

            try (PreparedStatement ps =
                         con.prepareStatement(checkSql)) {

                ps.setInt(1, bookingId);
                ps.setInt(2, userId);
                ps.setInt(3, vehicleId);

                var rs = ps.executeQuery();

                if (!rs.next() || rs.getInt(1) == 0) {
                    return false;
                }
            }

            try (PreparedStatement ps =
                         con.prepareStatement(insertSql)) {

                ps.setInt(1, userId);
                ps.setInt(2, vehicleId);
                ps.setInt(3, bookingId);
                ps.setInt(4, rating);
                ps.setString(5, comment);

                return ps.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean hasUserReviewed(int userId, int bookingId) {
        String sql = "SELECT COUNT(*) FROM reviews WHERE user_id = ? AND booking_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, bookingId);
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public java.util.List<model.Review> getReviewsByVehicle(int vehicleId) {
        java.util.List<model.Review> list = new java.util.ArrayList<>();
        String sql = "SELECT r.*, u.name AS user_name FROM reviews r " +
                     "LEFT JOIN users u ON r.user_id = u.user_id " +
                     "WHERE r.vehicle_id = ? " +
                     "ORDER BY r.review_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, vehicleId);

            try (var rs = ps.executeQuery()) {
                while (rs.next()) {
                    model.Review review = new model.Review();
                    review.setReviewId(rs.getInt("review_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setVehicleId(rs.getInt("vehicle_id"));
                    review.setBookingId(rs.getInt("booking_id"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setReviewDate(rs.getTimestamp("review_date"));
                    review.setUserName(rs.getString("user_name"));
                    list.add(review);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public double getAverageRating(int vehicleId) {
        String sql = "SELECT AVG(rating) FROM reviews WHERE vehicle_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (var rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0.0;
    }

    public java.util.List<model.Review> getAllReviews() {
        java.util.List<model.Review> list = new java.util.ArrayList<>();
        String sql = "SELECT r.*, u.name AS user_name FROM reviews r " +
                     "LEFT JOIN users u ON r.user_id = u.user_id " +
                     "ORDER BY r.review_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             var rs = ps.executeQuery()) {

            while (rs.next()) {
                model.Review review = new model.Review();
                review.setReviewId(rs.getInt("review_id"));
                review.setUserId(rs.getInt("user_id"));
                review.setVehicleId(rs.getInt("vehicle_id"));
                review.setBookingId(rs.getInt("booking_id"));
                review.setRating(rs.getInt("rating"));
                review.setComment(rs.getString("comment"));
                review.setReviewDate(rs.getTimestamp("review_date"));
                review.setUserName(rs.getString("user_name"));
                list.add(review);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}