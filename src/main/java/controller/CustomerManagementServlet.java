package controller;

import java.io.IOException;
import java.util.List;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet(urlPatterns = {"/admin-customers", "/customer-management"})
public class CustomerManagementServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
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

        String action =
                request.getParameter("action");

        if ("block".equals(action) ||
            "unblock".equals(action)) {

            try {

                int userId =
                        Integer.parseInt(
                                request.getParameter("userId"));

                String status;

                if ("block".equals(action)) {
                    status = "BLOCKED";
                } else {
                    status = "ACTIVE";
                }

                userDAO.updateCustomerStatus(
                        userId,
                        status);

            } catch (Exception e) {

                e.printStackTrace();
            }

            response.sendRedirect("admin-customers");
            return;
        }

        List<User> customers =
                userDAO.getAllCustomers();

        request.setAttribute(
                "customers",
                customers);

        request.getRequestDispatcher(
                "/customer-management.jsp")
                .forward(request, response);
    }
}