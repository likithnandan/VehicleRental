package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.User;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name =
                request.getParameter("name");

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        String phone =
                request.getParameter("phone");

        String address =
                request.getParameter("address");

        if (name != null) {
            name = name.trim();
        }

        if (email != null) {
            email = email.trim().toLowerCase();
        }

        if (phone != null) {
            phone = phone.trim();
        }

        if (address != null) {
            address = address.trim();
        }

        if (name == null ||
            name.length() < 2 ||
            name.length() > 50 ||
            !name.matches("^[A-Za-z .'-]+$")) {

            response.sendRedirect(
                    "register.jsp?error=2");
            return;
        }

        if (email == null ||
            email.length() > 100 ||
            !email.matches(
                    "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            response.sendRedirect(
                    "register.jsp?error=2");
            return;
        }

        if (password == null ||
            password.length() < 6 ||
            password.length() > 100) {

            response.sendRedirect(
                    "register.jsp?error=2");
            return;
        }

        if (phone == null ||
            !phone.matches("^[0-9]{10}$")) {

            response.sendRedirect(
                    "register.jsp?error=2");
            return;
        }

        if (address == null ||
            address.length() < 5 ||
            address.length() > 255) {

            response.sendRedirect(
                    "register.jsp?error=2");
            return;
        }

        User user = new User();

        user.setName(name);
        user.setEmail(email);
        user.setPassword(password);
        user.setPhone(phone);
        user.setAddress(address);
        user.setRole("CUSTOMER");
        user.setStatus("ACTIVE");

        boolean success =
                userDAO.registerUser(user);

        if (success) {

            response.sendRedirect("login.jsp");

        } else {

            response.sendRedirect(
                    "register.jsp?error=1");
        }
    }
}