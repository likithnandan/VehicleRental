<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Notification" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Notification> notifications = (List<Notification>) request.getAttribute("notifications");
    if (notifications == null) {
        notifications = new java.util.ArrayList<Notification>();
    }

    Integer unreadCount = (Integer) request.getAttribute("unreadCount");
    if (unreadCount == null) {
        unreadCount = 0;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Notifications & Activity Alerts | Vehicle Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/app.js" defer></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="nav-brand">
        <div class="logo-mark">VR</div>
        <div>
            <strong>Vehicle Rental</strong>
            <span>Customer Portal</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
        <a href="${pageContext.request.contextPath}/notifications" class="active">
            Notifications
            <% if (unreadCount > 0) { %>
                <span class="nav-notification-count"><%= unreadCount %></span>
            <% } %>
        </a>
        <a href="${pageContext.request.contextPath}/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
                COMMUNICATIONS & SYSTEM DISPATCH
            </span>
            <h1>Activity Notifications</h1>
            <p>Real-time updates regarding your reservations, approval decisions, verified invoices, and return inspections.</p>
        </div>

        <div class="hero-buttons">
            <% if (unreadCount > 0) { %>
                <form action="${pageContext.request.contextPath}/mark-all-notifications-read" method="post" style="display: inline;">
                    <button type="submit" class="btn btn-secondary" style="border-color: var(--cyan); color: var(--cyan);">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        Mark All as Read (<%= unreadCount %>)
                    </button>
                </form>
            <% } %>
            <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-primary">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                My Bookings
            </a>
        </div>
    </header>

    <!-- NOTIFICATION TOOLBAR & FILTER -->
    <div class="filter-bar" style="margin-bottom: 24px;">
        <div class="filter-group">
            <button type="button" class="filter-btn active" onclick="filterNotifs('ALL', this)">All (<%= notifications.size() %>)</button>
            <button type="button" class="filter-btn" onclick="filterNotifs('UNREAD', this)">Unread (<%= unreadCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterNotifs('READ', this)">Read (<%= notifications.size() - unreadCount %>)</button>
        </div>
    </div>

    <!-- NOTIFICATION LIST -->
    <section id="notificationsContainer" style="display: flex; flex-direction: column; gap: 14px;">

    <%
        if (notifications.isEmpty()) {
    %>
        <div class="card empty-state">
            <div class="empty-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-light);">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path>
                    <path d="M13.73 21a2 2 0 0 1-3.46 0"></path>
                </svg>
            </div>
            <h3>No Notifications Yet</h3>
            <p>You do not have any alerts at this moment. Recent reservation status updates and payment receipts will appear here automatically.</p>
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">
                Browse Available Vehicles
            </a>
        </div>
    <%
        } else {
            for (Notification n : notifications) {
                boolean isUnread = !n.isRead();
                String type = n.getNotificationType() != null ? n.getNotificationType().toUpperCase() : "SYSTEM";

                String borderStyle = isUnread ? "border-color: rgba(99, 102, 241, 0.45); background: rgba(14, 23, 42, 0.85); box-shadow: 0 4px 20px rgba(99, 102, 241, 0.1);" : "border-color: var(--border-light); background: rgba(14, 23, 42, 0.45);";
    %>

        <article class="card notif-item card-hover"
                 data-read="<%= isUnread ? "UNREAD" : "READ" %>"
                 style="padding: 18px 24px; transition: transform 0.2s ease, border-color 0.2s ease; <%= borderStyle %>">

            <div style="display: flex; gap: 18px; align-items: flex-start;">

                <!-- ICON MARK WITH VECTOR SVG -->
                <div class="logo-mark" style="width: 44px; height: 44px; flex-shrink: 0; background: <%= isUnread ? "linear-gradient(135deg, var(--primary) 0%, #4338ca 100%)" : "rgba(255,255,255,0.04)" %>; border-color: <%= isUnread ? "rgba(99,102,241,0.5)" : "var(--border)" %>;">
                    <% if ("BOOKING".equals(type)) { %>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                    <% } else if ("PAYMENT".equals(type)) { %>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                    <% } else if ("RETURN".equals(type)) { %>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.5 2.8C2.1 10.8 2 11 2 11.2V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg>
                    <% } else if ("MAINTENANCE".equals(type)) { %>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/></svg>
                    <% } else { %>
                        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M18 8A6 6 0 0 0 6 8c0 7-3 9-3 9h18s-3-2-3-9"></path><path d="M13.73 21a2 2 0 0 1-3.46 0"></path></svg>
                    <% } %>
                </div>

                <!-- CONTENT -->
                <div style="flex: 1;">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 6px;">
                        <div style="display: flex; align-items: center; gap: 8px;">
                            <span style="font-size: 0.72rem; font-weight: 700; text-transform: uppercase; color: var(--cyan); letter-spacing: 0.05em; background: rgba(6, 182, 212, 0.1); padding: 2px 8px; border-radius: var(--radius-pill);">
                                <%= type %>
                            </span>

                            <% if (isUnread) { %>
                            <span style="font-size: 0.7rem; font-weight: 800; text-transform: uppercase; background: var(--primary); color: #fff; padding: 2px 8px; border-radius: var(--radius-pill); box-shadow: 0 0 10px var(--primary-glow);">
                                NEW
                            </span>
                            <% } %>
                        </div>

                        <span style="font-size: 0.78rem; color: var(--text-muted); font-family: monospace;">
                            <%= n.getCreatedAt() != null ? n.getCreatedAt() : "" %>
                        </span>
                    </div>

                    <p style="color: <%= isUnread ? "var(--text)" : "var(--text-secondary)" %>; font-size: 0.95rem; line-height: 1.5; margin: 6px 0 0;">
                        <%= n.getMessage() %>
                    </p>
                </div>

                <!-- ACTION: MARK AS READ -->
                <% if (isUnread) { %>
                <div style="flex-shrink: 0;">
                    <form action="${pageContext.request.contextPath}/mark-notification-read" method="post">
                        <input type="hidden" name="notificationId" value="<%= n.getNotificationId() %>">
                        <button type="submit" class="btn btn-secondary btn-sm" title="Mark as read">
                            <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                            Read
                        </button>
                    </form>
                </div>
                <% } %>

            </div>

        </article>

    <%
            }
        }
    %>

    </section>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Activity Monitoring</p>
    <span>Instant Notifications • Customer Safety & Tracking</span>
</footer>

<!-- SCRIPT FOR NOTIFICATION FILTERING -->
<script>
function filterNotifs(category, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('.notif-item');
    cards.forEach(card => {
        const r = card.getAttribute('data-read');
        if (category === 'ALL' || r === category) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

</body>
</html>