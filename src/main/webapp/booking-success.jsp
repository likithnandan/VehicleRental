<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Booking Submitted Successfully | Vehicle Rental</title>
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
            <span>Reservation Confirmation</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
<% if (isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
        <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        <a href="${pageContext.request.contextPath}/profile">Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
<% } else { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Login</a>
<% } %>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container-narrow">

    <section class="card" style="text-align: center; padding: 48px 36px; border-color: rgba(16, 185, 129, 0.35); box-shadow: var(--shadow-card-hover), 0 0 50px rgba(16, 185, 129, 0.15);">

        <!-- SUCCESS ICON -->
        <div style="width: 76px; height: 76px; border-radius: 50%; background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(5, 150, 105, 0.35) 100%); border: 1px solid rgba(16, 185, 129, 0.45); display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 0 30px rgba(16, 185, 129, 0.35);">
            <svg width="36" height="36" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="20 6 9 17 4 12"></polyline>
            </svg>
        </div>

        <span class="eyebrow" style="color: var(--success); letter-spacing: 0.08em;">RESERVATION REQUEST SUBMITTED</span>

        <h1 style="margin: 10px 0 14px; font-size: 2.2rem;">
            Booking Received!
        </h1>

        <p style="max-width: 520px; margin: 0 auto 28px; font-size: 1.05rem; color: var(--text-secondary); line-height: 1.6;">
            Your vehicle reservation has been logged into the system and is currently pending review by our fleet dispatch administrator.
        </p>

        <!-- STATUS TIMELINE PROGRESS -->
        <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border-light); border-radius: var(--radius-md); padding: 22px 24px; margin-bottom: 32px; text-align: left;">
            <div style="font-size: 0.8rem; font-weight: 700; text-transform: uppercase; color: var(--cyan); letter-spacing: 0.06em; margin-bottom: 16px; display: flex; align-items: center; gap: 8px;">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/></svg>
                Rental Dispatch Workflow Progress
            </div>

            <div style="display: flex; flex-direction: column; gap: 16px;">
                <div style="display: flex; align-items: center; gap: 14px;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: var(--success); color: #07090e; font-size: 0.8rem; font-weight: 800; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 0 10px var(--success-glow);">
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    </span>
                    <div>
                        <strong style="color: var(--text); font-size: 0.95rem;">1. Reservation Successfully Logged</strong>
                        <span style="display: block; font-size: 0.78rem; color: var(--text-muted);">Timestamped and stored in MySQL persistence engine</span>
                    </div>
                </div>

                <div style="display: flex; align-items: center; gap: 14px;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: var(--warning); color: #07090e; font-size: 0.82rem; font-weight: 800; display: flex; align-items: center; justify-content: center; flex-shrink: 0; box-shadow: 0 0 10px rgba(245, 158, 11, 0.4); animation: pulsePending 2s infinite;">
                        2
                    </span>
                    <div>
                        <strong style="color: var(--warning); font-size: 0.95rem;">2. Administrator Schedule Verification (In Progress)</strong>
                        <span style="display: block; font-size: 0.78rem; color: var(--text-muted);">Fleet manager verifies hub inventory and prepares handover keys</span>
                    </div>
                </div>

                <div style="display: flex; align-items: center; gap: 14px; opacity: 0.55;">
                    <span style="width: 26px; height: 26px; border-radius: 50%; background: rgba(255,255,255,0.08); color: var(--text-muted); font-size: 0.82rem; font-weight: 800; display: flex; align-items: center; justify-content: center; flex-shrink: 0;">
                        3
                    </span>
                    <div>
                        <strong style="color: var(--text-secondary); font-size: 0.95rem;">3. Online Payment & Key Handover</strong>
                        <span style="display: block; font-size: 0.78rem; color: var(--text-muted);">Authorize payment via UPI / Card and drive away</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ACTIONS -->
        <div class="hero-buttons" style="justify-content: center; gap: 16px;">
            <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-primary btn-lg">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                Track in My Bookings
            </a>

            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-secondary btn-lg">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.5 2.8C2.1 10.8 2 11 2 11.2V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg>
                Browse Fleet
            </a>
        </div>

    </section>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Instant Notifications • 24/7 Support</span>
</footer>

</body>
</html>