<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Booking" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    Booking booking = (Booking) request.getAttribute("booking");
    String bookingIdParam = request.getParameter("bookingId");
    String amountParam = request.getParameter("amount");

    int bookingId = 0;
    double amount = 0.0;
    String vehicleName = "Reserved Vehicle";

    if (booking != null) {
        bookingId = booking.getBookingId();
        amount = booking.getTotalAmount();
        vehicleName = booking.getVehicleTitle() != null ? booking.getVehicleTitle() : "Vehicle #" + booking.getVehicleId();
    } else if (bookingIdParam != null && !bookingIdParam.trim().isEmpty()) {
        try {
            bookingId = Integer.parseInt(bookingIdParam.trim());
            if (amountParam != null && !amountParam.trim().isEmpty()) {
                amount = Double.parseDouble(amountParam.trim());
            }
        } catch (Exception ignored) {}
    }

    if (bookingId <= 0) {
        response.sendRedirect(request.getContextPath() + "/booking-history");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Encrypted Checkout | Vehicle Rental</title>
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
            <span>Secure Checkout</span>
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
        <div class="card" style="width: 100%; max-width: 560px; box-shadow: var(--shadow-card-hover), 0 0 45px rgba(99, 102, 241, 0.15); border-color: rgba(99, 102, 241, 0.3);">
            
            <div style="text-align: center; margin-bottom: 28px;">
                <div class="logo-mark" style="width: 54px; height: 54px; margin: 0 auto 16px; background: linear-gradient(135deg, var(--primary) 0%, #4338ca 100%);">
                    <svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect>
                        <line x1="1" y1="10" x2="23" y2="10"></line>
                    </svg>
                </div>
                <span class="eyebrow" style="color: var(--cyan);">ENCRYPTED 256-BIT SETTLEMENT</span>
                <h2 style="font-size: 1.6rem; margin-top: 4px;">Complete Rental Payment</h2>
                <p style="color: var(--text-secondary); font-size: 0.92rem;">Authorize your reservation charge through our verified payment gateway.</p>
            </div>

            <!-- BOOKING SUMMARY BOX -->
            <div style="background: rgba(255, 255, 255, 0.02); border: 1px solid var(--border); border-radius: var(--radius-md); padding: 20px 24px; margin-bottom: 24px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 10px;">
                    <span style="font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Reservation Ref</span>
                    <strong style="color: var(--text); font-family: monospace; font-size: 0.95rem;">BOOKING #<%= bookingId %></strong>
                </div>
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px;">
                    <span style="font-size: 0.85rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.04em;">Selected Fleet Vehicle</span>
                    <strong style="color: var(--primary-light); font-size: 1.05rem;"><%= vehicleName %></strong>
                </div>
                <div style="height: 1px; background: var(--border-light); margin-bottom: 16px;"></div>
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <span style="font-size: 0.95rem; font-weight: 600; color: var(--text);">Total Amount Payable</span>
                    <strong style="font-family: 'Space Grotesk', sans-serif; font-size: 1.7rem; color: var(--cyan);">
                        ₹<%= String.format("%.2f", amount) %>
                    </strong>
                </div>
            </div>

            <!-- PAYMENT FORM -->
            <form action="${pageContext.request.contextPath}/payment" method="post" id="paymentForm">
                <input type="hidden" name="bookingId" value="<%= bookingId %>">

                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="paymentMethod">Select Payment Method *</label>
                    <select id="paymentMethod" name="paymentMethod" required style="font-weight: 500;">
                        <option value="">-- Choose payment gateway --</option>
                        <option value="UPI">UPI Instant (Google Pay, PhonePe, Paytm, BHIM)</option>
                        <option value="CARD">Credit / Debit Card (Visa, Mastercard, RuPay)</option>
                        <option value="CASH">Pay at Pickup Hub (Cash / POS Terminal)</option>
                    </select>
                </div>

                <div style="display: flex; gap: 14px; align-items: center; background: rgba(16, 185, 129, 0.08); border: 1px solid var(--success-border); border-radius: var(--radius-sm); padding: 14px 18px; margin-bottom: 24px;">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#6ee7b7" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink: 0;">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                    <div style="font-size: 0.82rem; color: #a7f3d0; line-height: 1.45;">
                        <strong>Instant Verification:</strong> Transaction is cryptographically authorized and logged into MySQL persistence immediately upon submission.
                    </div>
                </div>

                <div style="display: flex; gap: 12px;">
                    <a href="${pageContext.request.contextPath}/booking-history" class="btn btn-secondary" style="flex: 1;">
                        Cancel
                    </a>
                    <button type="submit" class="btn btn-primary" style="flex: 2;">
                        <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        Confirm & Pay ₹<%= String.format("%.2f", amount) %>
                    </button>
                </div>
            </form>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>PCI DSS Compliant Sandbox Protocol</span>
</footer>

</body>
</html>