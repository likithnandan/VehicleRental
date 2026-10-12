package controller;

import java.io.IOException;

import dao.ReportDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/reports")
public class ReportServlet extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() {

        reportDAO = new ReportDAO();
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


        if (!"ADMIN".equals(user.getRole())) {

            response.sendRedirect("index.jsp");
            return;
        }


        request.setAttribute(
                "totalCustomers",
                reportDAO.getTotalCustomers());


        request.setAttribute(
                "totalVehicles",
                reportDAO.getTotalVehicles());


        request.setAttribute(
                "availableVehicles",
                reportDAO.getAvailableVehicles());


        request.setAttribute(
                "rentedVehicles",
                reportDAO.getRentedVehicles());


        request.setAttribute(
                "maintenanceVehicles",
                reportDAO.getMaintenanceVehicles());


        request.setAttribute(
                "totalBookings",
                reportDAO.getTotalBookings());


        request.setAttribute(
                "pendingBookings",
                reportDAO.getPendingBookings());


        request.setAttribute(
                "completedBookings",
                reportDAO.getCompletedBookings());


        request.setAttribute(
                "totalRevenue",
                reportDAO.getTotalRevenue());


        request.getRequestDispatcher(
                "/reports.jsp")
                .forward(request, response);
    }
}