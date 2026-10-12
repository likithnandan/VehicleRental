<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String bookingId = request.getParameter("bookingId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Received | Vehicle Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/app.js" defer></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <div class="nav-brand">
        <div class="logo-mark">VR</div>
        <div>
            <strong>Vehicle Rental</strong>
            <span>Customer Feedback</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container-narrow">
    <div class="auth-wrapper" style="min-height: auto; padding: 40px 0;">
        <div class="card" style="width: 100%; max-width: 520px; text-align: center; box-shadow: var(--shadow-card-hover), 0 0 50px rgba(99, 102, 241, 0.18); border-color: rgba(99, 102, 241, 0.35);">
            
            <div style="width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, rgba(217, 119, 6, 0.3) 100%); border: 1px solid rgba(245, 158, 11, 0.4); display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 0 25px rgba(245, 158, 11, 0.3);">
                <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#fbbf24" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                </svg>
            </div>

            <span class="eyebrow" style="color: #fbbf24; letter-spacing: 0.08em;">
                FEEDBACK RECORDED
            </span>

            <h1 style="margin-top: 8px; margin-bottom: 10px; font-size: 2rem;">Thank You for Your Feedback!</h1>
            <p style="margin-bottom: 26px; color: var(--text-secondary);">
                Your rating and review for Booking <strong>#<%= bookingId %></strong> have been posted to the platform. Your insights help maintain high vehicle standards across the fleet.
            </p>

            <div style="display: flex; gap: 12px; flex-direction: column;">
                <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-primary btn-lg">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    Return to My Bookings
                </a>
                <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-outline">
                    Browse Other Vehicles
                </a>
            </div>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Audited Reviews • MySQL 8/9 Persistence</span>
</footer>

</body>
</html>