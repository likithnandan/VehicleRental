package controller;

import java.io.IOException;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;

@WebServlet("/mark-notification-read")
public class MarkNotificationReadServlet
        extends HttpServlet {

    private NotificationDAO notificationDAO;

    @Override
    public void init() {
        notificationDAO = new NotificationDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {
        doPost(request, response);
    }

    @Override
    protected void doPost(
            HttpServletRequest request,
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

        try {

            int notificationId =
                    Integer.parseInt(
                            request.getParameter(
                                    "notificationId"));

            notificationDAO.markAsRead(
                    notificationId,
                    user.getUserId());

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("notifications");
    }
}