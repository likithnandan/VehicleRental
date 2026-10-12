<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Booking" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Booking booking = (Booking) request.getAttribute("booking");
    Vehicle vehicle = (Vehicle) request.getAttribute("vehicle");

    String bookingIdParam = request.getParameter("bookingId");
    String vehicleIdParam = request.getParameter("vehicleId");

    int bookingId = booking != null ? booking.getBookingId() : (bookingIdParam != null ? Integer.parseInt(bookingIdParam) : 0);
    int vehicleId = vehicle != null ? vehicle.getVehicleId() : (bookingId != 0 && booking != null ? booking.getVehicleId() : (vehicleIdParam != null ? Integer.parseInt(vehicleIdParam) : 0));

    String vehicleTitle = vehicle != null ? (vehicle.getBrand() + " " + vehicle.getModel()) : (booking != null && booking.getVehicleTitle() != null ? booking.getVehicleTitle() : "Vehicle #" + vehicleId);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Rate Experience | Vehicle Rental</title>
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
            <span>Customer Feedback</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container-narrow">
    <div class="auth-wrapper" style="min-height: auto; padding: 24px 0;">
        <div class="card" style="width: 100%; max-width: 580px; box-shadow: var(--shadow-card-hover), 0 0 45px rgba(99, 102, 241, 0.15); border-color: rgba(99, 102, 241, 0.3);">
            
            <div style="text-align: center; margin-bottom: 26px;">
                <div class="logo-mark" style="width: 56px; height: 56px; margin: 0 auto 16px; background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%); border-color: rgba(245, 158, 11, 0.4); box-shadow: 0 4px 20px rgba(245, 158, 11, 0.3);">
                    <svg width="28" height="28" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon>
                    </svg>
                </div>
                <span class="eyebrow" style="color: #fbbf24;">VERIFIED DRIVER RATING</span>
                <h2 style="font-size: 1.6rem; margin-top: 4px;">Rate & Review Vehicle</h2>
                <p style="color: var(--text-secondary); font-size: 0.92rem;">Share your driving impressions, comfort levels, and fleet condition.</p>
            </div>

            <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 18px 22px; margin-bottom: 24px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                    <span style="font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase;">Vehicle Driven</span>
                    <strong style="color: var(--primary-light); font-size: 1.05rem;"><%= vehicleTitle %></strong>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase;">Rental Reference</span>
                    <span style="color: var(--text); font-family: monospace; font-size: 0.9rem;">BOOKING #<%= bookingId %></span>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/review" method="post" id="reviewForm">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">
                <input type="hidden" name="vehicleId" value="<%= vehicleId %>">

                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="rating">Overall Vehicle Rating *</label>
                    <select id="rating" name="rating" required style="font-weight: 600;">
                        <option value="">-- Select score (1 to 5 stars) --</option>
                        <option value="5">5 / 5 - Exceptional Performance & Pristine Cleanliness</option>
                        <option value="4">4 / 5 - Very Good, Smooth Driving & Reliable</option>
                        <option value="3">3 / 5 - Average / Met Basic Commute Expectations</option>
                        <option value="2">2 / 5 - Below Average / Minor Mechanical or Cleanliness Issue</option>
                        <option value="1">1 / 5 - Poor Experience / Unacceptable Issues</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 24px;">
                    <label for="comment">Your Detailed Feedback *</label>
                    <textarea id="comment" name="comment" rows="5" maxlength="500" required
                              placeholder="Describe ride handling, fuel efficiency, air conditioning, interior hygiene, and pickup experience..."></textarea>
                    <span class="field-hint">Maximum 500 characters. Visible publicly on vehicle review highlights.</span>
                </div>

                <div class="card-footer" style="padding-top: 18px; margin-top: 18px;">
                    <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-secondary">
                        Back to Bookings
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="22" y1="2" x2="11" y2="13"></line><polygon points="22 2 15 22 11 13 2 9 22 2"></polygon></svg>
                        Submit Review
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Customer Feedback System</span>
</footer>

</body>
</html>