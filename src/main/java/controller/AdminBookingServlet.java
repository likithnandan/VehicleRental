package controller;

import dao.BookingDAO;
import model.Booking;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-bookings")
public class AdminBookingServlet extends HttpServlet {

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

        if (!"ADMIN".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        List<Booking> bookings =
                bookingDAO.getAllBookings();

        request.setAttribute("bookings", bookings);

        request.getRequestDispatcher("/admin-bookings.jsp")
               .forward(request, response);
    }
}