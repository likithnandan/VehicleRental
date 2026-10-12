<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>

<%
    User staff = (User) session.getAttribute("user");
    if (staff == null || !"STAFF".equals(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Booking> activeBookings = (List<Booking>) request.getAttribute("activeBookings");
    if (activeBookings == null) {
        activeBookings = new java.util.ArrayList<Booking>();
    }

    String initial = staff.getName() != null && !staff.getName().trim().isEmpty()
            ? staff.getName().trim().substring(0, 1).toUpperCase()
            : "S";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Operations Dashboard | Vehicle Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/app.js" defer></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <div class="nav-brand">
        <div class="logo-mark" style="background: linear-gradient(135deg, var(--cyan) 0%, #0e7490 100%);">VR</div>
        <div>
            <strong>Vehicle Rental</strong>
            <span>Staff Service Desk</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/staff" class="active">Active Rentals</a>
        <a href="${pageContext.request.contextPath}/maintenance">Maintenance Garage</a>
        <a href="${pageContext.request.contextPath}/index.jsp">Public Site</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"></polygon></svg>
                GROUND OPERATIONS
            </span>
            <h1>Staff Dashboard</h1>
            <p>Operator: <strong><%= staff.getName() %></strong>. Inspect active on-road rentals, log return mileage and damage, and monitor repair work.</p>
        </div>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/maintenance" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                Service Garage
            </a>
        </div>
    </header>

    <!-- OPERATIONAL KPI STRIP -->
    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-label">Operator Profile</span>
            <div class="stat-value" style="font-size: 1.4rem; display: flex; align-items: center; gap: 10px;">
                <div class="logo-mark" style="width: 36px; height: 36px; font-size: 0.95rem; background: linear-gradient(135deg, var(--cyan) 0%, #0284c7 100%);">
                    <%= initial %>
                </div>
                <span><%= staff.getName() %></span>
            </div>
            <span class="stat-desc">Role: Fleet Operations Staff</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Active On-Road Fleet</span>
            <div class="stat-value" style="color: var(--cyan);"><%= activeBookings.size() %></div>
            <span class="stat-desc">Vehicles awaiting return check-in</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">System Privileges</span>
            <div class="stat-value" style="color: var(--success); font-size: 1.4rem; display: flex; align-items: center; gap: 8px;">
                <span style="display: inline-block; width: 10px; height: 10px; border-radius: 50%; background: var(--success);"></span>
                Authorized
            </div>
            <span class="stat-desc">Return inspection & repair logging</span>
        </div>
    </div>

    <!-- SECTION TITLE WITH SEARCH -->
    <div class="section-title" style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 16px; margin-bottom: 22px;">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">DISPATCH TELEMETRY</span>
            <h2>On-Road Rentals (<%= activeBookings.size() %>)</h2>
        </div>

        <div class="search-input-wrapper" style="max-width: 360px;">
            <input type="text" id="rentalSearchInput" placeholder="Search by booking #, plate, or customer..." onkeyup="searchRentals()">
        </div>
    </div>

    <!-- RENTALS CONTAINER -->
    <section id="rentalsContainer" class="dashboard-grid">

<%
    if (activeBookings.isEmpty()) {
%>
        <div class="card empty-state" style="grid-column: 1 / -1;">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <h3>Zero Active Rentals Pending Check-in</h3>
            <p>All dispatched vehicles have returned or are operating within scheduled parameters.</p>
            <a href="${pageContext.request.contextPath}/maintenance" class="btn btn-primary" style="margin-top: 10px;">Check Service Garage →</a>
        </div>
<%
    } else {
        for (Booking booking : activeBookings) {
            String vTitle = booking.getVehicleTitle();
            if (vTitle == null || vTitle.trim().isEmpty()) {
                vTitle = (booking.getVehicleBrand() != null ? booking.getVehicleBrand() + " " : "") +
                         (booking.getVehicleModel() != null ? booking.getVehicleModel() : "Vehicle #" + booking.getVehicleId());
            }

            String vPlate = booking.getVehicleNumber() != null ? booking.getVehicleNumber() : "ID #" + booking.getVehicleId();
            String cName = booking.getUserName() != null ? booking.getUserName() : "Customer #" + booking.getUserId();
            String cPhone = booking.getUserPhone() != null ? booking.getUserPhone() : "Not listed";
            String searchContent = ("#" + booking.getBookingId() + " " + vTitle + " " + vPlate + " " + cName + " " + cPhone).toLowerCase();
%>

        <article class="card booking-card rental-card" data-search="<%= searchContent %>">

            <!-- HEADER -->
            <div class="booking-card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">RENTAL IN PROGRESS</span>
                    <h2>Booking #<%= booking.getBookingId() %></h2>
                </div>

                <span class="status-badge status-available">ON-ROAD</span>
            </div>

            <!-- VEHICLE TITLE & REGISTRATION -->
            <div style="padding: 14px 18px; background: rgba(255,255,255,0.02); border-radius: var(--radius-sm); border: 1px solid var(--border-light);">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: 700; font-size: 1.15rem; color: #fff;"><%= vTitle %></div>
                        <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 4px;">
                            Registration: <strong style="color: var(--cyan);"><%= vPlate %></strong>
                        </div>
                    </div>

                    <div style="text-align: right;">
                        <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Vehicle ID</span>
                        <strong style="color: var(--text-secondary);">#<%= booking.getVehicleId() %></strong>
                    </div>
                </div>
            </div>

            <!-- CUSTOMER DETAILS -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path><circle cx="12" cy="7" r="4"></circle></svg>
                    Renter Contact
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Customer Name</span>
                        <strong><%= cName %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Contact Phone</span>
                        <strong><%= cPhone %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Customer ID</span>
                        <strong>#<%= booking.getUserId() %></strong>
                    </div>
                </div>
            </div>

            <!-- RENTAL SCHEDULE -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    Rental Period
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Pickup Date</span>
                        <strong><%= booking.getPickupDate() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Scheduled Return</span>
                        <strong style="color: var(--warning);"><%= booking.getReturnDate() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Duration</span>
                        <strong><%= booking.getRentalDays() %> days</strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Daily Tariff</span>
                        <strong>₹<%= String.format("%.2f", booking.getPricePerDay()) %></strong>
                    </div>
                </div>
            </div>

            <!-- LOCATIONS -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                    Checkpoints
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Pickup Hub</span>
                        <strong><%= booking.getPickupLocation() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Drop Destination</span>
                        <strong><%= booking.getDropLocation() %></strong>
                    </div>
                </div>
            </div>

            <!-- TOTAL PRICE -->
            <div class="booking-total">
                <span>Rental Booking Value</span>
                <strong>₹<%= String.format("%.2f", booking.getTotalAmount()) %></strong>
            </div>

            <!-- ACTION BUTTON -->
            <div class="booking-actions">
                <a href="${pageContext.request.contextPath}/rental-return?bookingId=<%= booking.getBookingId() %>"
                   class="btn btn-primary"
                   style="width: 100%; background: linear-gradient(135deg, var(--cyan) 0%, #0284c7 100%); border-color: var(--cyan); color: #07090e; font-weight: 700;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path></svg>
                    Process Vehicle Return & Inspection
                </a>
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
    <p><strong>Vehicle Rental Management System</strong> • Staff Operations Portal</p>
    <span>Vehicle Dispatch & Return Check-in Operations</span>
</footer>

<!-- SCRIPT FOR REAL-TIME RENTAL SEARCH -->
<script>
function searchRentals() {
    const q = document.getElementById('rentalSearchInput').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.rental-card');
    cards.forEach(card => {
        const searchData = card.getAttribute('data-search') || '';
        if (!q || searchData.includes(q)) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

</body>
</html>