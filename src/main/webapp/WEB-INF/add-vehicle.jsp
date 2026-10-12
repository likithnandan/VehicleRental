<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"ADMIN".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Vehicle | Vehicle Rental Admin</title>
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
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                FLEET EXPANSION & ACQUISITION
            </span>
            <h1>Add New Vehicle</h1>
            <p>Register a new car, motorcycle, or electric scooter into the rental fleet database.</p>
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
                A vehicle with this registration plate number already exists in the system.
            <% } else if ("invalid".equals(error) || "empty".equals(error)) { %>
                Please complete all required fields with valid details.
            <% } else if ("price".equals(error)) { %>
                Invalid price per day specified. Must be greater than 0.
            <% } else if ("seats".equals(error)) { %>
                Invalid seat count. Must be between 1 and 50.
            <% } else { %>
                Unable to add vehicle. Please verify input data and try again.
            <% } %>
        </div>
    <% } %>

    <div class="form-container">
        <div class="form-card card" style="box-shadow: var(--shadow-card-hover); border-color: rgba(99, 102, 241, 0.3);">
            <form action="${pageContext.request.contextPath}/add-vehicle" method="post" id="addVehicleForm">
                <div class="form-grid">

                    <!-- REGISTRATION NUMBER -->
                    <div class="form-group">
                        <label for="vehicleNumber">Registration Number / Plate *</label>
                        <input type="text" id="vehicleNumber" name="vehicleNumber"
                               placeholder="e.g. KA-01-AB-1234" maxlength="20" required>
                        <span class="field-hint">Uppercase alphanumeric registration format.</span>
                    </div>

                    <!-- VEHICLE TYPE -->
                    <div class="form-group">
                        <label for="vehicleType">Vehicle Type *</label>
                        <select id="vehicleType" name="vehicleType" required style="font-weight: 600;">
                            <option value="CAR">Car</option>
                            <option value="BIKE">Bike / Motorcycle</option>
                            <option value="SCOOTER">Scooter / Moped</option>
                        </select>
                    </div>

                    <!-- BRAND -->
                    <div class="form-group">
                        <label for="brand">Brand / Manufacturer *</label>
                        <input type="text" id="brand" name="brand"
                               placeholder="e.g. Toyota, BMW, Royal Enfield" maxlength="50" required>
                    </div>

                    <!-- MODEL -->
                    <div class="form-group">
                        <label for="model">Model Name *</label>
                        <input type="text" id="model" name="model"
                               placeholder="e.g. Fortuner, M3 Competition, Hunter 350" maxlength="50" required>
                    </div>

                    <!-- CATEGORY -->
                    <div class="form-group">
                        <label for="category">Category *</label>
                        <input type="text" id="category" name="category"
                               placeholder="e.g. SUV, Luxury Sedan, Sports, Cruiser" maxlength="50" required>
                    </div>

                    <!-- FUEL TYPE -->
                    <div class="form-group">
                        <label for="fuelType">Fuel Type *</label>
                        <select id="fuelType" name="fuelType" required style="font-weight: 500;">
                            <option value="PETROL">Petrol</option>
                            <option value="DIESEL">Diesel</option>
                            <option value="ELECTRIC">Electric (EV)</option>
                        </select>
                    </div>

                    <!-- TRANSMISSION -->
                    <div class="form-group">
                        <label for="transmission">Transmission *</label>
                        <select id="transmission" name="transmission" required style="font-weight: 500;">
                            <option value="AUTOMATIC">Automatic</option>
                            <option value="MANUAL">Manual</option>
                        </select>
                    </div>

                    <!-- SEATING CAPACITY -->
                    <div class="form-group">
                        <label for="seats">Seating Capacity *</label>
                        <input type="number" id="seats" name="seats"
                               value="5" min="1" max="50" required>
                    </div>

                    <!-- DAILY RATE -->
                    <div class="form-group">
                        <label for="pricePerDay">Daily Rental Rate (₹) *</label>
                        <div class="input-with-prefix">
                            <span>₹</span>
                            <input type="number" id="pricePerDay" name="pricePerDay"
                                   step="0.01" min="1" placeholder="2500.00" required>
                        </div>
                    </div>

                    <!-- HUB LOCATION -->
                    <div class="form-group">
                        <label for="location">Pickup Hub / Terminal *</label>
                        <input type="text" id="location" name="location"
                               placeholder="e.g. Downtown Central Terminal, Airport Hub" maxlength="100" required>
                    </div>

                    <!-- IMAGE URL -->
                    <div class="form-group form-group-full">
                        <label for="imagePath">Vehicle Preview Image URL</label>
                        <input type="text" id="imagePath" name="imagePath"
                               placeholder="https://images.unsplash.com/... or /images/car.jpg" maxlength="500">
                        <span class="field-hint">Paste high-resolution web URL or local asset path.</span>
                    </div>

                    <!-- DESCRIPTION -->
                    <div class="form-group form-group-full">
                        <label for="description">Specifications & Key Features</label>
                        <textarea id="description" name="description" rows="4" maxlength="1000"
                                  placeholder="List key amenities: panoramic sunroof, Apple CarPlay, lane assist, heated seats, ABS brakes, horsepower, etc."></textarea>
                    </div>

                </div>

                <div class="card-footer" style="margin-top: 28px;">
                    <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary btn-lg">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <line x1="12" y1="5" x2="12" y2="19"></line>
                            <line x1="5" y1="12" x2="19" y2="12"></line>
                        </svg>
                        Add Vehicle to Fleet
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Fleet Expansion Portal</p>
    <span>MySQL 8/9 Asset Persistence Engine</span>
</footer>

</body>
</html>