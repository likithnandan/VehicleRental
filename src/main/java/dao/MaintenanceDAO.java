package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Maintenance;
import util.DBConnection;

public class MaintenanceDAO {

    public boolean addMaintenance(Maintenance maintenance) {

        String insertSql =
                "INSERT INTO maintenance " +
                "(vehicle_id, reported_by, problem_description, " +
                "maintenance_date, cost, status, remarks) " +
                "VALUES (?, ?, ?, ?, ?, 'REPORTED', ?)";

        String vehicleSql =
                "UPDATE vehicles " +
                "SET status = 'MAINTENANCE' " +
                "WHERE vehicle_id = ?";

        try (Connection con =
                     DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try (PreparedStatement ps =
                         con.prepareStatement(insertSql);
                 PreparedStatement vehiclePs =
                         con.prepareStatement(vehicleSql)) {

                ps.setInt(1,
                        maintenance.getVehicleId());

                ps.setInt(2,
                        maintenance.getReportedBy());

                ps.setString(3,
                        maintenance.getProblemDescription());

                ps.setDate(4,
                        maintenance.getMaintenanceDate());

                ps.setDouble(5,
                        maintenance.getCost());

                ps.setString(6,
                        maintenance.getRemarks());

                int maintenanceResult =
                        ps.executeUpdate();

                vehiclePs.setInt(
                        1,
                        maintenance.getVehicleId());

                int vehicleResult =
                        vehiclePs.executeUpdate();

                if (maintenanceResult > 0 &&
                    vehicleResult > 0) {

                    con.commit();
                    return true;

                } else {

                    con.rollback();
                    return false;
                }

            } catch (Exception e) {

                con.rollback();
                e.printStackTrace();

                return false;
            }

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    public List<Maintenance> getAllMaintenance() {

        List<Maintenance> list =
                new ArrayList<>();

        String sql =
                "SELECT m.*, v.brand AS vehicle_brand, v.model AS vehicle_model, v.vehicle_number, u.name AS reported_by_name " +
                "FROM maintenance m " +
                "LEFT JOIN vehicles v ON m.vehicle_id = v.vehicle_id " +
                "LEFT JOIN users u ON m.reported_by = u.user_id " +
                "ORDER BY m.maintenance_id DESC";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql);
             ResultSet rs =
                     ps.executeQuery()) {

            while (rs.next()) {

                Maintenance maintenance =
                        new Maintenance();

                maintenance.setMaintenanceId(
                        rs.getInt("maintenance_id"));

                maintenance.setVehicleId(
                        rs.getInt("vehicle_id"));

                maintenance.setReportedBy(
                        rs.getInt("reported_by"));

                maintenance.setProblemDescription(
                        rs.getString(
                                "problem_description"));

                maintenance.setMaintenanceDate(
                        rs.getDate(
                                "maintenance_date"));

                maintenance.setCompletionDate(
                        rs.getDate(
                                "completion_date"));

                maintenance.setCost(
                        rs.getDouble("cost"));

                maintenance.setStatus(
                        rs.getString("status"));

                maintenance.setRemarks(
                        rs.getString("remarks"));

                maintenance.setVehicleBrand(
                        rs.getString("vehicle_brand"));

                maintenance.setVehicleModel(
                        rs.getString("vehicle_model"));

                maintenance.setVehicleNumber(
                        rs.getString("vehicle_number"));

                maintenance.setReportedByName(
                        rs.getString("reported_by_name"));

                list.add(maintenance);
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return list;
    }

    public Maintenance getMaintenanceById(int maintenanceId) {
        String sql =
                "SELECT m.*, v.brand AS vehicle_brand, v.model AS vehicle_model, v.vehicle_number, u.name AS reported_by_name " +
                "FROM maintenance m " +
                "LEFT JOIN vehicles v ON m.vehicle_id = v.vehicle_id " +
                "LEFT JOIN users u ON m.reported_by = u.user_id " +
                "WHERE m.maintenance_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Maintenance maintenance = new Maintenance();
                    maintenance.setMaintenanceId(rs.getInt("maintenance_id"));
                    maintenance.setVehicleId(rs.getInt("vehicle_id"));
                    maintenance.setReportedBy(rs.getInt("reported_by"));
                    maintenance.setProblemDescription(rs.getString("problem_description"));
                    maintenance.setMaintenanceDate(rs.getDate("maintenance_date"));
                    maintenance.setCompletionDate(rs.getDate("completion_date"));
                    maintenance.setCost(rs.getDouble("cost"));
                    maintenance.setStatus(rs.getString("status"));
                    maintenance.setRemarks(rs.getString("remarks"));
                    maintenance.setVehicleBrand(rs.getString("vehicle_brand"));
                    maintenance.setVehicleModel(rs.getString("vehicle_model"));
                    maintenance.setVehicleNumber(rs.getString("vehicle_number"));
                    maintenance.setReportedByName(rs.getString("reported_by_name"));
                    return maintenance;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateStatus(
            int maintenanceId,
            String status,
            double cost,
            String remarks) {

        String sql;

        if ("COMPLETED".equals(status)) {

            sql =
                "UPDATE maintenance " +
                "SET status = ?, cost = ?, remarks = ?, " +
                "completion_date = CURRENT_DATE " +
                "WHERE maintenance_id = ?";

        } else {

            sql =
                "UPDATE maintenance " +
                "SET status = ?, cost = ?, remarks = ? " +
                "WHERE maintenance_id = ?";
        }

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setDouble(2, cost);
            ps.setString(3, remarks);
            ps.setInt(4, maintenanceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    public boolean updateVehicleStatusIfCompleted(
            int maintenanceId) {

        String sql =
                "UPDATE vehicles v " +
                "JOIN maintenance m " +
                "ON v.vehicle_id = m.vehicle_id " +
                "SET v.status = 'AVAILABLE' " +
                "WHERE m.maintenance_id = ? " +
                "AND m.status = 'COMPLETED'";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            e.printStackTrace();

            return false;
        }
    }

    public int getReportedBy(int maintenanceId) {

        String sql =
                "SELECT reported_by " +
                "FROM maintenance " +
                "WHERE maintenance_id = ?";

        try (Connection con =
                     DBConnection.getConnection();
             PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, maintenanceId);

            try (ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("reported_by");
                }
            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        return -1;
    }
}