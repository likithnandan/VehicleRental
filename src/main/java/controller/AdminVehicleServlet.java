package controller;

import java.io.IOException;
import java.util.List;

import dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Vehicle;

@WebServlet("/admin-vehicles")
public class AdminVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
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

        if (!"ADMIN".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        try {

            String action =
                    request.getParameter("action");


            // =========================
            // ADD VEHICLE
            // =========================

            if ("add".equals(action)) {

                request.getRequestDispatcher(
                        "/add-vehicle.jsp")
                        .forward(request, response);

                return;
            }


            // =========================
            // EDIT VEHICLE
            // =========================

            if ("edit".equals(action)) {

                String idParam =
                        request.getParameter("vehicleId");

                if (idParam == null ||
                    idParam.trim().isEmpty()) {

                    response.sendRedirect(
                            "admin-vehicles");
                    return;
                }

                int vehicleId;

                try {

                    vehicleId =
                            Integer.parseInt(idParam);

                } catch (NumberFormatException e) {

                    response.sendRedirect(
                            "admin-vehicles");
                    return;
                }

                if (vehicleId <= 0) {

                    response.sendRedirect(
                            "admin-vehicles");
                    return;
                }

                Vehicle vehicle =
                        vehicleDAO.getVehicleById(
                                vehicleId);

                if (vehicle == null) {

                    response.sendRedirect(
                            "admin-vehicles");
                    return;
                }

                request.setAttribute(
                        "vehicle",
                        vehicle);

                /*
                 * edit-vehicle.jsp is currently
                 * directly inside webapp, not WEB-INF.
                 */
                request.getRequestDispatcher(
                        "/edit-vehicle.jsp")
                        .forward(request, response);

                return;
            }


            // =========================
            // MANAGE VEHICLES
            // =========================

            List<Vehicle> vehicles =
                    vehicleDAO.getAllVehicles();

            request.setAttribute(
                    "vehicles",
                    vehicles);

            request.getRequestDispatcher(
                    "/admin-vehicles.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "admin-vehicles");
        }
    }
}