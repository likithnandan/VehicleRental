<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String error = request.getParameter("error");
    String registered = request.getParameter("registered");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In | Vehicle Rental</title>
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
                <span>Secure Authentication</span>
            </div>
        </a>
    </div>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
        <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline btn-sm">Create Account</a>
    </div>
</nav>

<!-- ================= AUTH MAIN ================= -->
<main class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-header">
            <div class="logo-mark">VR</div>
            <span class="eyebrow" style="color: var(--cyan); margin-bottom: 6px;">ENCRYPTED ACCESS</span>
            <h1>Welcome Back</h1>
            <p>Sign in to manage your reservations, track vehicles, and make payments.</p>
        </div>

        <% if ("1".equals(registered)) { %>
            <div class="alert alert-success" style="margin-bottom: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
                Account created successfully! Please sign in with your credentials.
            </div>
        <% } %>

        <% if ("1".equals(error)) { %>
            <div class="alert alert-error" style="margin-bottom: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>
                Invalid email address or password. Please verify your credentials.
            </div>
        <% } else if ("2".equals(error)) { %>
            <div class="alert alert-error" style="margin-bottom: 20px;">
                <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                Please provide both a valid email address and password.
            </div>
        <% } %>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="form-group" style="margin-bottom: 16px;">
                <label for="email">Email Address *</label>
                <input type="email" id="email" name="email"
                       placeholder="name@example.com" maxlength="100" autocomplete="email" required autofocus>
            </div>

            <div class="form-group" style="margin-bottom: 20px;">
                <label for="password">Password *</label>
                <input type="password" id="password" name="password"
                       placeholder="Enter your password" maxlength="100" autocomplete="current-password" required>
            </div>

            <button type="submit" class="btn btn-primary btn-block btn-lg" style="margin-top: 10px;">
                Sign In
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="5" y1="12" x2="19" y2="12"></line><polyline points="12 5 19 12 12 19"></polyline></svg>
            </button>
        </form>

        <div class="auth-footer">
            Don't have an account yet?
            <a href="${pageContext.request.contextPath}/register.jsp">Create an account</a>
        </div>
    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Safe & Reliable Journeys</p>
    <span>Audited Data • MySQL 8/9 Security Protocols</span>
</footer>

</body>
</html>