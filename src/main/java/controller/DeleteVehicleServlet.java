package controller;

import java.io.IOException;

import dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import model.Vehicle;

@WebServlet("/delete-vehicle")
public class DeleteVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
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

            String idParam =
                    request.getParameter("vehicleId");

            if (idParam == null ||
                idParam.trim().isEmpty()) {

                response.sendRedirect(
                        "admin-vehicles");
                return;
            }

            int vehicleId =
                    Integer.parseInt(idParam);

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

            if ("BOOKED".equals(vehicle.getStatus()) ||
                "RENTED".equals(vehicle.getStatus())) {

                response.sendRedirect(
                        "admin-vehicles?error=inuse");
                return;
            }

            boolean success =
                    vehicleDAO.deleteVehicle(
                            vehicleId);

            if (success) {

                response.sendRedirect(
                        "admin-vehicles");

            } else {

                response.sendRedirect(
                        "admin-vehicles?error=delete");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "admin-vehicles?error=delete");
        }
    }
}