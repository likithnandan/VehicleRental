package controller;

import java.io.IOException;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import util.NotificationUtil;

@WebServlet("/cancel-booking")
public class CancelBookingServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
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

        try {

            String bookingIdParam =
                    request.getParameter("bookingId");

            if (bookingIdParam == null ||
                bookingIdParam.trim().isEmpty()) {

                response.sendRedirect("booking-history");
                return;
            }

            int bookingId =
                    Integer.parseInt(bookingIdParam);

            boolean success =
                    bookingDAO.cancelBooking(
                            bookingId,
                            user.getUserId());

            if (success) {

                NotificationUtil.notifyUser(
                        user.getUserId(),
                        "Your booking #" +
                        bookingId +
                        " has been cancelled successfully.",
                        "BOOKING"
                );
            }

            response.sendRedirect("booking-history");

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect("booking-history");
        }
    }
}