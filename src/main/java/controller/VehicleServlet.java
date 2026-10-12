package controller;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Vehicle;

@WebServlet("/vehicles")
public class VehicleServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String vehicleType = request.getParameter("vehicleType");
        String location = request.getParameter("location");

        String pickupDateString = request.getParameter("pickupDate");
        String returnDateString = request.getParameter("returnDate");

        Date pickupDate = null;
        Date returnDate = null;

        // Convert pickup date
        try {
            if (pickupDateString != null &&
                !pickupDateString.trim().isEmpty()) {

                pickupDate = Date.valueOf(pickupDateString);
            }

            // Convert return date
            if (returnDateString != null &&
                !returnDateString.trim().isEmpty()) {

                returnDate = Date.valueOf(returnDateString);
            }

        } catch (IllegalArgumentException e) {

            request.setAttribute(
                "error",
                "Invalid date format."
            );

            pickupDate = null;
            returnDate = null;
        }

        // Check date order
        if (pickupDate != null &&
            returnDate != null &&
            returnDate.before(pickupDate)) {

            request.setAttribute(
                "error",
                "Return date must be after pickup date."
            );

            pickupDate = null;
            returnDate = null;
        }

        List<Vehicle> vehicles;

        // Check whether any filter is used
        boolean noFilters =
                (keyword == null || keyword.trim().isEmpty())
                && (vehicleType == null || vehicleType.trim().isEmpty())
                && (location == null || location.trim().isEmpty())
                && pickupDate == null
                && returnDate == null;

        if (noFilters) {

            // Display all vehicles
            vehicles = vehicleDAO.getAllVehicles();

        } else {

            // Search with filters and date-wise availability
            vehicles = vehicleDAO.searchVehicles(
                    keyword,
                    vehicleType,
                    location,
                    pickupDate,
                    returnDate
            );
        }

        // Send vehicle list to JSP
        request.setAttribute("vehicles", vehicles);

        // Keep search values in the form
        request.setAttribute("keyword", keyword);
        request.setAttribute("vehicleType", vehicleType);
        request.setAttribute("location", location);
        request.setAttribute("pickupDate", pickupDateString);
        request.setAttribute("returnDate", returnDateString);

        // Open vehicles.jsp
        request.getRequestDispatcher(
                "/vehicles.jsp"
        ).forward(request, response);
    }
}