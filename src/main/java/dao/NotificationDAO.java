package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Notification;
import util.DBConnection;

public class NotificationDAO {

    public boolean createNotification(int userId, String message, String notificationType) {

        String sql =
                "INSERT INTO notifications " +
                "(user_id, message, notification_type, is_read) " +
                "VALUES (?, ?, ?, FALSE)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, message);
            ps.setString(3, notificationType);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Notification> getNotificationsByUser(int userId) {

        List<Notification> list = new ArrayList<>();

        String sql =
                "SELECT * FROM notifications " +
                "WHERE user_id = ? " +
                "ORDER BY created_at DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Notification notification = new Notification();

                    notification.setNotificationId(
                            rs.getInt("notification_id"));

                    notification.setUserId(
                            rs.getInt("user_id"));

                    notification.setMessage(
                            rs.getString("message"));

                    notification.setNotificationType(
                            rs.getString("notification_type"));

                    notification.setRead(
                            rs.getBoolean("is_read"));

                    notification.setCreatedAt(
                            rs.getTimestamp("created_at"));

                    list.add(notification);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public int getUnreadCount(int userId) {

        String sql =
                "SELECT COUNT(*) FROM notifications " +
                "WHERE user_id = ? AND is_read = FALSE";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public boolean markAsRead(int notificationId, int userId) {

        String sql =
                "UPDATE notifications " +
                "SET is_read = TRUE " +
                "WHERE notification_id = ? AND user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, notificationId);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean markAllAsRead(int userId) {

        String sql =
                "UPDATE notifications " +
                "SET is_read = TRUE " +
                "WHERE user_id = ? AND is_read = FALSE";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            return ps.executeUpdate() >= 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}