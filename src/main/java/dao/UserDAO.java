package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.User;
import util.DBConnection;

public class UserDAO {

    public boolean registerUser(User user) {

        String sql =
                "INSERT INTO users " +
                "(name, email, password, phone, address, role, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, user.getName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPassword());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getAddress());
            ps.setString(6, user.getRole());
            ps.setString(7, user.getStatus());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User loginUser(String email, String password) {

        String sql =
                "SELECT * FROM users " +
                "WHERE email = ? " +
                "AND password = ? " +
                "AND status = 'ACTIVE'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setUserId(
                            rs.getInt("user_id"));

                    user.setName(
                            rs.getString("name"));

                    user.setEmail(
                            rs.getString("email"));

                    user.setPassword(
                            rs.getString("password"));

                    user.setPhone(
                            rs.getString("phone"));

                    user.setAddress(
                            rs.getString("address"));

                    user.setRole(
                            rs.getString("role"));

                    user.setStatus(
                            rs.getString("status"));

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public List<User> getAllCustomers() {

        List<User> list = new ArrayList<>();

        String sql =
                "SELECT * FROM users " +
                "WHERE role = 'CUSTOMER' " +
                "ORDER BY user_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                User user = new User();

                user.setUserId(
                        rs.getInt("user_id"));

                user.setName(
                        rs.getString("name"));

                user.setEmail(
                        rs.getString("email"));

                user.setPhone(
                        rs.getString("phone"));

                user.setAddress(
                        rs.getString("address"));

                user.setRole(
                        rs.getString("role"));

                user.setStatus(
                        rs.getString("status"));

                list.add(user);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public boolean updateCustomerStatus(
            int userId,
            String status) {

        if (!"ACTIVE".equals(status) &&
            !"BLOCKED".equals(status)) {
            return false;
        }

        String sql =
                "UPDATE users " +
                "SET status = ? " +
                "WHERE user_id = ? " +
                "AND role = 'CUSTOMER'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public User getUserById(int userId) {

        String sql =
                "SELECT * FROM users " +
                "WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    User user = new User();

                    user.setUserId(
                            rs.getInt("user_id"));

                    user.setName(
                            rs.getString("name"));

                    user.setEmail(
                            rs.getString("email"));

                    user.setPassword(
                            rs.getString("password"));

                    user.setPhone(
                            rs.getString("phone"));

                    user.setAddress(
                            rs.getString("address"));

                    user.setRole(
                            rs.getString("role"));

                    user.setStatus(
                            rs.getString("status"));

                    return user;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updateProfile(
            int userId,
            String name,
            String phone,
            String address) {

        String sql =
                "UPDATE users " +
                "SET name = ?, phone = ?, address = ? " +
                "WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, phone);
            ps.setString(3, address);
            ps.setInt(4, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean changePassword(
            int userId,
            String currentPassword,
            String newPassword) {

        String checkSql =
                "SELECT user_id FROM users " +
                "WHERE user_id = ? " +
                "AND password = ?";

        String updateSql =
                "UPDATE users " +
                "SET password = ? " +
                "WHERE user_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement checkPs =
                     con.prepareStatement(checkSql)) {

            checkPs.setInt(1, userId);
            checkPs.setString(2, currentPassword);

            try (ResultSet rs =
                         checkPs.executeQuery()) {

                if (!rs.next()) {
                    return false;
                }
            }

            try (PreparedStatement updatePs =
                         con.prepareStatement(updateSql)) {

                updatePs.setString(1, newPassword);
                updatePs.setInt(2, userId);

                return updatePs.executeUpdate() > 0;
            }

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}