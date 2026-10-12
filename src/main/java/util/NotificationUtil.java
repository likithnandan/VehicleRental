package util;

import dao.NotificationDAO;

public class NotificationUtil {

    private static final NotificationDAO notificationDAO =
            new NotificationDAO();

    public static void notifyUser(
            int userId,
            String message,
            String notificationType) {

        notificationDAO.createNotification(
                userId,
                message,
                notificationType
        );
    }
}