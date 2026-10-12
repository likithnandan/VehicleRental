package controller;

import java.io.IOException;
import java.sql.Date;

import dao.RentalReturnDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.NotificationUtil;

@WebServlet("/rental-return")
public class RentalReturnServlet extends HttpServlet {

    private RentalReturnDAO rentalReturnDAO;
    private dao.BookingDAO bookingDAO;

    @Override
    public void init() {
        rentalReturnDAO = new RentalReturnDAO();
        bookingDAO = new dao.BookingDAO();
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
        if (!"ADMIN".equals(user.getRole()) && !"STAFF".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
                String defaultTarget = "STAFF".equals(user.getRole()) ? "staff" : "admin-bookings";
                response.sendRedirect(defaultTarget);
                return;
            }

            int bookingId = Integer.parseInt(bookingIdParam.trim());
            model.Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking == null) {
                String defaultTarget = "STAFF".equals(user.getRole()) ? "staff" : "admin-bookings";
                response.sendRedirect(defaultTarget);
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/rental-return.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            String defaultTarget = "STAFF".equals(user.getRole()) ? "staff" : "admin-bookings";
            response.sendRedirect(defaultTarget);
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

        if (!"ADMIN".equals(user.getRole()) &&
            !"STAFF".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        String targetDashboard = "STAFF".equals(user.getRole()) ? "staff" : "admin-bookings";

        try {

            int bookingId =
                    Integer.parseInt(
                            request.getParameter("bookingId"));

            Date actualReturnDate =
                    Date.valueOf(
                            request.getParameter(
                                    "actualReturnDate"));

            String vehicleCondition =
                    request.getParameter(
                            "vehicleCondition");

            double damageCharge =
                    Double.parseDouble(
                            request.getParameter(
                                    "damageCharge"));

            String remarks =
                    request.getParameter("remarks");

            if (damageCharge < 0) {
                damageCharge = 0;
            }

            int customerId =
                    rentalReturnDAO.getBookingUserId(
                            bookingId);

            boolean success =
                    rentalReturnDAO.processReturn(
                            bookingId,
                            actualReturnDate,
                            vehicleCondition,
                            damageCharge,
                            remarks,
                            user.getUserId());

            if (success && customerId > 0) {

                NotificationUtil.notifyUser(
                        customerId,
                        "Booking #" +
                        bookingId +
                        " has been returned and completed successfully.",
                        "RETURN"
                );
            }

            response.sendRedirect(targetDashboard + (success ? "?success=return_processed" : "?error=return_failed"));

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(targetDashboard + "?error=return_failed");
        }
    }
}