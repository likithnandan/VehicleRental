<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    int totalCustomers = request.getAttribute("totalCustomers") != null ? (Integer) request.getAttribute("totalCustomers") : 0;
    int totalVehicles = request.getAttribute("totalVehicles") != null ? (Integer) request.getAttribute("totalVehicles") : 0;
    int availableVehicles = request.getAttribute("availableVehicles") != null ? (Integer) request.getAttribute("availableVehicles") : 0;
    int rentedVehicles = request.getAttribute("rentedVehicles") != null ? (Integer) request.getAttribute("rentedVehicles") : 0;
    int maintenanceVehicles = request.getAttribute("maintenanceVehicles") != null ? (Integer) request.getAttribute("maintenanceVehicles") : 0;

    int totalBookings = request.getAttribute("totalBookings") != null ? (Integer) request.getAttribute("totalBookings") : 0;
    int pendingBookings = request.getAttribute("pendingBookings") != null ? (Integer) request.getAttribute("pendingBookings") : 0;
    int completedBookings = request.getAttribute("completedBookings") != null ? (Integer) request.getAttribute("completedBookings") : 0;
    double totalRevenue = request.getAttribute("totalRevenue") != null ? (Double) request.getAttribute("totalRevenue") : 0.0;

    int activeOrOtherBookings = Math.max(0, totalBookings - pendingBookings - completedBookings);

    double availPct = totalVehicles > 0 ? (availableVehicles * 100.0 / totalVehicles) : 0;
    double rentPct = totalVehicles > 0 ? (rentedVehicles * 100.0 / totalVehicles) : 0;
    double maintPct = totalVehicles > 0 ? (maintenanceVehicles * 100.0 / totalVehicles) : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports & Fleet Analytics | Vehicle Rental Admin</title>
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
        <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <a href="${pageContext.request.contextPath}/reports" class="active">Reports</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="18" y1="20" x2="18" y2="10"></line>
                    <line x1="12" y1="20" x2="12" y2="4"></line>
                    <line x1="6" y1="20" x2="6" y2="14"></line>
                </svg>
                EXECUTIVE INTELLIGENCE
            </span>
            <h1>Reports & Analytics</h1>
            <p>Comprehensive audit of fleet utilization, verified transactions, booking pipelines, and customer acquisition metrics.</p>
        </div>

        <div class="hero-buttons">
            <button type="button" class="btn btn-secondary" onclick="window.print()">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="6 9 6 2 18 2 18 9"></polyline>
                    <path d="M6 18H4a2 2 0 0 1-2-2v-5a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v5a2 2 0 0 1-2 2h-2"></path>
                    <rect x="6" y="14" width="12" height="8"></rect>
                </svg>
                Print Report
            </button>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="19" y1="12" x2="5" y2="12"></line>
                    <polyline points="12 19 5 12 12 5"></polyline>
                </svg>
                Executive Dashboard
            </a>
        </div>
    </header>

    <!-- REVENUE HERO CARD -->
    <div class="card" style="margin-bottom: 30px; background: linear-gradient(135deg, rgba(99, 102, 241, 0.14) 0%, rgba(6, 182, 212, 0.08) 100%); border-color: rgba(99, 102, 241, 0.35); position: relative; overflow: hidden;">
        <div style="display: flex; justify-content: space-between; align-items: flex-start; position: relative; z-index: 2;">
            <div>
                <span class="eyebrow" style="color: var(--cyan);">FINANCIAL AUDIT</span>
                <h2 style="font-size: 1.5rem; margin-top: 4px;">Total Verified Paid Revenue</h2>
                <p style="margin-top: 4px; color: var(--text-secondary);">Cumulated revenue from all settled customer transactions in MySQL</p>

                <div style="font-size: clamp(2.4rem, 4.5vw, 3.4rem); font-weight: 800; color: #fff; margin-top: 14px; font-family: 'Space Grotesk', sans-serif; letter-spacing: -0.03em;">
                    ₹<%= String.format("%.2f", totalRevenue) %>
                </div>
            </div>

            <div class="logo-mark" style="width: 58px; height: 58px; background: linear-gradient(135deg, var(--cyan) 0%, #0891b2 100%); border-color: rgba(6, 182, 212, 0.4); box-shadow: 0 4px 20px var(--cyan-glow);">
                <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="1" x2="12" y2="23"></line>
                    <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                </svg>
            </div>
        </div>
    </div>

    <!-- MAIN KPI STATS -->
    <div class="stats-grid" style="margin-bottom: 30px;">
        <div class="stat-card">
            <span class="stat-label">Registered Customers</span>
            <div class="stat-value"><%= totalCustomers %></div>
            <span class="stat-desc">Active account identities</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Total Fleet Vehicles</span>
            <div class="stat-value" style="color: var(--cyan);"><%= totalVehicles %></div>
            <span class="stat-desc">Cars, Bikes & Scooters</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Total Reservations</span>
            <div class="stat-value" style="color: var(--primary-light);"><%= totalBookings %></div>
            <span class="stat-desc">Audited booking volume</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Completed Trips</span>
            <div class="stat-value" style="color: var(--success);"><%= completedBookings %></div>
            <span class="stat-desc">Successfully concluded journeys</span>
        </div>
    </div>

    <!-- FLEET AVAILABILITY BREAKDOWN -->
    <div class="card" style="margin-bottom: 30px;">
        <div class="card-header">
            <div>
                <span class="eyebrow">INVENTORY ALLOCATION</span>
                <h2>Vehicle Fleet Utilization</h2>
            </div>
            <span class="status-badge status-confirmed"><%= totalVehicles %> Total Fleet</span>
        </div>

        <!-- PROGRESS GAUGE BAR -->
        <div style="margin: 22px 0 18px;">
            <div style="display: flex; height: 10px; border-radius: var(--radius-pill); overflow: hidden; background: rgba(255,255,255,0.06);">
                <div style="width: <%= String.format(java.util.Locale.US, "%.1f", availPct) %>%; background: var(--success);" title="Available: <%= availableVehicles %>"></div>
                <div style="width: <%= String.format(java.util.Locale.US, "%.1f", rentPct) %>%; background: var(--cyan);" title="Rented: <%= rentedVehicles %>"></div>
                <div style="width: <%= String.format(java.util.Locale.US, "%.1f", maintPct) %>%; background: var(--danger);" title="Maintenance: <%= maintenanceVehicles %>"></div>
            </div>
        </div>

        <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); margin-bottom: 0;">
            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label" style="display: flex; align-items: center; gap: 8px;">
                    <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--success); box-shadow: 0 0 8px var(--success-glow);"></span>
                    Ready / Available
                </span>
                <div class="stat-value" style="color: var(--success); font-size: 1.8rem;"><%= availableVehicles %></div>
                <span class="stat-desc"><%= String.format(java.util.Locale.US, "%.1f", availPct) %>% of total inventory</span>
            </div>

            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label" style="display: flex; align-items: center; gap: 8px;">
                    <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--cyan); box-shadow: 0 0 8px var(--cyan-glow);"></span>
                    Currently Rented
                </span>
                <div class="stat-value" style="color: var(--cyan); font-size: 1.8rem;"><%= rentedVehicles %></div>
                <span class="stat-desc"><%= String.format(java.util.Locale.US, "%.1f", rentPct) %>% on active road</span>
            </div>

            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label" style="display: flex; align-items: center; gap: 8px;">
                    <span style="display: inline-block; width: 8px; height: 8px; border-radius: 50%; background: var(--danger); box-shadow: 0 0 8px rgba(239, 68, 68, 0.4);"></span>
                    In Maintenance
                </span>
                <div class="stat-value" style="color: var(--danger); font-size: 1.8rem;"><%= maintenanceVehicles %></div>
                <span class="stat-desc"><%= String.format(java.util.Locale.US, "%.1f", maintPct) %>% in repair garage</span>
            </div>
        </div>
    </div>

    <!-- BOOKINGS PIPELINE -->
    <div class="card" style="margin-bottom: 30px;">
        <div class="card-header">
            <div>
                <span class="eyebrow">RESERVATIONS PIPELINE</span>
                <h2>Booking Status Overview</h2>
            </div>
            <span class="status-badge status-pending"><%= totalBookings %> Total Bookings</span>
        </div>

        <div class="stats-grid" style="grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); margin-top: 18px; margin-bottom: 0;">
            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label">Pending Approval</span>
                <div class="stat-value" style="color: var(--warning); font-size: 1.8rem;"><%= pendingBookings %></div>
                <span class="stat-desc">Awaiting administrator verification</span>
            </div>

            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label">Active / Ongoing</span>
                <div class="stat-value" style="color: var(--cyan); font-size: 1.8rem;"><%= activeOrOtherBookings %></div>
                <span class="stat-desc">Confirmed rentals in operation</span>
            </div>

            <div class="stat-card" style="background: rgba(255,255,255,0.02);">
                <span class="stat-label">Completed Returns</span>
                <div class="stat-value" style="color: var(--success); font-size: 1.8rem;"><%= completedBookings %></div>
                <span class="stat-desc">Fully closed & verified check-ins</span>
            </div>
        </div>
    </div>

    <!-- QUICK ACTIONS PORTAL -->
    <div class="card">
        <div class="card-header">
            <div>
                <span class="eyebrow">OPERATIONAL NAVIGATION</span>
                <h2>Management Portals</h2>
            </div>
        </div>

        <div class="hero-buttons" style="margin-top: 20px;">
            <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.5 2.8C2.1 10.8 2 11 2 11.2V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/>
                </svg>
                Fleet Inventory
            </a>
            <a href="${pageContext.request.contextPath}/admin-bookings" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/><polyline points="14 2 14 8 20 8"/><line x1="16" y1="13" x2="8" y2="13"/><line x1="16" y1="17" x2="8" y2="17"/><polyline points="10 9 9 9 8 9"/>
                </svg>
                Booking Requests
            </a>
            <a href="${pageContext.request.contextPath}/admin-customers" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path>
                </svg>
                Customer Accounts
            </a>
            <a href="${pageContext.request.contextPath}/maintenance" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"/>
                </svg>
                Maintenance Garage
            </a>
        </div>
    </div>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Analytics & Intelligence Engine</p>
    <span>Audited Data • MySQL 8/9 Persistence</span>
</footer>

</body>
</html>