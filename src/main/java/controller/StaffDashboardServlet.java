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

@WebServlet(urlPatterns = {"/staff", "/staff-dashboard"})
public class StaffDashboardServlet extends HttpServlet {

    private BookingDAO bookingDAO;

    @Override
    public void init() {
        bookingDAO = new BookingDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
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

        if (!"STAFF".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }

        List<Booking> activeBookings =
                bookingDAO.getActiveBookings();

        request.setAttribute(
                "activeBookings",
                activeBookings);

        request.getRequestDispatcher(
                "/staff-dashboard.jsp")
                .forward(request, response);
    }
}