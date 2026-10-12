package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import model.Payment;
import util.DBConnection;

public class PaymentDAO {

    private Payment mapPayment(ResultSet rs) throws SQLException {
        Payment payment = new Payment();
        payment.setPaymentId(rs.getInt("payment_id"));
        payment.setBookingId(rs.getInt("booking_id"));
        payment.setAmount(rs.getDouble("amount"));
        payment.setPaymentMethod(rs.getString("payment_method"));
        payment.setPaymentDate(rs.getTimestamp("payment_date"));
        payment.setPaymentStatus(rs.getString("payment_status"));
        payment.setTransactionReference(rs.getString("transaction_reference"));
        return payment;
    }

    public boolean createPayment(int bookingId,
                                 int userId,
                                 String paymentMethod) {

        String checkSql =
                "SELECT b.total_amount " +
                "FROM bookings b " +
                "WHERE b.booking_id = ? " +
                "AND b.user_id = ? " +
                "AND b.booking_status = 'CONFIRMED' " +
                "AND NOT EXISTS (" +
                "SELECT 1 FROM payments p " +
                "WHERE p.booking_id = b.booking_id " +
                "AND p.payment_status = 'PAID')";

        String insertSql =
                "INSERT INTO payments " +
                "(booking_id, amount, payment_method, " +
                "payment_status, transaction_reference) " +
                "VALUES (?, ?, ?, 'PAID', ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs = con.prepareStatement(checkSql)) {

            checkPs.setInt(1, bookingId);
            checkPs.setInt(2, userId);

            ResultSet rs = checkPs.executeQuery();

            if (!rs.next()) {
                return false;
            }

            double amount = rs.getDouble("total_amount");
            String transactionReference = "TXN" + System.currentTimeMillis();

            try (PreparedStatement insertPs = con.prepareStatement(insertSql)) {
                insertPs.setInt(1, bookingId);
                insertPs.setDouble(2, amount);
                insertPs.setString(3, paymentMethod);
                insertPs.setString(4, transactionReference);

                return insertPs.executeUpdate() > 0;
            }

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Payment getPaymentByBookingId(int bookingId) {
        String sql = "SELECT * FROM payments WHERE booking_id = ? ORDER BY payment_id DESC LIMIT 1";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapPayment(rs);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean isBookingPaid(int bookingId) {
        String sql = "SELECT COUNT(*) FROM payments WHERE booking_id = ? AND payment_status = 'PAID'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return false;
    }

    public List<Payment> getAllPayments() {
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapPayment(rs));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return list;
    }
}