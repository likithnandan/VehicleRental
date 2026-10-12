package controller;

import java.io.IOException;

import dao.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String email =
                request.getParameter("email");

        String password =
                request.getParameter("password");

        if (email != null) {
            email = email.trim().toLowerCase();
        }

        if (email == null ||
            email.isEmpty() ||
            email.length() > 100 ||
            !email.matches(
                    "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {

            response.sendRedirect(
                    "login.jsp?error=2");
            return;
        }

        if (password == null ||
            password.isEmpty() ||
            password.length() > 100) {

            response.sendRedirect(
                    "login.jsp?error=2");
            return;
        }

        User user =
                userDAO.loginUser(
                        email,
                        password);

        if (user != null) {

            HttpSession session =
                    request.getSession(true);

            session.setMaxInactiveInterval(
                    30 * 60);

            session.setAttribute(
                    "user",
                    user);

            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin");
            } else if ("STAFF".equals(user.getRole())) {
                response.sendRedirect("staff");
            } else {
                response.sendRedirect("index.jsp");
            }

        } else {

            response.sendRedirect(
                    "login.jsp?error=1");
        }
    }
}