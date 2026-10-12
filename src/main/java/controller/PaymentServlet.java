package controller;

import java.io.IOException;

import dao.BookingDAO;
import dao.PaymentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;
import util.NotificationUtil;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {

    private PaymentDAO paymentDAO;
    private BookingDAO bookingDAO;

    @Override
    public void init() {
        paymentDAO = new PaymentDAO();
        bookingDAO = new BookingDAO();
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

            if (paymentDAO.isBookingPaid(bookingId)) {
                response.sendRedirect("booking-history?info=already_paid");
                return;
            }

            request.setAttribute("booking", booking);
            request.getRequestDispatcher("/payment.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("booking-history");
        }
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

        if (!"CUSTOMER".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {

            String bookingIdParam =
                    request.getParameter("bookingId");

            String paymentMethod =
                    request.getParameter("paymentMethod");

            if (bookingIdParam == null ||
                bookingIdParam.trim().isEmpty()) {

                response.sendRedirect("booking-history");
                return;
            }

            if (paymentMethod == null) {
                response.sendRedirect("booking-history");
                return;
            }

            paymentMethod =
                    paymentMethod.trim().toUpperCase();

            if (!"UPI".equals(paymentMethod) &&
                !"CARD".equals(paymentMethod) &&
                !"CASH".equals(paymentMethod)) {

                response.sendRedirect("booking-history");
                return;
            }

            int bookingId =
                    Integer.parseInt(bookingIdParam);

            if (bookingId <= 0) {
                response.sendRedirect("booking-history");
                return;
            }

            boolean success =
                    paymentDAO.createPayment(
                            bookingId,
                            user.getUserId(),
                            paymentMethod);

            if (success) {

                NotificationUtil.notifyUser(
                        user.getUserId(),
                        "Payment for booking #" +
                        bookingId +
                        " was successful.",
                        "PAYMENT"
                );

                response.sendRedirect(
                        "payment-success.jsp?bookingId="
                        + bookingId);

            } else {

                response.sendRedirect(
                        "booking-history");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    "booking-history");
        }
    }
}