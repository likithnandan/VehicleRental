<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.User" %>

<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<User> customers = (List<User>) request.getAttribute("customers");
    if (customers == null) {
        customers = new java.util.ArrayList<User>();
    }

    int activeCount = 0;
    int blockedCount = 0;
    for (User u : customers) {
        if ("ACTIVE".equalsIgnoreCase(u.getStatus())) {
            activeCount++;
        } else {
            blockedCount++;
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Management | Vehicle Rental Admin</title>
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
        <a href="${pageContext.request.contextPath}/admin-customers" class="active">Customers</a>
        <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
                IDENTITY & ACCESS
            </span>
            <h1>Registered Customers</h1>
            <p>Monitor customer accounts, inspect contact credentials, manage account status, and configure booking permissions.</p>
        </div>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/admin-bookings" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                View Bookings
            </a>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary">
                Dashboard
            </a>
        </div>
    </header>

    <!-- KPI STAT CARDS -->
    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-label">Total Customers</span>
            <div class="stat-value"><%= customers.size() %></div>
            <span class="stat-desc">Registered platform users</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Active Accounts</span>
            <div class="stat-value" style="color: var(--success);"><%= activeCount %></div>
            <span class="stat-desc">Permitted to book & rent</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Suspended / Blocked</span>
            <div class="stat-value" style="color: var(--danger);"><%= blockedCount %></div>
            <span class="stat-desc">Restricted from reservations</span>
        </div>
    </div>

    <!-- FILTER & SEARCH BAR -->
    <div class="filter-bar">
        <div class="filter-group">
            <button type="button" class="filter-btn active" onclick="filterCustomers('ALL', this)">All (<%= customers.size() %>)</button>
            <button type="button" class="filter-btn" onclick="filterCustomers('ACTIVE', this)">Active (<%= activeCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterCustomers('BLOCKED', this)">Blocked (<%= blockedCount %>)</button>
        </div>

        <div class="search-input-wrapper">
            <input type="text" id="customerSearchInput" placeholder="Search by name, email, phone, or address..." onkeyup="searchCustomers()">
        </div>
    </div>

    <!-- CUSTOMERS GRID -->
    <section id="customersContainer" class="dashboard-grid">

<%
    if (customers.isEmpty()) {
%>
        <div class="card empty-state" style="grid-column: 1 / -1;">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M17 21v-2a4 4 0 0 0-4-4H5a4 4 0 0 0-4 4v2"></path><circle cx="9" cy="7" r="4"></circle><path d="M23 21v-2a4 4 0 0 0-3-3.87"></path><path d="M16 3.13a4 4 0 0 1 0 7.75"></path></svg>
            </div>
            <h3>No Registered Customers</h3>
            <p>There are currently no customer accounts in the database.</p>
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-primary" style="margin-top: 10px;">Back to Dashboard</a>
        </div>
<%
    } else {
        for (User customer : customers) {
            String status = customer.getStatus() != null ? customer.getStatus().toUpperCase() : "ACTIVE";
            boolean isActive = "ACTIVE".equals(status);
            String statusClass = isActive ? "status-available" : "status-rejected";

            String initial = customer.getName() != null && !customer.getName().trim().isEmpty()
                    ? customer.getName().trim().substring(0, 1).toUpperCase()
                    : "C";
            String searchContent = ("#" + customer.getUserId() + " " + customer.getName() + " " + customer.getEmail() + " " + customer.getPhone() + " " + (customer.getAddress() != null ? customer.getAddress() : "")).toLowerCase();
%>

        <article class="card booking-card customer-card"
                 data-status="<%= status %>"
                 data-search="<%= searchContent %>">

            <!-- HEADER -->
            <div class="booking-card-header">
                <div style="display: flex; align-items: center; gap: 12px;">
                    <div class="logo-mark" style="width: 44px; height: 44px; font-size: 1.15rem; background: <%= isActive ? "linear-gradient(135deg, #10b981 0%, #047857 100%)" : "linear-gradient(135deg, #ef4444 0%, #b91c1c 100%)" %>;">
                        <%= initial %>
                    </div>
                    <div>
                        <span class="eyebrow" style="color: var(--cyan);">USER #<%= customer.getUserId() %></span>
                        <h2 style="font-size: 1.25rem;"><%= customer.getName() %></h2>
                    </div>
                </div>

                <span class="status-badge <%= statusClass %>"><%= status %></span>
            </div>

            <!-- CUSTOMER DETAILS -->
            <div class="booking-details-grid" style="margin-top: 6px;">
                <div class="info-item">
                    <span class="info-label">Account ID</span>
                    <strong style="color: var(--cyan);">#<%= customer.getUserId() %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">System Role</span>
                    <strong><%= customer.getRole() %></strong>
                </div>

                <div class="info-item" style="grid-column: 1 / -1;">
                    <span class="info-label">Email Address</span>
                    <strong style="word-break: break-all; color: var(--text);"><%= customer.getEmail() %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Phone Number</span>
                    <strong><%= customer.getPhone() != null && !customer.getPhone().trim().isEmpty() ? customer.getPhone() : "Not provided" %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Access State</span>
                    <strong style="color: <%= isActive ? "var(--success)" : "var(--danger)" %>;">
                        <%= isActive ? "Permitted" : "Suspended" %>
                    </strong>
                </div>
            </div>

            <!-- ADDRESS -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                    Registered Address
                </div>
                <p style="font-size: 0.92rem; color: var(--text-secondary); margin-top: 4px;">
                    <%= customer.getAddress() != null && !customer.getAddress().trim().isEmpty() ? customer.getAddress() : "No physical address registered." %>
                </p>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="booking-actions">
<%
    if (isActive) {
%>
                <a href="${pageContext.request.contextPath}/admin-customers?action=block&userId=<%= customer.getUserId() %>"
                   class="btn btn-danger"
                   style="width: 100%;"
                   data-confirm="Are you sure you want to BLOCK customer <%= customer.getName() %> (#<%= customer.getUserId() %>)? They will no longer be able to make bookings.">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 10 0v4"></path></svg>
                    Block Customer Access
                </a>
<%
    } else {
%>
                <a href="${pageContext.request.contextPath}/admin-customers?action=unblock&userId=<%= customer.getUserId() %>"
                   class="btn btn-primary"
                   style="width: 100%;"
                   data-confirm="Are you sure you want to UNBLOCK customer <%= customer.getName() %> (#<%= customer.getUserId() %>)?">
                    <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect><path d="M7 11V7a5 5 0 0 1 9.9-1"></path></svg>
                    Restore Customer Access
                </a>
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
    <span>Customer Access Management • Real-time Account Security</span>
</footer>

<!-- SCRIPT FOR FILTER & SEARCH -->
<script>
function filterCustomers(status, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('.customer-card');
    cards.forEach(card => {
        const cardStatus = card.getAttribute('data-status');
        if (status === 'ALL' || cardStatus === status) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}

function searchCustomers() {
    const q = document.getElementById('customerSearchInput').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.customer-card');
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