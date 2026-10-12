package controller;

import java.io.IOException;
import java.sql.Date;
import java.time.temporal.ChronoUnit;

import dao.BookingDAO;
import dao.VehicleDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import model.Vehicle;
import util.NotificationUtil;

@WebServlet("/book")
public class BookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
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

        if (!"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            String vehicleIdParam = request.getParameter("vehicleId");
            if (vehicleIdParam == null || vehicleIdParam.trim().isEmpty()) {
                response.sendRedirect("vehicles");
                return;
            }

            int vehicleId = Integer.parseInt(vehicleIdParam.trim());
            VehicleDAO vehicleDAO = new VehicleDAO();
            Vehicle vehicle = vehicleDAO.getVehicleById(vehicleId);

            if (vehicle == null) {
                response.sendRedirect("vehicles?error=vehicle");
                return;
            }

            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/booking.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("vehicles");
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

        try {

            String vehicleIdParam =
                    request.getParameter("vehicleId");

            String pickupDateParam =
                    request.getParameter("pickupDate");

            String returnDateParam =
                    request.getParameter("returnDate");

            String pickupLocation =
                    request.getParameter("pickupLocation");

            String dropLocation =
                    request.getParameter("dropLocation");

            if (vehicleIdParam == null ||
                pickupDateParam == null ||
                returnDateParam == null ||
                pickupLocation == null ||
                dropLocation == null) {

                response.sendRedirect(
                        "vehicles?error=invalidbooking");
                return;
            }

            pickupLocation = pickupLocation.trim();
            dropLocation = dropLocation.trim();

            if (pickupLocation.isEmpty() ||
                dropLocation.isEmpty()) {

                response.sendRedirect(
                        "vehicles?error=locations");
                return;
            }

            int vehicleId =
                    Integer.parseInt(vehicleIdParam);

            Date pickupDate =
                    Date.valueOf(pickupDateParam);

            Date returnDate =
                    Date.valueOf(returnDateParam);

            java.time.LocalDate today = java.time.LocalDate.now();
            java.time.LocalDate pDate = pickupDate.toLocalDate();
            java.time.LocalDate rDate = returnDate.toLocalDate();

            if (pDate.isBefore(today)) {

                response.sendRedirect(
                        "vehicles?error=pastdate");
                return;
            }

            if (!rDate.isAfter(pDate)) {

                response.sendRedirect(
                        "vehicles?error=invaliddates");
                return;
            }

            long days = ChronoUnit.DAYS.between(
                    pDate,
                    rDate);

            int rentalDays = (int) days;

            if (rentalDays <= 0) {

                response.sendRedirect(
                        "vehicles?error=dates");
                return;
            }

            boolean available =
                    bookingDAO.isVehicleAvailable(
                            vehicleId,
                            pickupDate,
                            returnDate);

            if (!available) {

                response.sendRedirect(
                        "vehicles?error=unavailable");
                return;
            }

            VehicleDAO vehicleDAO =
                    new VehicleDAO();

            Vehicle vehicle =
                    vehicleDAO.getVehicleById(vehicleId);

            if (vehicle == null) {

                response.sendRedirect(
                        "vehicles?error=vehicle");
                return;
            }

            double pricePerDay =
                    vehicle.getPricePerDay();

            if (pricePerDay <= 0) {

                response.sendRedirect(
                        "vehicles?error=price");
                return;
            }

            double totalAmount =
                    rentalDays * pricePerDay;

            Booking booking = new Booking();

            booking.setUserId(user.getUserId());
            booking.setVehicleId(vehicleId);
            booking.setPickupDate(pickupDate);
            booking.setReturnDate(returnDate);
            booking.setPickupLocation(pickupLocation);
            booking.setDropLocation(dropLocation);
            booking.setRentalDays(rentalDays);
            booking.setPricePerDay(pricePerDay);
            booking.setTotalAmount(totalAmount);
            booking.setBookingStatus("PENDING");

            boolean success =
                    bookingDAO.createBooking(booking);

            if (success) {

                NotificationUtil.notifyUser(
                        user.getUserId(),
                        "Your booking request for "
                        + vehicle.getBrand()
                        + " "
                        + vehicle.getModel()
                        + " has been submitted successfully. "
                        + "Booking is pending approval.",
                        "BOOKING"
                );

                response.sendRedirect(
                        "booking-success.jsp");

            } else {

                response.sendRedirect(
                        "vehicles?error=booking");
            }

        } catch (IllegalArgumentException e) {

            response.sendRedirect(
                    "vehicles?error=invalidbooking");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "vehicles?error=booking");
        }
    }
}