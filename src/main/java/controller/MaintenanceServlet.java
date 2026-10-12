package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import dao.MaintenanceDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Maintenance;
import model.User;

@WebServlet("/maintenance")
public class MaintenanceServlet extends HttpServlet {

    private MaintenanceDAO maintenanceDAO;

    @Override
    public void init() {
        maintenanceDAO = new MaintenanceDAO();
    }


    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equals(user.getRole()) &&
            !"STAFF".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        List<Maintenance> maintenanceList =
                maintenanceDAO.getAllMaintenance();

        dao.VehicleDAO vehicleDAO = new dao.VehicleDAO();
        request.setAttribute(
                "vehicles",
                vehicleDAO.getAllVehicles());

        request.setAttribute(
                "maintenanceList",
                maintenanceList);

        request.getRequestDispatcher(
                "/maintenance.jsp")
                .forward(request, response);
    }


    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (!"ADMIN".equals(user.getRole()) &&
            !"STAFF".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            int vehicleId =
                    Integer.parseInt(
                            request.getParameter("vehicleId"));

            String problemDescription =
                    request.getParameter(
                            "problemDescription");

            Date maintenanceDate =
                    Date.valueOf(
                            request.getParameter(
                                    "maintenanceDate"));

            double cost =
                    Double.parseDouble(
                            request.getParameter("cost"));

            String remarks =
                    request.getParameter("remarks");

            Maintenance maintenance =
                    new Maintenance();

            maintenance.setVehicleId(vehicleId);
            maintenance.setReportedBy(user.getUserId());
            maintenance.setProblemDescription(
                    problemDescription);
            maintenance.setMaintenanceDate(
                    maintenanceDate);
            maintenance.setCost(cost);
            maintenance.setRemarks(remarks);

            maintenanceDAO.addMaintenance(maintenance);

            response.sendRedirect("maintenance");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("maintenance");
        }
    }
}