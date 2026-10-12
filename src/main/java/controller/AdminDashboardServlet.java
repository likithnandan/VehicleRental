package controller;

import java.io.IOException;
import java.util.List;

import dao.BookingDAO;
import dao.PaymentDAO;
import dao.UserDAO;
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

@WebServlet("/admin")
public class AdminDashboardServlet extends HttpServlet {

    private VehicleDAO vehicleDAO;
    private BookingDAO bookingDAO;
    private UserDAO userDAO;
    private PaymentDAO paymentDAO;

    @Override
    public void init() {
        vehicleDAO = new VehicleDAO();
        bookingDAO = new BookingDAO();
        userDAO = new UserDAO();
        paymentDAO = new PaymentDAO();
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

        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        List<Vehicle> vehicles = vehicleDAO.getAllVehicles();
        List<Booking> allBookings = bookingDAO.getAllBookings();
        List<User> customers = userDAO.getAllCustomers();

        long availableVehicles = vehicles.stream()
                .filter(v -> "AVAILABLE".equalsIgnoreCase(v.getStatus()))
                .count();

        long activeRentals = allBookings.stream()
                .filter(b -> "CONFIRMED".equalsIgnoreCase(b.getBookingStatus()))
                .count();

        long pendingApprovals = allBookings.stream()
                .filter(b -> "PENDING".equalsIgnoreCase(b.getBookingStatus()))
                .count();

        double totalRevenue = allBookings.stream()
                .filter(b -> "COMPLETED".equalsIgnoreCase(b.getBookingStatus()) || "CONFIRMED".equalsIgnoreCase(b.getBookingStatus()))
                .mapToDouble(Booking::getTotalAmount)
                .sum();

        List<Booking> recentBookings = allBookings.stream()
                .limit(6)
                .toList();

        request.setAttribute("totalVehicles", vehicles.size());
        request.setAttribute("availableVehicles", availableVehicles);
        request.setAttribute("activeRentals", activeRentals);
        request.setAttribute("pendingApprovals", pendingApprovals);
        request.setAttribute("totalCustomers", customers.size());
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("recentBookings", recentBookings);

        request.getRequestDispatcher("/admin-dashboard.jsp")
               .forward(request, response);
    }
}