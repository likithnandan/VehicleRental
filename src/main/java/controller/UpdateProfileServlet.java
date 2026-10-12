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

@WebServlet("/update-profile")
public class UpdateProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
                (User) session.getAttribute("user");

        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");

        if (name == null || name.trim().isEmpty()) {
            response.sendRedirect("profile?error=name");
            return;
        }

        if (phone == null ||
            !phone.matches("\\d{10}")) {

            response.sendRedirect("profile?error=phone");
            return;
        }

        if (address == null || address.trim().isEmpty()) {
            response.sendRedirect("profile?error=address");
            return;
        }

        name = name.trim();
        phone = phone.trim();
        address = address.trim();

        boolean success =
                userDAO.updateProfile(
                        user.getUserId(),
                        name,
                        phone,
                        address
                );

        if (success) {

            User updatedUser =
                    userDAO.getUserById(user.getUserId());

            session.setAttribute("user", updatedUser);

            response.sendRedirect("profile?success=updated");

        } else {

            response.sendRedirect("profile?error=update");
        }
    }
}