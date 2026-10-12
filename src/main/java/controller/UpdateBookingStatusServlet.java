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

@WebServlet("/update-booking-status")
public class UpdateBookingStatusServlet extends HttpServlet {

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

        if (!"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        try {
            int bookingId =
                    Integer.parseInt(request.getParameter("bookingId"));

            String status =
                    request.getParameter("status");

            if (!"CONFIRMED".equals(status) &&
                !"REJECTED".equals(status)) {
                response.sendRedirect("admin-bookings");
                return;
            }

            boolean success =
                    bookingDAO.updateBookingStatus(
                            bookingId, status);

            if (success) {

                if ("CONFIRMED".equals(status)) {
                    NotificationUtil.notifyUser(
                            getBookingUserId(bookingId),
                            "Your booking #" + bookingId +
                            " has been approved. You can now proceed with payment.",
                            "BOOKING"
                    );
                } else {
                    NotificationUtil.notifyUser(
                            getBookingUserId(bookingId),
                            "Your booking #" + bookingId +
                            " has been rejected.",
                            "BOOKING"
                    );
                }
            }

            response.sendRedirect("admin-bookings");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin-bookings");
        }
    }

    private int getBookingUserId(int bookingId) {

        String sql =
                "SELECT user_id FROM bookings WHERE booking_id = ?";

        try (java.sql.Connection con =
                     util.DBConnection.getConnection();
             java.sql.PreparedStatement ps =
                     con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (java.sql.ResultSet rs =
                         ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return -1;
    }
}