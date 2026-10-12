<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
    if (vehicle == null) {
        response.sendRedirect(request.getContextPath() + "/admin-vehicles");
        return;
    }

    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit <%= vehicle.getBrand() %> <%= vehicle.getModel() %> | Vehicle Rental Admin</title>
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
            <span>Admin Portal</span>
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
                    <path d="M12 20h9"></path>
                    <path d="M16.5 3.5a2.121 2.121 0 0 1 3 3L7 19l-4 1 1-4L16.5 3.5z"></path>
                </svg>
                FLEET SPECIFICATION MODIFIER
            </span>
            <h1>Edit <%= vehicle.getBrand() %> <%= vehicle.getModel() %></h1>
            <p>Update vehicle parameters, daily rental rate, availability state, and terminal hub location.</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Back to Fleet
            </a>
        </div>
    </div>

    <% if (error != null) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
            <% if ("duplicate".equals(error)) { %>
                Another vehicle already has this registration plate number.
            <% } else if ("status".equals(error)) { %>
                Invalid status specified.
            <% } else { %>
                Failed to update vehicle. Please ensure all inputs are valid.
            <% } %>
        </div>
    <% } %>

    <div class="form-container">
        <div class="form-card card" style="box-shadow: var(--shadow-card-hover); border-color: rgba(99, 102, 241, 0.3);">
            <form action="${pageContext.request.contextPath}/edit-vehicle" method="post" id="editVehicleForm">
                <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">

                <div class="form-grid">
                    <!-- REGISTRATION NUMBER -->
                    <div class="form-group">
                        <label for="vehicleNumber">Registration Number / Plate *</label>
                        <input type="text" id="vehicleNumber" name="vehicleNumber"
                               value="<%= vehicle.getVehicleNumber() %>" maxlength="20" required>
                    </div>

                    <!-- STATUS -->
                    <div class="form-group">
                        <label for="status">Operational Status *</label>
                        <select id="status" name="status" required style="font-weight: 600;">
                            <option value="AVAILABLE" <%= "AVAILABLE".equalsIgnoreCase(vehicle.getStatus()) ? "selected" : "" %>>
                                AVAILABLE - Ready for Instant Reservation
                            </option>
                            <option value="BOOKED" <%= "BOOKED".equalsIgnoreCase(vehicle.getStatus()) ? "selected" : "" %>>
                                BOOKED - Reserved / Awaiting Handover
                            </option>
                            <option value="RENTED" <%= "RENTED".equalsIgnoreCase(vehicle.getStatus()) ? "selected" : "" %>>
                                RENTED - Active Customer Journey
                            </option>
                            <option value="MAINTENANCE" <%= "MAINTENANCE".equalsIgnoreCase(vehicle.getStatus()) ? "selected" : "" %>>
                                MAINTENANCE - In Workshop Repair
                            </option>
                        </select>
                    </div>

                    <!-- VEHICLE TYPE -->
                    <div class="form-group">
                        <label for="vehicleType">Vehicle Type *</label>
                        <select id="vehicleType" name="vehicleType" required style="font-weight: 500;">
                            <option value="CAR" <%= "CAR".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>Car</option>
                            <option value="BIKE" <%= "BIKE".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>Bike / Motorcycle</option>
                            <option value="SCOOTER" <%= "SCOOTER".equalsIgnoreCase(vehicle.getVehicleType()) ? "selected" : "" %>>Scooter / Moped</option>
                        </select>
                    </div>

                    <!-- BRAND -->
                    <div class="form-group">
                        <label for="brand">Brand / Make *</label>
                        <input type="text" id="brand" name="brand"
                               value="<%= vehicle.getBrand() %>" maxlength="50" required>
                    </div>

                    <!-- MODEL -->
                    <div class="form-group">
                        <label for="model">Model Name *</label>
                        <input type="text" id="model" name="model"
                               value="<%= vehicle.getModel() %>" maxlength="50" required>
                    </div>

                    <!-- CATEGORY -->
                    <div class="form-group">
                        <label for="category">Category *</label>
                        <input type="text" id="category" name="category"
                               value="<%= vehicle.getCategory() %>" maxlength="50" required>
                    </div>

                    <!-- FUEL TYPE -->
                    <div class="form-group">
                        <label for="fuelType">Fuel Type *</label>
                        <select id="fuelType" name="fuelType" required style="font-weight: 500;">
                            <option value="PETROL" <%= "PETROL".equalsIgnoreCase(vehicle.getFuelType()) ? "selected" : "" %>>Petrol</option>
                            <option value="DIESEL" <%= "DIESEL".equalsIgnoreCase(vehicle.getFuelType()) ? "selected" : "" %>>Diesel</option>
                            <option value="ELECTRIC" <%= "ELECTRIC".equalsIgnoreCase(vehicle.getFuelType()) ? "selected" : "" %>>Electric (EV)</option>
                        </select>
                    </div>

                    <!-- TRANSMISSION -->
                    <div class="form-group">
                        <label for="transmission">Transmission *</label>
                        <select id="transmission" name="transmission" required style="font-weight: 500;">
                            <option value="AUTOMATIC" <%= "AUTOMATIC".equalsIgnoreCase(vehicle.getTransmission()) ? "selected" : "" %>>Automatic</option>
                            <option value="MANUAL" <%= "MANUAL".equalsIgnoreCase(vehicle.getTransmission()) ? "selected" : "" %>>Manual</option>
                        </select>
                    </div>

                    <!-- SEATS -->
                    <div class="form-group">
                        <label for="seats">Seating Capacity *</label>
                        <input type="number" id="seats" name="seats"
                               value="<%= vehicle.getSeats() %>" min="1" max="50" required>
                    </div>

                    <!-- DAILY RATE -->
                    <div class="form-group">
                        <label for="pricePerDay">Daily Rental Rate (₹) *</label>
                        <div class="input-with-prefix">
                            <span>₹</span>
                            <input type="number" id="pricePerDay" name="pricePerDay"
                                   value="<%= vehicle.getPricePerDay() %>" step="0.01" min="1" required>
                        </div>
                    </div>

                    <!-- LOCATION -->
                    <div class="form-group">
                        <label for="location">Pickup Hub / Location *</label>
                        <input type="text" id="location" name="location"
                               value="<%= vehicle.getLocation() %>" maxlength="100" required>
                    </div>

                    <!-- IMAGE URL -->
                    <div class="form-group form-group-full">
                        <label for="imagePath">Vehicle Preview Image URL</label>
                        <input type="text" id="imagePath" name="imagePath"
                               value="<%= vehicle.getImagePath() != null ? vehicle.getImagePath() : "" %>" maxlength="500">
                    </div>

                    <!-- DESCRIPTION -->
                    <div class="form-group form-group-full">
                        <label for="description">Specifications & Key Features</label>
                        <textarea id="description" name="description" rows="4" maxlength="1000"><%= vehicle.getDescription() != null ? vehicle.getDescription() : "" %></textarea>
                    </div>
                </div>

                <div class="card-footer" style="margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                        Save Vehicle Changes
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Fleet Administration</p>
    <span>Audited Inventory • MySQL 8/9 Persistence</span>
</footer>

</body>
</html>