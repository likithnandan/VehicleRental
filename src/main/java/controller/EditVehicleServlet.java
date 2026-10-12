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

@WebServlet("/edit-vehicle")
public class EditVehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            String idParam = request.getParameter("vehicleId");
            if (idParam == null || idParam.trim().isEmpty()) {
                response.sendRedirect("admin-vehicles");
                return;
            }

            int vehicleId = Integer.parseInt(idParam.trim());
            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

            if (vehicle == null) {
                response.sendRedirect("admin-vehicles");
                return;
            }

            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/edit-vehicle.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-vehicles");
        }
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

        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {

            int vehicleId =
                    Integer.parseInt(
                            request.getParameter("vehicleId"));

            String vehicleNumber =
                    request.getParameter("vehicleNumber");

            String brand =
                    request.getParameter("brand");

            String model =
                    request.getParameter("model");

            String vehicleType =
                    request.getParameter("vehicleType");

            String category =
                    request.getParameter("category");

            String fuelType =
                    request.getParameter("fuelType");

            String transmission =
                    request.getParameter("transmission");

            String seatsParam =
                    request.getParameter("seats");

            String priceParam =
                    request.getParameter("pricePerDay");

            String location =
                    request.getParameter("location");

            String status =
                    request.getParameter("status");

            String imagePath =
                    request.getParameter("imagePath");

            String description =
                    request.getParameter("description");

            if (vehicleId <= 0 ||
                vehicleNumber == null ||
                brand == null ||
                model == null ||
                vehicleType == null ||
                category == null ||
                fuelType == null ||
                transmission == null ||
                seatsParam == null ||
                priceParam == null ||
                location == null ||
                status == null) {

                response.sendRedirect(
                        "admin-vehicles?error=invalid");
                return;
            }

            vehicleNumber = vehicleNumber.trim();
            brand = brand.trim();
            model = model.trim();
            category = category.trim();
            location = location.trim();

            if (imagePath != null) {
                imagePath = imagePath.trim();
            }

            if (description != null) {
                description = description.trim();
            }

            if (vehicleNumber.isEmpty() ||
                brand.isEmpty() ||
                model.isEmpty() ||
                category.isEmpty() ||
                location.isEmpty()) {

                response.sendRedirect(
                        "admin-vehicles?error=empty");
                return;
            }

            if (!vehicleNumber.matches(
                    "^[A-Za-z0-9 -]{3,20}$")) {

                response.sendRedirect(
                        "admin-vehicles?error=vehiclenumber");
                return;
            }

            if (brand.length() < 2 ||
                brand.length() > 50) {

                response.sendRedirect(
                        "admin-vehicles?error=brand");
                return;
            }

            if (model.length() < 1 ||
                model.length() > 50) {

                response.sendRedirect(
                        "admin-vehicles?error=model");
                return;
            }

            if (!"CAR".equals(vehicleType) &&
                !"BIKE".equals(vehicleType) &&
                !"SCOOTER".equals(vehicleType)) {

                response.sendRedirect(
                        "admin-vehicles?error=type");
                return;
            }

            if (!"PETROL".equals(fuelType) &&
                !"DIESEL".equals(fuelType) &&
                !"ELECTRIC".equals(fuelType)) {

                response.sendRedirect(
                        "admin-vehicles?error=fuel");
                return;
            }

            if (!"MANUAL".equals(transmission) &&
                !"AUTOMATIC".equals(transmission)) {

                response.sendRedirect(
                        "admin-vehicles?error=transmission");
                return;
            }

            if (!"AVAILABLE".equals(status) &&
                !"BOOKED".equals(status) &&
                !"RENTED".equals(status) &&
                !"MAINTENANCE".equals(status)) {

                response.sendRedirect(
                        "admin-vehicles?error=status");
                return;
            }

            int seats =
                    Integer.parseInt(seatsParam);

            double pricePerDay =
                    Double.parseDouble(priceParam);

            if (seats < 1 || seats > 50) {

                response.sendRedirect(
                        "admin-vehicles?error=seats");
                return;
            }

            if (pricePerDay <= 0 ||
                pricePerDay > 100000) {

                response.sendRedirect(
                        "admin-vehicles?error=price");
                return;
            }

            if (imagePath != null &&
                imagePath.length() > 500) {

                response.sendRedirect(
                        "admin-vehicles?error=image");
                return;
            }

            if (description != null &&
                description.length() > 1000) {

                response.sendRedirect(
                        "admin-vehicles?error=description");
                return;
            }

            Vehicle vehicle =
                    new Vehicle();

            vehicle.setVehicleId(vehicleId);
            vehicle.setVehicleNumber(vehicleNumber);
            vehicle.setBrand(brand);
            vehicle.setModel(model);
            vehicle.setVehicleType(vehicleType);
            vehicle.setCategory(category);
            vehicle.setFuelType(fuelType);
            vehicle.setTransmission(transmission);
            vehicle.setSeats(seats);
            vehicle.setPricePerDay(pricePerDay);
            vehicle.setLocation(location);
            vehicle.setStatus(status);
            vehicle.setImagePath(imagePath);
            vehicle.setDescription(description);

            boolean success =
                    vehicleDAO.updateVehicle(vehicle);

            if (success) {
                response.sendRedirect(
                        "admin-vehicles");
            } else {
                response.sendRedirect(
                        "admin-vehicles?error=duplicate");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "admin-vehicles?error=number");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "admin-vehicles?error=invalid");
        }
    }
}