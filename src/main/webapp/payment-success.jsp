<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String bookingId = request.getParameter("bookingId");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment Successful | Vehicle Rental</title>
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
            <span>Payment Receipt</span>
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
        <div class="card" style="width: 100%; max-width: 520px; text-align: center; box-shadow: var(--shadow-card-hover), 0 0 50px rgba(16, 185, 129, 0.18); border-color: rgba(16, 185, 129, 0.35);">
            
            <div style="width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, rgba(5, 150, 105, 0.3) 100%); border: 1px solid rgba(16, 185, 129, 0.4); display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; box-shadow: 0 0 25px rgba(16, 185, 129, 0.3);">
                <svg width="34" height="34" viewBox="0 0 24 24" fill="none" stroke="#10b981" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="20 6 9 17 4 12"></polyline>
                </svg>
            </div>

            <span class="eyebrow" style="color: var(--success); letter-spacing: 0.08em;">
                TRANSACTION CONFIRMED
            </span>

            <h1 style="margin-top: 8px; margin-bottom: 10px; font-size: 2rem;">Payment Settled!</h1>
            <p style="margin-bottom: 24px; color: var(--text-secondary);">
                Your rental payment for Booking <strong>#<%= bookingId %></strong> has been authorized and permanently recorded. Your vehicle is confirmed for pickup.
            </p>

            <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 18px 22px; margin-bottom: 28px; display: flex; justify-content: space-between; align-items: center;">
                <span style="font-size: 0.88rem; color: var(--text-muted);">Payment Status</span>
                <span class="badge badge-success"><span class="badge-dot"></span> PAID IN FULL</span>
            </div>

            <div style="display: flex; gap: 12px; flex-direction: column;">
                <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-primary btn-lg">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    View in My Bookings
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
    <span>Instant Notifications • Verified Billing</span>
</footer>

</body>
</html>