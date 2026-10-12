<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
    if (bookings == null) {
        bookings = new java.util.ArrayList<Booking>();
    }

    String message = request.getParameter("message");
    String error = request.getParameter("error");
    String info = request.getParameter("info");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings | Vehicle Rental</title>
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
            <span>Customer Portal</span>
        </div>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/booking-history" class="active">My Bookings</a>
        <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
        <a href="${pageContext.request.contextPath}/profile">My Profile</a>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container">
    <div class="page-header">
        <div>
            <span class="eyebrow">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
                RESERVATION PORTFOLIO
            </span>
            <h1>My Bookings (<%= bookings.size() %>)</h1>
            <p>Monitor your active trip reservations, execute secure digital payments, and access post-trip reviews.</p>
        </div>
        <div class="page-actions">
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <line x1="12" y1="5" x2="12" y2="19"></line>
                    <line x1="5" y1="12" x2="19" y2="12"></line>
                </svg>
                Book Another Vehicle
            </a>
        </div>
    </div>

    <!-- NOTIFICATION BANNERS -->
    <% if ("cancelled".equals(message)) { %>
        <div class="alert alert-success" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Your booking reservation has been successfully cancelled.
        </div>
    <% } %>
    <% if ("already_paid".equals(info)) { %>
        <div class="alert alert-info" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
            This reservation is already fully settled and verified. Thank you!
        </div>
    <% } %>
    <% if ("already_reviewed".equals(info)) { %>
        <div class="alert alert-info" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12.01" y2="8"></line></svg>
            You have already submitted an experience review for this rental. Thank you!
        </div>
    <% } %>
    <% if ("cancel".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
            Unable to cancel this reservation. It may have already been finalized or processed.
        </div>
    <% } %>

    <!-- BOOKINGS LIST / EMPTY STATE -->
    <% if (bookings.isEmpty()) { %>
        <div class="empty-state">
            <div class="empty-icon" style="background: rgba(99, 102, 241, 0.1); color: var(--primary-light);">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect>
                    <line x1="16" y1="2" x2="16" y2="6"></line>
                    <line x1="8" y1="2" x2="8" y2="6"></line>
                    <line x1="3" y1="10" x2="21" y2="10"></line>
                </svg>
            </div>
            <h2>No Active Bookings Found</h2>
            <p>You have not scheduled any vehicle rentals yet. Browse our verified luxury fleet of high-performance cars, motorcycles, and EV scooters today.</p>
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary btn-lg" style="margin-top: 8px;">
                Explore Available Fleet
            </a>
        </div>
    <% } else { %>
        <div class="dashboard-grid" style="grid-template-columns: repeat(auto-fill, minmax(360px, 1fr));">
            <% for (Booking booking : bookings) {
                String status = booking.getBookingStatus() != null ? booking.getBookingStatus() : "PENDING";
                String paymentStatus = booking.getPaymentStatus() != null ? booking.getPaymentStatus() : "UNPAID";
            %>
                <div class="card card-hover" style="display: flex; flex-direction: column;">
                    <div class="card-header" style="padding-bottom: 12px; margin-bottom: 16px;">
                        <div>
                            <span class="eyebrow" style="margin-bottom: 4px; color: var(--cyan);">
                                RESERVATION #<%= booking.getBookingId() %>
                            </span>
                            <h3 style="font-size: 1.2rem; margin-top: 2px;">
                                <%= booking.getVehicleTitle() != null ? booking.getVehicleTitle() : "Vehicle #" + booking.getVehicleId() %>
                            </h3>
                            <% if (booking.getVehicleNumber() != null) { %>
                                <span style="font-size: 0.8rem; color: var(--text-muted); font-family: monospace; letter-spacing: 0.05em;">
                                    [<%= booking.getVehicleNumber() %>]
                                </span>
                            <% } %>
                        </div>

                        <div style="display: flex; flex-direction: column; align-items: flex-end; gap: 6px;">
                            <% if ("CONFIRMED".equalsIgnoreCase(status)) { %>
                                <span class="badge badge-info"><span class="badge-dot"></span> Confirmed</span>
                            <% } else if ("COMPLETED".equalsIgnoreCase(status)) { %>
                                <span class="badge badge-success"><span class="badge-dot"></span> Completed</span>
                            <% } else if ("PENDING".equalsIgnoreCase(status)) { %>
                                <span class="badge badge-warning"><span class="badge-dot"></span> Pending Approval</span>
                            <% } else { %>
                                <span class="badge badge-danger"><span class="badge-dot"></span> <%= status %></span>
                            <% } %>

                            <% if ("PAID".equalsIgnoreCase(paymentStatus)) { %>
                                <span class="badge badge-success" style="font-size: 0.68rem; padding: 2px 8px;">
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="3" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                                    Paid
                                </span>
                            <% } else if ("CONFIRMED".equalsIgnoreCase(status)) { %>
                                <span class="badge badge-warning" style="font-size: 0.68rem; padding: 2px 8px;">
                                    Payment Due
                                </span>
                            <% } %>
                        </div>
                    </div>

                    <div class="card-body" style="flex: 1;">
                        <div class="vehicle-meta" style="margin-top: 0; margin-bottom: 16px;">
                            <div class="vehicle-meta-item">
                                <strong>Pickup Date</strong>
                                <span><%= booking.getPickupDate() %></span>
                            </div>
                            <div class="vehicle-meta-item">
                                <strong>Return Date</strong>
                                <span><%= booking.getReturnDate() %></span>
                            </div>
                            <div class="vehicle-meta-item">
                                <strong>Duration</strong>
                                <span><%= booking.getRentalDays() %> day(s)</span>
                            </div>
                            <div class="vehicle-meta-item">
                                <strong>Total Rent</strong>
                                <span style="font-weight: 700; color: #a5b4fc; font-family: 'Space Grotesk', sans-serif;">
                                    ₹<%= String.format("%.2f", booking.getTotalAmount()) %>
                                </span>
                            </div>
                        </div>

                        <div style="font-size: 0.84rem; color: var(--text-secondary); background: rgba(255,255,255,0.02); padding: 12px 14px; border-radius: var(--radius-sm); border: 1px solid var(--border-light); margin-bottom: 16px;">
                            <div style="display: flex; align-items: center; gap: 8px;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--cyan)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 2a8 8 0 0 0-8 8c0 5.25 8 12 8 12s8-6.75 8-12a8 8 0 0 0-8-8z"></path><circle cx="12" cy="10" r="3"></circle></svg>
                                <span><strong>Pickup:</strong> <%= booking.getPickupLocation() %></span>
                            </div>
                            <div style="display: flex; align-items: center; gap: 8px; margin-top: 6px;">
                                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="var(--primary-light)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                <span><strong>Drop:</strong> <%= booking.getDropLocation() %></span>
                            </div>
                        </div>
                    </div>

                    <div class="card-footer" style="margin-top: auto; padding-top: 14px;">
                        <div style="display: flex; gap: 8px; flex-wrap: wrap; width: 100%; justify-content: flex-end;">
                            <% if ("CONFIRMED".equalsIgnoreCase(status)) { %>
                                <% if (!"PAID".equalsIgnoreCase(paymentStatus)) { %>
                                    <a href="${pageContext.request.contextPath}/payment?bookingId=<%= booking.getBookingId() %>"
                                       class="btn btn-primary btn-sm">
                                        <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
                                        Pay Now (₹<%= String.format("%.2f", booking.getTotalAmount()) %>)
                                    </a>
                                <% } %>

                                <form action="${pageContext.request.contextPath}/cancel-booking" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-outline btn-sm"
                                            data-confirm="Are you sure you want to cancel this confirmed booking?">
                                        Cancel
                                    </button>
                                </form>
                            <% } else if ("PENDING".equalsIgnoreCase(status)) { %>
                                <form action="${pageContext.request.contextPath}/cancel-booking" method="post" style="display:inline;">
                                    <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                                    <button type="submit" class="btn btn-outline btn-sm"
                                            data-confirm="Cancel this pending booking request?">
                                        Cancel Request
                                    </button>
                                </form>
                            <% } else if ("COMPLETED".equalsIgnoreCase(status)) { %>
                                <a href="${pageContext.request.contextPath}/review?bookingId=<%= booking.getBookingId() %>&vehicleId=<%= booking.getVehicleId() %>"
                                   class="btn btn-secondary btn-sm">
                                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="12 2 15.09 8.26 22 9.27 17 14.14 18.18 21.02 12 17.77 5.82 21.02 7 14.14 2 9.27 8.91 8.26 12 2"></polygon></svg>
                                    Review Vehicle
                                </a>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    <% } %>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Instant Notifications • 24/7 Roadside Assistance</span>
</footer>

</body>
</html>