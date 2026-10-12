<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>
<%@ page import="model.Booking" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Integer totalVehicles = (Integer) request.getAttribute("totalVehicles");
    Long availableVehicles = (Long) request.getAttribute("availableVehicles");
    Long activeRentals = (Long) request.getAttribute("activeRentals");
    Long pendingApprovals = (Long) request.getAttribute("pendingApprovals");
    Integer totalCustomers = (Integer) request.getAttribute("totalCustomers");
    Double totalRevenue = (Double) request.getAttribute("totalRevenue");
    List<Booking> recentBookings = (List<Booking>) request.getAttribute("recentBookings");

    if (totalVehicles == null) totalVehicles = 0;
    if (availableVehicles == null) availableVehicles = 0L;
    if (activeRentals == null) activeRentals = 0L;
    if (pendingApprovals == null) pendingApprovals = 0L;
    if (totalCustomers == null) totalCustomers = 0;
    if (totalRevenue == null) totalRevenue = 0.0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Executive Dashboard | Vehicle Rental Admin</title>
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
            <span>Executive Command Center</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin" class="active">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin-vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/admin-customers">Customers</a>
        <a href="${pageContext.request.contextPath}/admin-bookings">
            Bookings
            <% if (pendingApprovals > 0) { %>
                <span class="nav-notification-count" style="background: var(--warning); color: #07090e;"><%= pendingApprovals %></span>
            <% } %>
        </a>
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
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                SYSTEM OVERVIEW
            </span>
            <h1>Fleet Operations Center</h1>
            <p>Welcome back, <strong><%= user.getName() %></strong>. Live telemetry, revenue analytics, and reservation dispatch queue.</p>
        </div>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                Fleet Inventory
            </a>
            <a href="${pageContext.request.contextPath}/admin-bookings" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                Dispatch Queue
            </a>
        </div>
    </header>

    <!-- KPI STATS STRIP -->
    <div class="stats-grid">

        <!-- REVENUE -->
        <div class="stat-card" style="border-color: rgba(99, 102, 241, 0.35);">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                <span class="stat-label">Total Verified Revenue</span>
                <div class="logo-mark" style="width: 36px; height: 36px; font-size: 1rem; background: linear-gradient(135deg, var(--cyan) 0%, #0891b2 100%);">₹</div>
            </div>
            <div class="stat-value" style="color: var(--cyan);">₹<%= String.format("%.2f", totalRevenue) %></div>
            <span class="stat-desc">Settled rental payments</span>
        </div>

        <!-- PENDING APPROVALS -->
        <div class="stat-card" style="border-color: rgba(245, 158, 11, 0.35);">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                <span class="stat-label">Pending Approvals</span>
                <div class="logo-mark" style="width: 36px; height: 36px; font-size: 1rem; background: linear-gradient(135deg, var(--warning) 0%, #b45309 100%);">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polyline points="12 6 12 12 16 14"></polyline></svg>
                </div>
            </div>
            <div class="stat-value" style="color: var(--warning);"><%= pendingApprovals %></div>
            <span class="stat-desc">Awaiting administrator verification</span>
        </div>

        <!-- ACTIVE RENTALS -->
        <div class="stat-card" style="border-color: rgba(6, 182, 212, 0.35);">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                <span class="stat-label">On-Road Rentals</span>
                <div class="logo-mark" style="width: 36px; height: 36px; font-size: 1rem; background: linear-gradient(135deg, var(--primary) 0%, #4338ca 100%);">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
                </div>
            </div>
            <div class="stat-value" style="color: var(--primary-light);"><%= activeRentals %></div>
            <span class="stat-desc">Active trips in progress</span>
        </div>

        <!-- TOTAL FLEET -->
        <div class="stat-card">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">
                <span class="stat-label">Available Vehicles</span>
                <div class="logo-mark" style="width: 36px; height: 36px; font-size: 1rem; background: linear-gradient(135deg, var(--success) 0%, #059669 100%);">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                </div>
            </div>
            <div class="stat-value" style="color: var(--success);"><%= availableVehicles %> <span style="font-size: 1.1rem; color: var(--text-muted); font-weight: normal;">/ <%= totalVehicles %></span></div>
            <span class="stat-desc">Ready for immediate booking</span>
        </div>

    </div>

    <!-- QUICK PORTAL ACCESS CARDS -->
    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 20px; margin-bottom: 36px;">

        <div class="card" style="padding: 20px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/admin-vehicles'">
            <div style="display: flex; align-items: center; gap: 14px;">
                <div class="logo-mark" style="width: 40px; height: 40px; background: rgba(99, 102, 241, 0.15); color: var(--primary-light);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem;">Fleet Inventory</h4>
                    <span style="font-size: 0.8rem; color: var(--text-muted);"><%= totalVehicles %> Vehicles Registered</span>
                </div>
            </div>
        </div>

        <div class="card" style="padding: 20px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/admin-bookings'">
            <div style="display: flex; align-items: center; gap: 14px;">
                <div class="logo-mark" style="width: 40px; height: 40px; background: rgba(245, 158, 11, 0.15); color: var(--warning);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem;">Reservation Queue</h4>
                    <span style="font-size: 0.8rem; color: var(--warning);"><%= pendingApprovals %> Require Approval</span>
                </div>
            </div>
        </div>

        <div class="card" style="padding: 20px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/admin-customers'">
            <div style="display: flex; align-items: center; gap: 14px;">
                <div class="logo-mark" style="width: 40px; height: 40px; background: rgba(16, 185, 129, 0.15); color: var(--success);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem;">Customer Accounts</h4>
                    <span style="font-size: 0.8rem; color: var(--text-muted);"><%= totalCustomers %> Active Accounts</span>
                </div>
            </div>
        </div>

        <div class="card" style="padding: 20px; cursor: pointer;" onclick="location.href='${pageContext.request.contextPath}/maintenance'">
            <div style="display: flex; align-items: center; gap: 14px;">
                <div class="logo-mark" style="width: 40px; height: 40px; background: rgba(6, 182, 212, 0.15); color: var(--cyan);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                </div>
                <div>
                    <h4 style="font-size: 1.05rem;">Maintenance Garage</h4>
                    <span style="font-size: 0.8rem; color: var(--text-muted);">Fleet Repairs & Health</span>
                </div>
            </div>
        </div>

    </div>

    <!-- RECENT BOOKINGS TABLE SECTION -->
    <section class="card" style="padding: 28px;">
        <div class="card-header" style="margin-bottom: 22px;">
            <div>
                <span class="eyebrow" style="color: var(--cyan);">DISPATCH AUDIT</span>
                <h2>Recent Customer Bookings</h2>
            </div>
            <a href="${pageContext.request.contextPath}/admin-bookings" class="btn btn-secondary" style="font-size: 0.85rem; padding: 7px 14px;">
                View All Bookings →
            </a>
        </div>

<%
    if (recentBookings == null || recentBookings.isEmpty()) {
%>
        <div class="empty-state">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
            </div>
            <h3>No Recent Reservations</h3>
            <p>Customer reservations will populate this live audit log as soon as requests are submitted.</p>
        </div>
<%
    } else {
%>
        <div class="table-responsive">
            <table class="modern-table">
                <thead>
                    <tr>
                        <th>Booking Ref</th>
                        <th>Vehicle</th>
                        <th>Customer</th>
                        <th>Schedule</th>
                        <th>Total Amount</th>
                        <th>Payment</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
<%
        for (Booking b : recentBookings) {
            String bStatus = b.getBookingStatus() != null ? b.getBookingStatus().toUpperCase() : "PENDING";
            String bStatusClass = "status-" + bStatus.toLowerCase();
            String payStatus = b.getPaymentStatus() != null ? b.getPaymentStatus().toUpperCase() : "PENDING";
            boolean isPaid = "PAID".equalsIgnoreCase(payStatus);

            String vName = b.getVehicleTitle();
            if (vName == null || vName.trim().isEmpty()) {
                vName = (b.getVehicleBrand() != null ? b.getVehicleBrand() + " " : "") + (b.getVehicleModel() != null ? b.getVehicleModel() : "Vehicle #" + b.getVehicleId());
            }
            String cName = b.getUserName() != null ? b.getUserName() : "Customer #" + b.getUserId();
%>
                    <tr>
                        <td>
                            <strong style="color: var(--cyan); font-family: 'Space Grotesk', sans-serif;">#<%= b.getBookingId() %></strong>
                        </td>
                        <td>
                            <strong style="color: var(--text);"><%= vName %></strong>
                            <small style="display: block; color: var(--text-muted); font-size: 0.78rem;"><%= b.getVehicleNumber() != null ? b.getVehicleNumber() : "" %></small>
                        </td>
                        <td>
                            <span><%= cName %></span>
                            <small style="display: block; color: var(--text-muted); font-size: 0.78rem;"><%= b.getUserPhone() != null ? b.getUserPhone() : "" %></small>
                        </td>
                        <td>
                            <span style="font-size: 0.88rem;"><%= b.getPickupDate() %> &rarr; <%= b.getReturnDate() %></span>
                            <small style="display: block; color: var(--text-muted); font-size: 0.78rem;"><%= b.getRentalDays() %> days</small>
                        </td>
                        <td>
                            <strong style="font-family: 'Space Grotesk', sans-serif; color: var(--text); font-size: 1rem;">₹<%= String.format("%.2f", b.getTotalAmount()) %></strong>
                        </td>
                        <td>
                            <% if (isPaid) { %>
                                <span class="status-badge status-confirmed">PAID</span>
                            <% } else { %>
                                <span class="status-badge status-pending">UNPAID</span>
                            <% } %>
                        </td>
                        <td>
                            <span class="status-badge <%= bStatusClass %>"><%= bStatus %></span>
                        </td>
                        <td>
                            <% if ("PENDING".equals(bStatus)) { %>
                                <a href="${pageContext.request.contextPath}/update-booking-status?bookingId=<%= b.getBookingId() %>&status=CONFIRMED" class="btn btn-primary" style="padding: 5px 12px; font-size: 0.8rem;" data-confirm="Approve booking #<%= b.getBookingId() %>?">
                                    Approve
                                </a>
                            <% } else if ("CONFIRMED".equals(bStatus)) { %>
                                <a href="${pageContext.request.contextPath}/rental-return?bookingId=<%= b.getBookingId() %>" class="btn btn-secondary" style="padding: 5px 12px; font-size: 0.8rem; border-color: var(--cyan); color: var(--cyan);">
                                    Return
                                </a>
                            <% } else { %>
                                <span style="font-size: 0.8rem; color: var(--text-muted);">&mdash;</span>
                            <% } %>
                        </td>
                    </tr>
<%
        }
%>
                </tbody>
            </table>
        </div>
<%
    }
%>

    </section>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Administrator Control Center</p>
    <span>Enterprise Telemetry • Audit Log Engine • Real-time DB Queries</span>
</footer>

</body>
</html>