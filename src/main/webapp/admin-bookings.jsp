<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new java.util.ArrayList<Booking>();
    }

    int pendingCount = 0;
    int confirmedCount = 0;
    int completedCount = 0;
    int otherCount = 0;
    for (Booking b : bookings) {
        String s = b.getBookingStatus();
        if ("PENDING".equalsIgnoreCase(s)) pendingCount++;
        else if ("CONFIRMED".equalsIgnoreCase(s)) confirmedCount++;
        else if ("COMPLETED".equalsIgnoreCase(s)) completedCount++;
        else otherCount++;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Bookings | Vehicle Rental Admin</title>
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
            <span>Admin Control Center</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin-vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/admin-customers">Customers</a>
        <a href="${pageContext.request.contextPath}/admin-bookings" class="active">Bookings</a>
        <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                RESERVATION CONTROL
            </span>
            <h1>Customer Bookings</h1>
            <p>Review customer reservations, approve applications, monitor payment states, and inspect return logs.</p>
        </div>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                Fleet Inventory
            </a>
            <a href="${pageContext.request.contextPath}/reports" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="20" x2="18" y2="10"></line><line x1="12" y1="20" x2="12" y2="4"></line><line x1="6" y1="20" x2="6" y2="14"></line></svg>
                Analytics
            </a>
        </div>
    </header>

    <!-- KPI STAT STRIP -->
    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-label">Total Reservations</span>
            <div class="stat-value"><%= bookings.size() %></div>
            <span class="stat-desc">Lifetime booking requests</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Pending Approval</span>
            <div class="stat-value" style="color: var(--warning);"><%= pendingCount %></div>
            <span class="stat-desc">Awaiting admin verification</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Active / Confirmed</span>
            <div class="stat-value" style="color: var(--cyan);"><%= confirmedCount %></div>
            <span class="stat-desc">Approved or currently rented</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Completed Returns</span>
            <div class="stat-value" style="color: var(--success);"><%= completedCount %></div>
            <span class="stat-desc">Successfully finished</span>
        </div>
    </div>

    <!-- FILTER & SEARCH TOOLBAR -->
    <div class="filter-bar">
        <div class="filter-group">
            <button type="button" class="filter-btn active" onclick="filterBookings('ALL', this)">All (<%= bookings.size() %>)</button>
            <button type="button" class="filter-btn" onclick="filterBookings('PENDING', this)">Pending (<%= pendingCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterBookings('CONFIRMED', this)">Confirmed (<%= confirmedCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterBookings('COMPLETED', this)">Completed (<%= completedCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterBookings('OTHER', this)">Cancelled / Rejected (<%= otherCount %>)</button>
        </div>

        <div class="search-input-wrapper">
            <input type="text" id="bookingSearchInput" placeholder="Search by booking #, vehicle, plate, or customer..." onkeyup="searchBookings()">
        </div>
    </div>

    <!-- BOOKINGS CONTAINER -->
    <section id="bookingsContainer" class="dashboard-grid">

<%
    if (bookings.isEmpty()) {
%>
        <div class="card empty-state" style="grid-column: 1 / -1;">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
            </div>
            <h3>No Bookings Recorded</h3>
            <p>There are currently no customer reservation requests stored in the database.</p>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary">Back to Dashboard</a>
        </div>
<%
    } else {
        for (Booking booking : bookings) {
            String status = booking.getBookingStatus() != null ? booking.getBookingStatus().toUpperCase() : "PENDING";
            String statusClass = "status-" + status.toLowerCase();

            String vTitle = booking.getVehicleTitle();
            if (vTitle == null || vTitle.trim().isEmpty()) {
                vTitle = (booking.getVehicleBrand() != null ? booking.getVehicleBrand() + " " : "") +
                         (booking.getVehicleModel() != null ? booking.getVehicleModel() : "Vehicle #" + booking.getVehicleId());
            }

            String vPlate = booking.getVehicleNumber() != null ? booking.getVehicleNumber() : "ID #" + booking.getVehicleId();
            String cName = booking.getUserName() != null ? booking.getUserName() : "Customer #" + booking.getUserId();
            String cEmail = booking.getUserEmail() != null ? booking.getUserEmail() : "";
            String cPhone = booking.getUserPhone() != null ? booking.getUserPhone() : "";
            String payStatus = booking.getPaymentStatus() != null ? booking.getPaymentStatus().toUpperCase() : "PENDING";
            boolean isPaid = "PAID".equalsIgnoreCase(payStatus);

            String filterCategory = "OTHER";
            if ("PENDING".equals(status)) filterCategory = "PENDING";
            else if ("CONFIRMED".equals(status)) filterCategory = "CONFIRMED";
            else if ("COMPLETED".equals(status)) filterCategory = "COMPLETED";
%>

        <article class="card booking-card"
                 data-status="<%= filterCategory %>"
                 data-search="<%= ("#" + booking.getBookingId() + " " + vTitle + " " + vPlate + " " + cName + " " + cEmail + " " + cPhone).toLowerCase() %>">

            <!-- HEADER -->
            <div class="booking-card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">RESERVATION REF</span>
                    <h2>#<%= booking.getBookingId() %></h2>
                </div>

                <div style="display: flex; gap: 8px; align-items: center;">
                    <span class="status-badge <%= statusClass %>"><%= status %></span>
                    <% if (isPaid) { %>
                        <span class="status-badge status-confirmed">PAID</span>
                    <% } else { %>
                        <span class="status-badge status-pending">UNPAID</span>
                    <% } %>
                </div>
            </div>

            <!-- VEHICLE SUMMARY -->
            <div style="padding: 14px 18px; background: rgba(255,255,255,0.02); border-radius: var(--radius-sm); border: 1px solid var(--border-light);">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: 700; font-size: 1.1rem; color: #fff;"><%= vTitle %></div>
                        <div style="font-size: 0.85rem; color: var(--text-muted); display: flex; gap: 10px; align-items: center; margin-top: 4px;">
                            <span>Reg Plate: <strong style="color: var(--cyan);"><%= vPlate %></strong></span>
                            <% if (booking.getVehicleType() != null) { %>
                                <span>•</span>
                                <span>Type: <strong><%= booking.getVehicleType() %></strong></span>
                            <% } %>
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
                    Customer Information
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Name</span>
                        <strong><%= cName %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Customer ID</span>
                        <strong>#<%= booking.getUserId() %></strong>
                    </div>

                    <% if (!cEmail.isEmpty()) { %>
                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <strong style="word-break: break-all;"><%= cEmail %></strong>
                    </div>
                    <% } %>

                    <% if (!cPhone.isEmpty()) { %>
                    <div class="info-item">
                        <span class="info-label">Phone</span>
                        <strong><%= cPhone %></strong>
                    </div>
                    <% } %>
                </div>
            </div>

            <!-- RENTAL PERIOD -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                    Rental Schedule
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Pickup Date</span>
                        <strong><%= booking.getPickupDate() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Return Date</span>
                        <strong><%= booking.getReturnDate() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Duration</span>
                        <strong><%= booking.getRentalDays() %> <%= booking.getRentalDays() == 1 ? "day" : "days" %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Daily Tariff</span>
                        <strong>₹<%= String.format("%.2f", booking.getPricePerDay()) %></strong>
                    </div>
                </div>
            </div>

            <!-- ROUTE / LOCATIONS -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                    Transit Checkpoints
                </div>
                <div class="booking-details-grid">
                    <div class="info-item">
                        <span class="info-label">Pickup Hub</span>
                        <strong><%= booking.getPickupLocation() %></strong>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Drop-off Destination</span>
                        <strong><%= booking.getDropLocation() %></strong>
                    </div>
                </div>
            </div>

            <!-- TOTAL PRICING -->
            <div class="booking-total">
                <div>
                    <span style="display: block; font-size: 0.76rem; color: var(--text-muted); text-transform: uppercase;">Total Booking Price</span>
                    <small style="color: var(--text-secondary);"><%= booking.getRentalDays() %> days × ₹<%= String.format("%.0f", booking.getPricePerDay()) %></small>
                </div>
                <strong>₹<%= String.format("%.2f", booking.getTotalAmount()) %></strong>
            </div>

            <!-- ACTIONS -->
            <div class="booking-actions">
<%
    if ("PENDING".equals(status)) {
%>
                <a href="${pageContext.request.contextPath}/update-booking-status?bookingId=<%= booking.getBookingId() %>&status=CONFIRMED"
                   class="btn btn-primary"
                   style="flex: 1;"
                   data-confirm="Are you sure you want to APPROVE booking #<%= booking.getBookingId() %>?">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                    Approve
                </a>

                <a href="${pageContext.request.contextPath}/update-booking-status?bookingId=<%= booking.getBookingId() %>&status=REJECTED"
                   class="btn btn-danger"
                   data-confirm="Are you sure you want to REJECT booking #<%= booking.getBookingId() %>?">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="18" y1="6" x2="6" y2="18"></line><line x1="6" y1="6" x2="18" y2="18"></line></svg>
                    Reject
                </a>
<%
    } else if ("CONFIRMED".equals(status)) {
%>
                <a href="${pageContext.request.contextPath}/rental-return?bookingId=<%= booking.getBookingId() %>"
                   class="btn btn-secondary"
                   style="width: 100%; border-color: var(--cyan); color: var(--cyan);">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="1 4 1 10 7 10"></polyline><path d="M3.51 15a9 9 0 1 0 2.13-9.36L1 10"></path></svg>
                    Process Vehicle Return
                </a>
<%
    } else if ("COMPLETED".equals(status)) {
%>
                <span class="btn btn-secondary" style="width: 100%; opacity: 0.7; cursor: default;">
                    Rental Successfully Completed
                </span>
<%
    } else if ("REJECTED".equals(status)) {
%>
                <span class="btn btn-danger" style="width: 100%; opacity: 0.7; cursor: default;">
                    Booking Rejected
                </span>
<%
    } else if ("CANCELLED".equals(status)) {
%>
                <span class="btn btn-danger" style="width: 100%; opacity: 0.7; cursor: default;">
                    Cancelled by Customer
                </span>
<%
    }
%>
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
    <p><strong>Vehicle Rental Management System</strong> • Administrator Control Center</p>
    <span>Secure Reservation Audit Log • Enterprise Telemetry</span>
</footer>

<!-- SCRIPT FOR FILTERING & SEARCH -->
<script>
function filterBookings(category, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('.booking-card');
    cards.forEach(card => {
        const cardStatus = card.getAttribute('data-status');
        if (category === 'ALL' || cardStatus === category) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}

function searchBookings() {
    const q = document.getElementById('bookingSearchInput').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.booking-card');
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