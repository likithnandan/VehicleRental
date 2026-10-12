<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    String role = isLoggedIn ? user.getRole() : "";

    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    if (vehicles == null) {
        vehicles = new java.util.ArrayList<Vehicle>();
    }

    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
    String vehicleType = request.getAttribute("vehicleType") != null ? (String) request.getAttribute("vehicleType") : "";
    String location = request.getAttribute("location") != null ? (String) request.getAttribute("location") : "";
    String pickupDate = request.getAttribute("pickupDate") != null ? (String) request.getAttribute("pickupDate") : "";
    String returnDate = request.getAttribute("returnDate") != null ? (String) request.getAttribute("returnDate") : "";
    String error = request.getAttribute("error") != null ? (String) request.getAttribute("error") : "";

    String paramError = request.getParameter("error");
    if ("unavailable".equals(request.getParameter("unavailable")) || "unavailable".equals(paramError)) {
        error = "The selected vehicle is not available for the requested rental dates.";
    } else if ("pastdate".equals(request.getParameter("pastdate")) || "pastdate".equals(paramError)) {
        error = "Pickup date cannot be in the past.";
    } else if ("invaliddates".equals(request.getParameter("invaliddates")) || "invaliddates".equals(paramError)) {
        error = "Return date must be strictly after the pickup date.";
    } else if ("dates".equals(request.getParameter("dates")) || "dates".equals(paramError)) {
        error = "Please specify valid pickup and return dates.";
    } else if ("booking".equals(request.getParameter("booking")) || "booking".equals(paramError)) {
        error = "Unable to process booking reservation. Please try again.";
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fleet Catalog | Vehicle Rental</title>
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
            <span>Fleet Catalog</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/vehicles" class="active">Browse Fleet</a>

<% if (!isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Sign In</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary" style="padding: 8px 18px; font-size: 0.88rem;">Create Account</a>
<% } else { %>
        <% if ("ADMIN".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/admin">Admin Portal</a>
            <a href="${pageContext.request.contextPath}/admin-vehicles">Fleet</a>
            <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
        <% } else if ("STAFF".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/staff">Staff Portal</a>
            <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">Profile</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
<% } %>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><polygon points="12 8 8 12 12 16 12 8"></polygon></svg>
                COMMERCIAL FLEET DIRECTORY
            </span>
            <h1>Available Vehicles</h1>
            <p>Filter by vehicle class, powertrain, or city hub. Instant availability verification across all hubs.</p>
        </div>

        <div class="hero-buttons">
<% if (isLoggedIn && "ADMIN".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/add-vehicle.jsp" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Add New Vehicle
            </a>
<% } else if (isLoggedIn && "CUSTOMER".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                My Bookings
            </a>
<% } %>
        </div>
    </header>

    <!-- ALERTS -->
<% if (error != null && !error.trim().isEmpty()) { %>
    <div class="alert alert-danger" style="margin-bottom: 24px;">
        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
        <span><%= error %></span>
    </div>
<% } %>

    <!-- ADVANCED FILTER CONSOLE -->
    <div class="card" style="margin-bottom: 30px; border-color: rgba(99, 102, 241, 0.25);">
        <form action="${pageContext.request.contextPath}/vehicles" method="get">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 16px; align-items: flex-end;">

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="keyword" style="font-size: 0.82rem; font-weight: 600;">Brand / Model</label>
                    <input type="text" id="keyword" name="keyword" value="<%= keyword %>" placeholder="e.g. Tesla, Honda, Yamaha...">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="vehicleType" style="font-size: 0.82rem; font-weight: 600;">Category</label>
                    <select id="vehicleType" name="vehicleType">
                        <option value="">All Categories</option>
                        <option value="CAR" <%= "CAR".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Cars & SUVs</option>
                        <option value="BIKE" <%= "BIKE".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Motorcycles</option>
                        <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(vehicleType) ? "selected" : "" %>>Scooters & EVs</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="location" style="font-size: 0.82rem; font-weight: 600;">Pickup Location</label>
                    <input type="text" id="location" name="location" value="<%= location %>" placeholder="e.g. City Center, Airport...">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="pickupDate" style="font-size: 0.82rem; font-weight: 600;">Pickup Date</label>
                    <input type="date" id="pickupDate" name="pickupDate" value="<%= pickupDate %>">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="returnDate" style="font-size: 0.82rem; font-weight: 600;">Return Date</label>
                    <input type="date" id="returnDate" name="returnDate" value="<%= returnDate %>">
                </div>

                <div class="form-group" style="margin-bottom: 0; display: flex; gap: 8px;">
                    <button type="submit" class="btn btn-primary" style="flex: 1; height: 44px; font-weight: 700;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        Filter
                    </button>
                    <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-secondary" style="height: 44px; display: inline-flex; align-items: center; justify-content: center; padding: 0 14px;" title="Reset filters">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M23 4v6h-6"></path><path d="M20.49 15a9 9 0 1 1-2.12-9.36L23 10"></path></svg>
                    </a>
                </div>

            </div>
        </form>
    </div>

    <!-- QUICK CATEGORY PILLS BAR -->
    <div class="filter-bar" style="margin-bottom: 28px;">
        <div class="filter-group">
            <a href="${pageContext.request.contextPath}/vehicles" class="filter-btn <%= (vehicleType == null || vehicleType.isEmpty()) ? "active" : "" %>">
                All Vehicles (<%= vehicles.size() %>)
            </a>
            <a href="${pageContext.request.contextPath}/vehicles?vehicleType=CAR" class="filter-btn <%= "CAR".equalsIgnoreCase(vehicleType) ? "active" : "" %>">
                Cars & SUVs
            </a>
            <a href="${pageContext.request.contextPath}/vehicles?vehicleType=BIKE" class="filter-btn <%= "BIKE".equalsIgnoreCase(vehicleType) ? "active" : "" %>">
                Motorcycles
            </a>
            <a href="${pageContext.request.contextPath}/vehicles?vehicleType=SCOOTER" class="filter-btn <%= "SCOOTER".equalsIgnoreCase(vehicleType) ? "active" : "" %>">
                Scooters & EVs
            </a>
        </div>

        <div class="search-input-wrapper">
            <input type="text" id="liveVehicleSearch" placeholder="Search by name, category, or plate..." onkeyup="searchVehicleCards()">
        </div>
    </div>

    <!-- VEHICLES GRID -->
    <section id="vehicleCardsGrid" class="vehicle-grid">

<%
    if (vehicles.isEmpty()) {
%>
        <div class="card empty-state" style="grid-column: 1 / -1;">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="8" y1="12" x2="16" y2="12"></line></svg>
            </div>
            <h3>No Vehicles Match Your Query</h3>
            <p>Try modifying your date selection, location, or clearing specific category filters.</p>
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary" style="margin-top: 10px;">Reset All Filters</a>
        </div>
<%
    } else {
        for (Vehicle v : vehicles) {
            String vStatus = v.getStatus() != null ? v.getStatus().toUpperCase() : "AVAILABLE";
            boolean isAvail = "AVAILABLE".equals(vStatus);
            String statusBadgeClass = isAvail ? "status-available" : ( "RENTED".equals(vStatus) ? "status-pending" : "status-maintenance" );

            String type = v.getVehicleType() != null ? v.getVehicleType().toUpperCase() : "CAR";
            String searchMeta = (v.getBrand() + " " + v.getModel() + " " + v.getVehicleNumber() + " " + v.getCategory() + " " + v.getLocation() + " " + type).toLowerCase();
%>

        <article class="vehicle-card" data-search="<%= searchMeta %>">

            <!-- IMAGE / PLACEHOLDER -->
            <div class="vehicle-image" style="height: 200px; position: relative; overflow: hidden; background: #080c14; display: flex; align-items: center; justify-content: center; border-bottom: 1px solid var(--border-light);">
<%
    if (v.getImagePath() != null && !v.getImagePath().trim().isEmpty()) {
%>
                <img src="<%= v.getImagePath() %>" alt="<%= v.getFullName() %>">
<%
    } else {
%>
                <div style="opacity: 0.3; color: var(--text-secondary);">
                    <% if ("BIKE".equals(type)) { %>
                        <svg width="68" height="68" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="18.5" cy="17.5" r="3.5"/><circle cx="5.5" cy="17.5" r="3.5"/><circle cx="15" cy="5" r="1"/><path d="M12 17.5V14l-3-3 4-3 2 3h2"/></svg>
                    <% } else if ("SCOOTER".equals(type)) { %>
                        <svg width="68" height="68" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><path d="M6 18h12M11 6h2l2 6H9l2-6z"/></svg>
                    <% } else { %>
                        <svg width="68" height="68" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg>
                    <% } %>
                </div>
<%
    }
%>

                <!-- STATUS BADGE -->
                <span class="status-badge <%= statusBadgeClass %>" style="position: absolute; top: 12px; right: 12px; box-shadow: var(--shadow-sm);">
                    <%= vStatus %>
                </span>

                <!-- CATEGORY PILL -->
                <span style="position: absolute; bottom: 12px; left: 12px; font-size: 0.72rem; font-weight: 700; text-transform: uppercase; background: rgba(7, 9, 14, 0.85); backdrop-filter: blur(8px); color: var(--cyan); padding: 3px 10px; border-radius: var(--radius-pill); border: 1px solid var(--border-cyan);">
                    <%= v.getCategory() != null ? v.getCategory() : type %>
                </span>
            </div>

            <!-- CARD CONTENT -->
            <div class="vehicle-content">

                <!-- TITLE & REGISTRATION -->
                <div class="vehicle-title">
                    <div>
                        <h3 style="font-size: 1.25rem;"><%= v.getBrand() %> <%= v.getModel() %></h3>
                        <span style="font-size: 0.82rem; color: var(--text-muted);"><%= v.getVehicleNumber() %></span>
                    </div>
                </div>

                <!-- SPEC CHIPS WITH SVGS -->
                <div class="vehicle-meta">
                    <div class="vehicle-meta-item">
                        <strong>POWERTRAIN</strong>
                        <span><%= v.getFuelType() != null ? v.getFuelType() : "Petrol" %></span>
                    </div>

                    <div class="vehicle-meta-item">
                        <strong>TRANSMISSION</strong>
                        <span><%= v.getTransmission() != null ? v.getTransmission() : "Manual" %></span>
                    </div>

                    <div class="vehicle-meta-item">
                        <strong>CAPACITY</strong>
                        <span><%= v.getSeats() %> Seats</span>
                    </div>

                    <div class="vehicle-meta-item">
                        <strong>LOCATION</strong>
                        <span><%= v.getLocation() != null ? v.getLocation() : "Central Hub" %></span>
                    </div>
                </div>

                <!-- DESCRIPTION -->
<% if (v.getDescription() != null && !v.getDescription().trim().isEmpty()) { %>
                <p style="font-size: 0.86rem; color: var(--text-secondary); margin-bottom: 16px; line-height: 1.5; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden;">
                    <%= v.getDescription() %>
                </p>
<% } %>

                <!-- PRICING & BOOKING ACTION -->
                <div class="vehicle-footer">
                    <div class="price">
                        <strong>₹<%= String.format("%.0f", v.getPricePerDay()) %></strong>
                        <span>/ day</span>
                    </div>

<% if (isAvail) { %>
                    <a href="${pageContext.request.contextPath}/book?vehicleId=<%= v.getVehicleId() %>" class="btn btn-primary" style="padding: 9px 18px; font-weight: 600;">
                        Book Vehicle
                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
                    </a>
<% } else { %>
                    <button type="button" class="btn btn-secondary" disabled style="opacity: 0.55; cursor: not-allowed; padding: 9px 18px;">
                        <%= "RENTED".equals(vStatus) ? "Currently Rented" : "In Maintenance" %>
                    </button>
<% } %>
                </div>

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
    <p><strong>Vehicle Rental Management System</strong> • Commercial Fleet Directory</p>
    <span>All bookings include basic insurance, roadside protection, and sanitization before handover</span>
</footer>

<!-- SCRIPT FOR INSTANT LIVE SEARCH -->
<script>
function searchVehicleCards() {
    const q = document.getElementById('liveVehicleSearch').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.vehicle-card');
    cards.forEach(card => {
        const meta = card.getAttribute('data-search') || '';
        if (!q || meta.includes(q)) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}

document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    const pickup = document.getElementById('pickupDate');
    const returnD = document.getElementById('returnDate');
    if (pickup) {
        pickup.min = today;
        pickup.addEventListener('change', function() {
            if (returnD) {
                returnD.min = pickup.value;
                if (returnD.value && returnD.value <= pickup.value) {
                    returnD.value = '';
                }
            }
        });
    }
    if (returnD) returnD.min = today;
});
</script>

</body>
</html>