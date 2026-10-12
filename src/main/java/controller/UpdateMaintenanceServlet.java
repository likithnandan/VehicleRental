package controller;

import java.io.IOException;

import dao.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.NotificationUtil;

@WebServlet("/update-maintenance")
public class UpdateMaintenanceServlet extends HttpServlet {

    private MaintenanceDAO maintenanceDAO;

    @Override
    public void init() {
        maintenanceDAO = new MaintenanceDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
                (User) session.getAttribute("user");

        if (!"ADMIN".equals(user.getRole()) &&
            !"STAFF".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            int maintenanceId =
                    Integer.parseInt(
                            request.getParameter(
                                    "maintenanceId"));

            String status =
                    request.getParameter("status");

            double cost =
                    Double.parseDouble(
                            request.getParameter("cost"));

            String remarks =
                    request.getParameter("remarks");

            if (!"REPORTED".equals(status) &&
                !"IN_PROGRESS".equals(status) &&
                !"COMPLETED".equals(status)) {

                response.sendRedirect("maintenance");
                return;
            }

            if (cost < 0) {
                response.sendRedirect("maintenance");
                return;
            }

            int reportedBy =
                    maintenanceDAO.getReportedBy(
                            maintenanceId);

            boolean success =
                    maintenanceDAO.updateStatus(
                            maintenanceId,
                            status,
                            cost,
                            remarks);

            if (success &&
                "COMPLETED".equals(status)) {

                maintenanceDAO
                        .updateVehicleStatusIfCompleted(
                                maintenanceId);

                if (reportedBy > 0) {

                    NotificationUtil.notifyUser(
                            reportedBy,
                            "Maintenance #" +
                            maintenanceId +
                            " has been completed successfully.",
                            "MAINTENANCE"
                    );
                }
            }

            response.sendRedirect("maintenance");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("maintenance");
        }
    }
}