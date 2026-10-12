package controller;

import java.io.IOException;
import java.util.List;

import dao.BookingDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Booking;
import model.User;

@WebServlet("/booking-history")
public class BookingHistoryServlet extends HttpServlet {

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

        // Check login
        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
                (User) session.getAttribute("user");

        // Get customer's bookings
        List<Booking> bookings =
                bookingDAO.getBookingsByUser(
                        user.getUserId());

        request.setAttribute(
                "bookings",
                bookings);

        request.getRequestDispatcher(
                "/booking-history.jsp")
                .forward(request, response);
    }
}