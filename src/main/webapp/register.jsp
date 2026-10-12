<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account | Vehicle Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/app.js" defer></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <div class="nav-brand">
        <a href="${pageContext.request.contextPath}/index.jsp" style="display:flex; align-items:center; gap:12px;">
            <div class="logo-mark">VR</div>
            <div>
                <strong>Vehicle Rental</strong>
                <span>Registration</span>
            </div>
        </a>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline btn-sm">Sign In</a>
    </div>
</nav>

<!-- ================= AUTH MAIN ================= -->
<main class="auth-wrapper" style="padding: 40px 20px;">
    <div class="auth-card" style="max-width: 560px;">
        <div class="auth-header">
            <div class="logo-mark">VR</div>
            <span class="eyebrow" style="color: var(--cyan); margin-bottom: 6px;">JOIN THE FLEET</span>
            <h1>Create Account</h1>
            <p>Join Vehicle Rental to experience verified sports cars, cruisers, and electric city mobility.</p>
        </div>

        <% if ("1".equals(error)) { %>
            <div class="alert alert-error" style="margin-bottom: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                This email address is already registered. Please sign in or use a different email.
            </div>
        <% } else if ("2".equals(error)) { %>
            <div class="alert alert-error" style="margin-bottom: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                Please ensure all required fields are accurately filled.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/register" method="post" id="registerForm">
            <div class="form-grid">
                <div class="form-group form-group-full">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name"
                           placeholder="e.g. John Doe" minlength="2" maxlength="50" required autofocus>
                </div>

                <div class="form-group form-group-full">
                    <label for="email">Email Address *</label>
                    <input type="email" id="email" name="email"
                           placeholder="john@example.com" maxlength="100" autocomplete="email" required>
                    <span class="field-hint">Must be a valid and active email format.</span>
                </div>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password"
                           placeholder="At least 6 characters" minlength="6" maxlength="100" required>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           placeholder="Re-type password" minlength="6" maxlength="100" required>
                </div>

                <div class="form-group form-group-full">
                    <label for="phone">Phone Number (10 Digits) *</label>
                    <input type="tel" id="phone" name="phone"
                           placeholder="e.g. 9876543210" pattern="[0-9]{10}" maxlength="10" required>
                    <span class="field-hint">Used for reservation alerts and vehicle pickup SMS.</span>
                </div>

                <div class="form-group form-group-full">
                    <label for="address">Address *</label>
                    <textarea id="address" name="address" rows="3" minlength="5" maxlength="255"
                              placeholder="Enter your street address, city, and pincode" required></textarea>
                </div>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 24px;">
                Create Account
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </button>
        </form>

        <div class="auth-footer">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login.jsp">Sign in here</a>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Instant Account Verification • MySQL 8/9 Persistence</span>
</footer>

</body>
</html>