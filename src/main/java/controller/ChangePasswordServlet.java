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

@WebServlet("/change-password")
public class ChangePasswordServlet extends HttpServlet {

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

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (currentPassword == null ||
            currentPassword.isEmpty()) {

            response.sendRedirect(
                    "profile?error=currentpassword");

            return;
        }

        if (newPassword == null ||
            newPassword.length() < 6) {

            response.sendRedirect(
                    "profile?error=shortpassword");

            return;
        }

        if (!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    "profile?error=passwordmatch");

            return;
        }

        if (currentPassword.equals(newPassword)) {

            response.sendRedirect(
                    "profile?error=samepassword");

            return;
        }

        boolean success =
                userDAO.changePassword(
                        user.getUserId(),
                        currentPassword,
                        newPassword
                );

        if (success) {

            response.sendRedirect(
                    "profile?success=password");

        } else {

            response.sendRedirect(
                    "profile?error=wrongpassword");
        }
    }
}