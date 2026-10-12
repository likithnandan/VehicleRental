package controller;

import java.io.IOException;
import java.util.List;

import dao.NotificationDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Notification;
import model.User;

@WebServlet("/notifications")
public class NotificationServlet extends HttpServlet {

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

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("user") == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        User user =
                (User) session.getAttribute("user");

        List<Notification> notifications =
                notificationDAO.getNotificationsByUser(
                        user.getUserId());

        int unreadCount =
                notificationDAO.getUnreadCount(
                        user.getUserId());

        request.setAttribute(
                "notifications",
                notifications);

        request.setAttribute(
                "unreadCount",
                unreadCount);

        request.getRequestDispatcher(
                "/notifications.jsp")
                .forward(request, response);
    }
}