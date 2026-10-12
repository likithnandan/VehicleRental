<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    if (vehicles == null) {
        vehicles = new java.util.ArrayList<Vehicle>();
    }

    String error = request.getParameter("error");

    long availableCount = vehicles.stream().filter(v -> "AVAILABLE".equalsIgnoreCase(v.getStatus())).count();
    long rentedCount = vehicles.stream().filter(v -> "BOOKED".equalsIgnoreCase(v.getStatus()) || "RENTED".equalsIgnoreCase(v.getStatus())).count();
    long maintenanceCount = vehicles.stream().filter(v -> "MAINTENANCE".equalsIgnoreCase(v.getStatus())).count();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fleet Inventory | Vehicle Rental Admin</title>
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
            <span>Fleet Administration</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin-vehicles" class="active">Vehicles</a>
        <a href="${pageContext.request.contextPath}/admin-customers">Customers</a>
        <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container">
    <div class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.5 2.8C2.1 10.8 2 11 2 11.2V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/>
                </svg>
                FLEET AUDIT & ASSET INVENTORY
            </span>
            <h1>Fleet Inventory (<%= vehicles.size() %>)</h1>
            <p>Maintain vehicle specifications, daily rental tariffs, operational availability, and plate registrations.</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/add-vehicle" class="btn btn-primary btn-lg">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Add New Vehicle
            </a>
        </div>
    </div>

    <!-- NOTIFICATION BANNERS -->
    <% if ("inuse".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
            Cannot delete vehicle: active or pending customer bookings currently depend on this unit.
        </div>
    <% } else if ("delete".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            Failed to remove vehicle. Please verify database constraints and try again.
        </div>
    <% } else if ("duplicate".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            A vehicle with this registration plate number already exists in the system.
        </div>
    <% } %>

    <!-- FLEET QUICK STATS -->
    <div class="dashboard-grid" style="grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); margin-bottom: 28px;">
        <div class="stat-card" style="padding: 20px 22px;">
            <span class="stat-label">Total Fleet Units</span>
            <div class="stat-value" style="font-size: 2rem; margin-top: 6px;"><%= vehicles.size() %></div>
            <span class="stat-desc">All registered inventory</span>
        </div>
        <div class="stat-card" style="padding: 20px 22px;">
            <span class="stat-label">Ready / Available</span>
            <div class="stat-value" style="font-size: 2rem; margin-top: 6px; color: var(--success);"><%= availableCount %></div>
            <span class="stat-desc">Open for booking</span>
        </div>
        <div class="stat-card" style="padding: 20px 22px;">
            <span class="stat-label">Booked / On-Road</span>
            <div class="stat-value" style="font-size: 2rem; margin-top: 6px; color: var(--cyan);"><%= rentedCount %></div>
            <span class="stat-desc">Active customer journeys</span>
        </div>
        <div class="stat-card" style="padding: 20px 22px;">
            <span class="stat-label">In Garage / Service</span>
            <div class="stat-value" style="font-size: 2rem; margin-top: 6px; color: var(--danger);"><%= maintenanceCount %></div>
            <span class="stat-desc">Under maintenance inspection</span>
        </div>
    </div>

    <!-- VEHICLES TABLE -->
    <% if (!vehicles.isEmpty()) { %>
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th>Vehicle & Plate</th>
                        <th>Type / Category</th>
                        <th>Powertrain Specs</th>
                        <th>Hub Location</th>
                        <th>Daily Rate</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Vehicle v : vehicles) {
                        String st = v.getStatus() != null ? v.getStatus() : "AVAILABLE";
                    %>
                        <tr>
                            <td>
                                <div style="display: flex; align-items: center; gap: 14px;">
                                    <% if (v.getImagePath() != null && !v.getImagePath().trim().isEmpty()) { %>
                                        <img src="<%= v.getImagePath() %>" alt="<%= v.getFullName() %>"
                                             style="width: 54px; height: 38px; object-fit: cover; border-radius: var(--radius-sm); border: 1px solid var(--border);"
                                             onerror="this.style.display='none'">
                                    <% } %>
                                    <div>
                                        <strong style="color: #fff; font-size: 0.95rem;"><%= v.getBrand() %> <%= v.getModel() %></strong>
                                        <div style="font-size: 0.78rem; font-family: monospace; color: var(--text-muted); letter-spacing: 0.04em;">
                                            <%= v.getVehicleNumber() %>
                                        </div>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <span class="badge badge-info" style="font-size: 0.7rem; padding: 2px 8px;">
                                        <%= v.getVehicleType() %>
                                    </span>
                                    <div style="font-size: 0.78rem; color: var(--text-muted); margin-top: 4px;">
                                        <%= v.getCategory() %>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <div style="font-size: 0.82rem; color: var(--text-secondary);">
                                    <%= v.getFuelType() %> • <%= v.getTransmission() %>
                                    <div style="color: var(--text-muted); font-size: 0.76rem; margin-top: 2px;"><%= v.getSeats() %> Passenger Seats</div>
                                </div>
                            </td>
                            <td>
                                <div style="display: flex; align-items: center; gap: 6px; font-size: 0.86rem;">
                                    <svg width="13" height="13" viewBox="0 0 24 24" fill="none" stroke="var(--cyan)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2a8 8 0 0 0-8 8c0 5.25 8 12 8 12s8-6.75 8-12a8 8 0 0 0-8-8z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                    <%= v.getLocation() %>
                                </div>
                            </td>
                            <td>
                                <strong style="color: #a5b4fc; font-family: 'Space Grotesk', sans-serif; font-size: 1.05rem;">
                                    ₹<%= String.format("%.2f", v.getPricePerDay()) %>
                                </strong>
                                <span style="font-size: 0.72rem; color: var(--text-muted);">/day</span>
                            </td>
                            <td>
                                <% if ("AVAILABLE".equalsIgnoreCase(st)) { %>
                                    <span class="badge badge-success"><span class="badge-dot"></span> Available</span>
                                <% } else if ("BOOKED".equalsIgnoreCase(st)) { %>
                                    <span class="badge badge-warning"><span class="badge-dot"></span> Booked</span>
                                <% } else if ("RENTED".equalsIgnoreCase(st)) { %>
                                    <span class="badge badge-info"><span class="badge-dot"></span> Rented</span>
                                <% } else if ("MAINTENANCE".equalsIgnoreCase(st)) { %>
                                    <span class="badge badge-danger"><span class="badge-dot"></span> Garage</span>
                                <% } else { %>
                                    <span class="badge badge-secondary"><%= st %></span>
                                <% } %>
                            </td>
                            <td>
                                <div class="table-actions">
                                    <a href="${pageContext.request.contextPath}/admin-vehicles?action=edit&vehicleId=<%= v.getVehicleId() %>"
                                       class="btn btn-outline btn-sm">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 20h9"></path><path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path></svg>
                                        Edit
                                    </a>
                                    <a href="${pageContext.request.contextPath}/delete-vehicle?vehicleId=<%= v.getVehicleId() %>"
                                       class="btn btn-danger btn-sm"
                                       data-confirm="Are you sure you want to permanently remove <%= v.getBrand() %> <%= v.getModel() %> (<%= v.getVehicleNumber() %>)?">
                                        <svg width="12" height="12" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="3 6 5 6 21 6"></polyline><path d="M19 6v14a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V6m3 0V4a2 2 0 0 1 2-2h4a2 2 0 0 1 2 2v2"></path></svg>
                                        Delete
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } else { %>
        <div class="empty-state">
            <div class="empty-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-light);">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.5 2.8C2.1 10.8 2 11 2 11.2V16c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/>
                </svg>
            </div>
            <h3>No Vehicles in Fleet Inventory</h3>
            <p>Your fleet database is currently empty. Register your first vehicle to allow customer search and booking.</p>
            <a href="${pageContext.request.contextPath}/add-vehicle" class="btn btn-primary btn-lg" style="margin-top: 8px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Register First Vehicle
            </a>
        </div>
    <% } %>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Fleet Command</p>
    <span>Audited Inventory • MySQL 8/9 Persistence</span>
</footer>

</body>
</html>