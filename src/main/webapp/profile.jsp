<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) request.getAttribute("profileUser");
    if (user == null) {
        user = (User) session.getAttribute("user");
    }

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile | Vehicle Rental</title>
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
            <span>Account Center</span>
        </div>
    </div>

    <div class="nav-links">
        <% if ("ADMIN".equals(user.getRole())) { %>
            <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
            <a href="${pageContext.request.contextPath}/admin-vehicles">Vehicles</a>
            <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
            <a href="${pageContext.request.contextPath}/customer-management">Customers</a>
            <a href="${pageContext.request.contextPath}/reports">Reports</a>
            <a href="${pageContext.request.contextPath}/profile" class="active">Profile</a>
        <% } else if ("STAFF".equals(user.getRole())) { %>
            <a href="${pageContext.request.contextPath}/staff">Dashboard</a>
            <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
            <a href="${pageContext.request.contextPath}/profile" class="active">Profile</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/index.jsp">Home</a>
            <a href="${pageContext.request.contextPath}/vehicles">Vehicles</a>
            <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
            <a href="${pageContext.request.contextPath}/profile" class="active">Profile</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTENT ================= -->
<main class="container">
    <div class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--cyan);">
                <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
                SECURITY & PROFILE PREFERENCES
            </span>
            <h1>Profile & Security</h1>
            <p>Manage your account identity, contact details, residence information, and authentication credentials.</p>
        </div>
        <div class="page-actions">
            <span class="badge badge-info" style="font-size: 0.82rem; padding: 6px 14px;">
                <span class="badge-dot"></span>
                Role: <%= user.getRole() %>
            </span>
        </div>
    </div>

    <!-- NOTIFICATION BANNERS -->
    <% if ("updated".equals(success)) { %>
        <div class="alert alert-success" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Your personal profile details have been successfully updated.
        </div>
    <% } %>
    <% if ("password".equals(success)) { %>
        <div class="alert alert-success" style="margin-bottom: 24px;">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            Your security password has been changed successfully.
        </div>
    <% } %>
    <% if ("name".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Full name cannot be left blank.</div>
    <% } else if ("phone".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Contact phone number must contain exactly 10 numeric digits.</div>
    <% } else if ("address".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Residential address cannot be blank.</div>
    <% } else if ("update".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Failed to update profile. Please verify your details and try again.</div>
    <% } else if ("currentpassword".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Please enter your current account password.</div>
    <% } else if ("shortpassword".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">New password must contain at least 6 characters.</div>
    <% } else if ("passwordmatch".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">New password and confirmation password do not match.</div>
    <% } else if ("wrongpassword".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">Current password entered does not match our records.</div>
    <% } else if ("samepassword".equals(error)) { %>
        <div class="alert alert-error" style="margin-bottom: 24px;">New password must be different from your existing password.</div>
    <% } %>

    <div class="dashboard-grid" style="grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));">

        <!-- PERSONAL INFORMATION CARD -->
        <div class="card">
            <div class="card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">CONTACT INFORMATION</span>
                    <h2>Personal Profile</h2>
                </div>
                <div class="logo-mark" style="width: 44px; height: 44px; background: rgba(99, 102, 241, 0.15); border-color: rgba(99, 102, 241, 0.3);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--primary-light)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                        <circle cx="12" cy="7" r="4"></circle>
                    </svg>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/update-profile" method="post" id="profileForm">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="userId">Account ID</label>
                    <input type="text" id="userId" value="#<%= user.getUserId() %>" readonly disabled
                           style="background: rgba(255,255,255,0.02); opacity: 0.75; font-family: monospace;">
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="email">Registered Email</label>
                    <input type="email" id="email" value="<%= user.getEmail() %>" readonly disabled
                           style="background: rgba(255,255,255,0.02); opacity: 0.75;">
                    <span class="field-hint">Email address is permanently linked to your system identity.</span>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="name">Full Name *</label>
                    <input type="text" id="name" name="name"
                           value="<%= user.getName() != null ? user.getName() : "" %>" maxlength="100" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="phone">Phone Number (10 Digits) *</label>
                    <input type="tel" id="phone" name="phone"
                           value="<%= user.getPhone() != null ? user.getPhone() : "" %>"
                           pattern="[0-9]{10}" maxlength="10" placeholder="e.g. 9876543210" required>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="address">Residential Address *</label>
                    <textarea id="address" name="address" rows="3" maxlength="255" required><%= user.getAddress() != null ? user.getAddress() : "" %></textarea>
                </div>

                <div class="card-footer" style="padding-top: 18px; margin-top: 20px;">
                    <span style="font-size: 0.8rem; color: var(--text-muted);">Saved to MySQL instantly</span>
                    <button type="submit" class="btn btn-primary">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M19 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h11l5 5v11a2 2 0 0 1-2 2z"></path><polyline points="17 21 17 13 7 13 7 21"></polyline><polyline points="7 3 7 8 15 8"></polyline></svg>
                        Save Profile
                    </button>
                </div>
            </form>
        </div>

        <!-- SECURITY & PASSWORD CHANGE CARD -->
        <div class="card">
            <div class="card-header">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">CREDENTIAL PROTECTION</span>
                    <h2>Security & Password</h2>
                </div>
                <div class="logo-mark" style="width: 44px; height: 44px; background: rgba(6, 182, 212, 0.15); border-color: rgba(6, 182, 212, 0.3);">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="var(--cyan)" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                        <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                    </svg>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/change-password" method="post" id="passwordForm">
                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="currentPassword">Current Password *</label>
                    <input type="password" id="currentPassword" name="currentPassword"
                           placeholder="Enter existing password" required>
                </div>

                <div class="form-group" style="margin-bottom: 16px;">
                    <label for="newPassword">New Password *</label>
                    <input type="password" id="newPassword" name="newPassword"
                           minlength="6" maxlength="100" placeholder="Minimum 6 characters" required>
                </div>

                <div class="form-group" style="margin-bottom: 20px;">
                    <label for="confirmPassword">Confirm New Password *</label>
                    <input type="password" id="confirmPassword" name="confirmPassword"
                           minlength="6" maxlength="100" placeholder="Re-type new password" required>
                </div>

                <div class="card-footer" style="padding-top: 18px; margin-top: 48px;">
                    <span style="font-size: 0.8rem; color: var(--text-muted);">Enforced minimum 6 characters</span>
                    <button type="submit" class="btn btn-primary">
                        <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
                        Update Password
                    </button>
                </div>
            </form>
        </div>

    </div>
</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Identity & Account Security</p>
    <span>End-to-End Encryption • Audited Access Control</span>
</footer>

</body>
</html>