<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.Vehicle" %>
<%@ page import="dao.VehicleDAO" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    if (!"CUSTOMER".equals(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");
    if (vehicle == null) {
        String vIdParam = request.getParameter("vehicleId");
        if (vIdParam != null && !vIdParam.trim().isEmpty()) {
            try {
                int vId = Integer.parseInt(vIdParam.trim());
                VehicleDAO vDAO = new VehicleDAO();
                vehicle = vDAO.getVehicleById(vId);
            } catch (Exception e) {
                vehicle = null;
            }
        }
    }

    if (vehicle == null) {
        response.sendRedirect(request.getContextPath() + "/vehicles");
        return;
    }

    double dailyRate = vehicle.getPricePerDay();
    String type = vehicle.getVehicleType() != null ? vehicle.getVehicleType().toUpperCase() : "CAR";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reserve Vehicle | <%= vehicle.getBrand() %> <%= vehicle.getModel() %></title>
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
            <span>Secure Reservation</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
        <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        <a href="${pageContext.request.contextPath}/profile.jsp">Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                VERIFIED CHECKOUT
            </span>
            <h1>Reserve Your Vehicle</h1>
            <p>Select your rental duration and terminal checkpoints. Our team reviews and approves requests immediately.</p>
        </div>

        <div class="hero-buttons">
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Back to Fleet
            </a>
        </div>
    </header>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 32px; align-items: start;">

        <!-- VEHICLE SUMMARY CARD -->
        <article class="card" style="border-color: rgba(99, 102, 241, 0.3);">
            <div class="card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">SELECTED VEHICLE</span>
                    <h2 style="font-size: 1.45rem; margin-top: 4px;"><%= vehicle.getBrand() %> <%= vehicle.getModel() %></h2>
                </div>
                <span class="status-badge status-available"><%= type %></span>
            </div>

            <!-- IMAGE / PLACEHOLDER -->
            <div style="height: 180px; margin: 16px 0; border-radius: var(--radius-md); overflow: hidden; background: #090e18; display: flex; align-items: center; justify-content: center; border: 1px solid var(--border-light);">
<% if (vehicle.getImagePath() != null && !vehicle.getImagePath().trim().isEmpty()) { %>
                <img src="<%= vehicle.getImagePath() %>" alt="<%= vehicle.getFullName() %>" style="width: 100%; height: 100%; object-fit: cover;">
<% } else { %>
                <div style="opacity: 0.3; color: var(--text-secondary);">
                    <% if ("BIKE".equals(type)) { %>
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="18.5" cy="17.5" r="3.5"/><circle cx="5.5" cy="17.5" r="3.5"/><circle cx="15" cy="5" r="1"/><path d="M12 17.5V14l-3-3 4-3 2 3h2"/></svg>
                    <% } else if ("SCOOTER".equals(type)) { %>
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><path d="M6 18h12M11 6h2l2 6H9l2-6z"/></svg>
                    <% } else { %>
                        <svg width="60" height="60" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg>
                    <% } %>
                </div>
<% } %>
            </div>

            <!-- SPECS GRID -->
            <div class="booking-details-grid" style="margin-bottom: 20px;">
                <div class="info-item">
                    <span class="info-label">License Plate</span>
                    <strong><%= vehicle.getVehicleNumber() %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Category</span>
                    <strong><%= vehicle.getCategory() != null ? vehicle.getCategory() : type %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Powertrain</span>
                    <strong><%= vehicle.getFuelType() %> • <%= vehicle.getTransmission() %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Passenger Capacity</span>
                    <strong><%= vehicle.getSeats() %> Persons</strong>
                </div>
            </div>

            <!-- DAILY TARIFF -->
            <div class="booking-total" style="margin-top: 10px;">
                <span>Daily Rental Tariff</span>
                <strong style="color: var(--cyan);">₹<%= String.format("%.2f", dailyRate) %> <small style="font-size: 0.82rem; font-weight: normal; color: var(--text-muted);">/ day</small></strong>
            </div>
        </article>

        <!-- RESERVATION FORM -->
        <section class="card" style="border-color: rgba(6, 182, 212, 0.3);">
            <div class="card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">RESERVATION SPECIFICATION</span>
                    <h2 style="font-size: 1.45rem; margin-top: 4px;">Rental Schedule & Route</h2>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/book" method="post" id="bookingForm" onsubmit="return validateBookingForm();" style="margin-top: 20px;">
                <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">

                <div class="form-grid">

                    <!-- PICKUP DATE -->
                    <div class="form-group">
                        <label for="pickupDate">Pickup Date <span style="color: var(--danger);">*</span></label>
                        <input type="date" id="pickupDate" name="pickupDate" required onchange="calculateRentalPrice()">
                    </div>

                    <!-- RETURN DATE -->
                    <div class="form-group">
                        <label for="returnDate">Return Date <span style="color: var(--danger);">*</span></label>
                        <input type="date" id="returnDate" name="returnDate" required onchange="calculateRentalPrice()">
                    </div>

                    <!-- PICKUP LOCATION -->
                    <div class="form-group form-group-full">
                        <label for="pickupLocation">Pickup Location & Landmark <span style="color: var(--danger);">*</span></label>
                        <input type="text" id="pickupLocation" name="pickupLocation" required maxlength="100" placeholder="e.g. Central Terminal, Airport Departure Gate 3" value="<%= vehicle.getLocation() != null ? vehicle.getLocation() : "" %>">
                    </div>

                    <!-- DROP LOCATION -->
                    <div class="form-group form-group-full">
                        <label for="dropLocation">Drop-off Destination <span style="color: var(--danger);">*</span></label>
                        <input type="text" id="dropLocation" name="dropLocation" required maxlength="100" placeholder="e.g. Airport Terminal 1, City Hub, Downtown" value="<%= vehicle.getLocation() != null ? vehicle.getLocation() : "" %>">
                    </div>

                </div>

                <!-- DYNAMIC LIVE PRICE BREAKDOWN -->
                <div id="priceCalculationBox" style="margin: 24px 0 20px; padding: 18px 20px; background: rgba(99, 102, 241, 0.08); border: 1px solid var(--border-accent); border-radius: var(--radius-md);">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                        <span style="font-size: 0.88rem; color: var(--text-secondary);">Calculated Duration</span>
                        <strong id="displayDuration" style="color: var(--text);">0 days</strong>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 12px;">
                        <span style="font-size: 0.88rem; color: var(--text-secondary);">Daily Tariff</span>
                        <span style="color: var(--text);">₹<%= String.format("%.2f", dailyRate) %></span>
                    </div>

                    <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(148, 163, 184, 0.15); padding-top: 12px;">
                        <strong style="font-size: 1.1rem; color: #fff;">Estimated Total Amount</strong>
                        <strong id="displayTotal" style="font-size: 1.45rem; color: var(--cyan); font-family: 'Space Grotesk', sans-serif;">₹0.00</strong>
                    </div>
                </div>

                <!-- SUBMIT ACTIONS -->
                <div class="form-actions" style="margin-top: 24px; display: flex; gap: 14px;">
                    <button type="submit" class="btn btn-primary" id="confirmBookingBtn" style="flex: 1; padding: 12px 20px; font-weight: 700; font-size: 1rem;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px;"><polyline points="20 6 9 17 4 12"></polyline></svg>
                        Confirm Reservation Request
                    </button>
                    <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-secondary" style="padding: 12px 20px;">
                        Cancel
                    </a>
                </div>
            </form>
        </section>

    </div>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Instant Booking Verification</p>
    <span>All transactions encrypted • 24/7 Concierge Support</span>
</footer>

<!-- DYNAMIC LIVE PRICING & VALIDATION SCRIPT -->
<script>
const dailyRate = <%= dailyRate %>;

document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    const pickupInput = document.getElementById('pickupDate');
    const returnInput = document.getElementById('returnDate');

    pickupInput.min = today;
    returnInput.min = today;

    pickupInput.addEventListener('change', function() {
        returnInput.min = pickupInput.value;
        if (returnInput.value && returnInput.value <= pickupInput.value) {
            returnInput.value = '';
        }
        calculateRentalPrice();
    });
});

function calculateRentalPrice() {
    const pickupVal = document.getElementById('pickupDate').value;
    const returnVal = document.getElementById('returnDate').value;

    if (!pickupVal || !returnVal) {
        document.getElementById('displayDuration').textContent = '0 days';
        document.getElementById('displayTotal').textContent = '₹0.00';
        return;
    }

    const pDate = new Date(pickupVal);
    const rDate = new Date(returnVal);
    const diffTime = rDate.getTime() - pDate.getTime();
    const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

    if (diffDays > 0) {
        const total = diffDays * dailyRate;
        document.getElementById('displayDuration').textContent = diffDays + (diffDays === 1 ? ' day' : ' days');
        document.getElementById('displayTotal').textContent = '₹' + total.toFixed(2);
    } else {
        document.getElementById('displayDuration').textContent = '0 days';
        document.getElementById('displayTotal').textContent = '₹0.00';
    }
}

function validateBookingForm() {
    const pickupVal = document.getElementById('pickupDate').value;
    const returnVal = document.getElementById('returnDate').value;
    const pickupLoc = document.getElementById('pickupLocation').value.trim();
    const dropLoc = document.getElementById('dropLocation').value.trim();

    if (!pickupVal || !returnVal) {
        alert('Please select both pickup and return dates.');
        return false;
    }

    const today = new Date().toISOString().split('T')[0];
    if (pickupVal < today) {
        alert('Pickup date cannot be in the past.');
        return false;
    }

    if (returnVal <= pickupVal) {
        alert('Return date must be strictly after the pickup date.');
        return false;
    }

    if (pickupLoc.length < 2) {
        alert('Please specify a valid pickup location.');
        return false;
    }

    if (dropLoc.length < 2) {
        alert('Please specify a valid drop destination.');
        return false;
    }

    return true;
}
</script>

</body>
</html>