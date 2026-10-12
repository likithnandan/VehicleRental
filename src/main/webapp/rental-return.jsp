<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>
<%@ page import="model.Booking" %>
<%@ page import="java.time.LocalDate" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null || (!"ADMIN".equals(user.getRole()) && !"STAFF".equals(user.getRole()))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String backUrl = "STAFF".equals(user.getRole()) ? (request.getContextPath() + "/staff") : (request.getContextPath() + "/admin-bookings");

    Booking booking = (Booking) request.getAttribute("booking");
    String bookingIdParam = request.getParameter("bookingId");
    int bookingId = booking != null ? booking.getBookingId() : (bookingIdParam != null && !bookingIdParam.isEmpty() ? Integer.parseInt(bookingIdParam) : 0);

    String todayDate = LocalDate.now().toString();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Process Return | Vehicle Rental</title>
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
            <span><%= "STAFF".equals(user.getRole()) ? "Staff Operations" : "Admin Command" %></span>
        </div>
    </div>

    <div class="nav-links">
        <% if ("STAFF".equals(user.getRole())) { %>
            <a href="${pageContext.request.contextPath}/staff" class="active">Dashboard</a>
            <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin-vehicles">Vehicles</a>
            <a href="${pageContext.request.contextPath}/admin-bookings" class="active">Bookings</a>
            <a href="${pageContext.request.contextPath}/customer-management">Customers</a>
            <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container-narrow">
    <div class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <polyline points="9 11 12 14 22 4"></polyline>
                    <path d="M21 12v7a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11"></path>
                </svg>
                CHECK-IN DISPATCH DESK
            </span>
            <h1>Process Vehicle Return</h1>
            <p>Perform return inspection, verify drop schedule, calculate late charges, and release security hold.</p>
        </div>
        <div class="page-actions">
            <a href="<%= backUrl %>" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="19" y1="12" x2="5" y2="12"></line><polyline points="12 19 5 12 12 5"></polyline></svg>
                Back to <%= "STAFF".equals(user.getRole()) ? "Dashboard" : "Bookings" %>
            </a>
        </div>
    </div>

    <div class="card" style="box-shadow: var(--shadow-card-hover); border-color: rgba(99, 102, 241, 0.25);">
        <% if (booking != null) { %>
            <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 18px 22px; margin-bottom: 24px;">
                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr)); gap: 14px;">
                    <div>
                        <span style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Vehicle Title</span>
                        <div style="font-weight: 700; color: var(--text); font-size: 0.95rem;"><%= booking.getVehicleTitle() != null ? booking.getVehicleTitle() : "ID #" + booking.getVehicleId() %></div>
                    </div>
                    <div>
                        <span style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Plate Number</span>
                        <div style="font-weight: 700; color: var(--primary-light); font-family: monospace; font-size: 0.95rem;"><%= booking.getVehicleNumber() != null ? booking.getVehicleNumber() : "N/A" %></div>
                    </div>
                    <div>
                        <span style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Scheduled Return</span>
                        <div style="font-weight: 700; color: var(--cyan); font-size: 0.95rem;"><%= booking.getReturnDate() %></div>
                    </div>
                    <div>
                        <span style="font-size: 0.72rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Customer ID</span>
                        <div style="font-weight: 700; color: var(--text); font-size: 0.95rem;">#<%= booking.getUserId() %></div>
                    </div>
                </div>
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/rental-return" method="post" id="returnForm">
            <input type="hidden" name="bookingId" value="<%= bookingId %>">

            <div class="form-grid">
                <div class="form-group">
                    <label for="bookingIdDisplay">Booking ID</label>
                    <input type="text" id="bookingIdDisplay" value="#<%= bookingId %>" readonly disabled
                           style="background: rgba(255,255,255,0.02); opacity: 0.8; font-family: monospace;">
                </div>

                <div class="form-group">
                    <label for="actualReturnDate">Actual Return Date *</label>
                    <input type="date" id="actualReturnDate" name="actualReturnDate"
                           value="<%= todayDate %>" required>
                    <span class="field-hint">Late fees (₹500/day) are automatically computed if return exceeds schedule.</span>
                </div>

                <div class="form-group">
                    <label for="vehicleCondition">Vehicle Inspection Condition *</label>
                    <select id="vehicleCondition" name="vehicleCondition" required style="font-weight: 600;">
                        <option value="GOOD">Good Condition - Clean, Intact & Operational</option>
                        <option value="DAMAGED">Damaged - Repairs Required / Body Damage</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="damageCharge">Assessed Damage Charge (₹)</label>
                    <div class="input-with-prefix">
                        <span>₹</span>
                        <input type="number" id="damageCharge" name="damageCharge"
                               min="0" step="0.01" value="0.00" required>
                    </div>
                    <span class="field-hint">Enter 0.00 if vehicle has no damage on return.</span>
                </div>

                <div class="form-group form-group-full">
                    <label for="remarks">Inspection Remarks & Diagnostic Notes</label>
                    <textarea id="remarks" name="remarks" rows="4" maxlength="500"
                              placeholder="Record final odometer reading, return fuel level, scratches, wear, or staff observations..."></textarea>
                </div>
            </div>

            <div class="card-footer" style="margin-top: 28px;">
                <a href="<%= backUrl %>" class="btn btn-secondary">
                    Cancel
                </a>
                <button type="submit" class="btn btn-primary btn-lg"
                        data-confirm="Finalize check-in inspection for Booking #<%= bookingId %>?">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                    Complete Vehicle Check-In
                </button>
            </div>
        </form>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Operations & Return Processing</p>
    <span>Audited Returns • MySQL 8/9 Automated Inventory Release</span>
</footer>

</body>
</html>