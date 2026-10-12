package controller;

import java.io.IOException;

import dao.BookingDAO;
import dao.ReviewDAO;
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

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {

    private ReviewDAO reviewDAO;
    private BookingDAO bookingDAO;
    private VehicleDAO vehicleDAO;

    @Override
    public void init() {
        reviewDAO = new ReviewDAO();
        bookingDAO = new BookingDAO();
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
        if (!"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            String bookingIdParam = request.getParameter("bookingId");
            if (bookingIdParam == null || bookingIdParam.trim().isEmpty()) {
                response.sendRedirect("booking-history");
                return;
            }

            int bookingId = Integer.parseInt(bookingIdParam.trim());
            Booking booking = bookingDAO.getBookingById(bookingId);

            if (booking == null || booking.getUserId() != user.getUserId()) {
                response.sendRedirect("booking-history");
                return;
            }

            if (reviewDAO.hasUserReviewed(user.getUserId(), bookingId)) {
                response.sendRedirect("booking-history?info=already_reviewed");
                return;
            }

            Vehicle vehicle = vehicleDAO.getVehicleById(booking.getVehicleId());
            request.setAttribute("booking", booking);
            request.setAttribute("vehicle", vehicle);
            request.getRequestDispatcher("/review.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("booking-history");
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

        if (!"CUSTOMER".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        int bookingId = Integer.parseInt(
                request.getParameter("bookingId"));

        int vehicleId = Integer.parseInt(
                request.getParameter("vehicleId"));

        int rating = Integer.parseInt(
                request.getParameter("rating"));

        String comment =
                request.getParameter("comment");

        if (rating < 1 || rating > 5) {

            response.sendRedirect("booking-history");
            return;
        }

        boolean success = reviewDAO.addReview(
                user.getUserId(),
                vehicleId,
                bookingId,
                rating,
                comment);

        if (success) {

            response.sendRedirect(
                    "review-success.jsp?bookingId=" + bookingId);

        } else {

            response.sendRedirect("booking-history");
        }
    }
}