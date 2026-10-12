<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    boolean isLoggedIn = (user != null);
    String role = isLoggedIn ? user.getRole() : "";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Rental | Premium Car, Motorcycle & Scooter Fleet</title>
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
            <span>Mobility & Fleet Solutions</span>
        </div>
    </a>

    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/vehicles">Browse Fleet</a>

<% if (!isLoggedIn) { %>
        <a href="${pageContext.request.contextPath}/login.jsp">Sign In</a>
        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-primary" style="padding: 8px 18px; font-size: 0.88rem;">Create Account</a>
<% } else { %>
        <% if ("ADMIN".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/admin">Admin Portal</a>
            <a href="${pageContext.request.contextPath}/admin-vehicles">Fleet</a>
            <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
            <a href="${pageContext.request.contextPath}/reports">Reports</a>
        <% } else if ("STAFF".equals(role)) { %>
            <a href="${pageContext.request.contextPath}/staff">Staff Portal</a>
            <a href="${pageContext.request.contextPath}/maintenance">Maintenance</a>
        <% } else { %>
            <a href="${pageContext.request.contextPath}/booking-history">My Bookings</a>
            <a href="${pageContext.request.contextPath}/notifications">Notifications</a>
            <a href="${pageContext.request.contextPath}/profile.jsp">Profile</a>
        <% } %>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
<% } %>
    </div>
</nav>

<!-- ================= HERO SECTION ================= -->
<section style="padding: 70px 4% 50px; max-width: 1280px; margin: 0 auto; text-align: center;">

    <!-- EYEBROW BADGE -->
    <div style="display: inline-flex; align-items: center; gap: 8px; padding: 6px 18px; background: rgba(99, 102, 241, 0.1); border: 1px solid var(--border-accent); border-radius: var(--radius-pill); margin-bottom: 24px;">
        <span style="display: inline-block; width: 7px; height: 7px; border-radius: 50%; background: var(--cyan); box-shadow: 0 0 10px var(--cyan);"></span>
        <span style="font-size: 0.78rem; font-weight: 700; letter-spacing: 0.08em; text-transform: uppercase; color: var(--cyan-light);">
            PREMIUM MOBILITY & FLEET PLATFORM
        </span>
    </div>

    <!-- MAIN HEADLINE -->
    <h1 style="font-size: clamp(2.6rem, 5.5vw, 4.4rem); font-weight: 800; line-height: 1.12; margin-bottom: 20px; letter-spacing: -0.03em;">
        Rent Elite Vehicles.<br>
        <span style="background: linear-gradient(135deg, #fff 30%, var(--cyan) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent;">
            Engineered For The Open Road.
        </span>
    </h1>

    <p style="font-size: 1.18rem; color: var(--text-secondary); max-width: 720px; margin: 0 auto 40px; line-height: 1.65;">
        Experience seamless self-drive rentals with verified cars, performance motorcycles, and agile scooters. Instant digital approval, guaranteed availability, and zero hidden charges.
    </p>

    <!-- FLOATING SEARCH CONSOLE -->
    <div class="card" style="max-width: 1040px; margin: 0 auto 60px; padding: 26px; border-color: rgba(99, 102, 241, 0.28); background: rgba(14, 20, 34, 0.85); backdrop-filter: blur(24px); box-shadow: var(--shadow-lg);">
        <form action="${pageContext.request.contextPath}/vehicles" method="get">
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 16px; align-items: flex-end; text-align: left;">

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="vehicleType" style="font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);">Vehicle Category</label>
                    <select id="vehicleType" name="vehicleType">
                        <option value="">All Categories</option>
                        <option value="CAR">Cars (Sedan, SUV, Electric)</option>
                        <option value="BIKE">Bikes (Cruisers & Sports)</option>
                        <option value="SCOOTER">Scooters (City & EV)</option>
                    </select>
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="location" style="font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);">Pickup City / Hub</label>
                    <input type="text" id="location" name="location" placeholder="e.g. Hyderabad Hub, Terminal 1">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="pickupDate" style="font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);">Pickup Date</label>
                    <input type="date" id="pickupDate" name="pickupDate">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <label for="returnDate" style="font-size: 0.82rem; font-weight: 600; color: var(--text-secondary);">Return Date</label>
                    <input type="date" id="returnDate" name="returnDate">
                </div>

                <div class="form-group" style="margin-bottom: 0;">
                    <button type="submit" class="btn btn-primary" style="width: 100%; height: 46px; font-weight: 700; font-size: 0.95rem;">
                        <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="margin-right: 4px;"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg>
                        Search Fleet
                    </button>
                </div>

            </div>
        </form>
    </div>

</section>

<!-- ================= FLEET CATEGORIES SHOWCASE ================= -->
<main class="container" style="padding-top: 0;">

    <div style="text-align: center; margin-bottom: 40px;">
        <span class="eyebrow" style="color: var(--cyan); justify-content: center;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="3" y="3" width="7" height="7"></rect><rect x="14" y="3" width="7" height="7"></rect><rect x="14" y="14" width="7" height="7"></rect><rect x="3" y="14" width="7" height="7"></rect></svg>
            FLEET CLASSIFICATION
        </span>
        <h2 style="font-size: 2.3rem; margin-top: 6px;">Select Your Travel Class</h2>
        <p style="max-width: 580px; margin: 8px auto 0;">Every vehicle in our catalog is maintained to factory specifications and cleaned prior to departure.</p>
    </div>

    <div class="dashboard-grid" style="grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); gap: 28px; margin-bottom: 70px;">

        <!-- CARS & SUVS -->
        <article class="card" style="cursor: pointer; padding: 28px;" onclick="location.href='${pageContext.request.contextPath}/vehicles?vehicleType=CAR'">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                <div>
                    <span class="eyebrow" style="color: var(--primary-light);">FOUR-WHEELERS</span>
                    <h3 style="font-size: 1.45rem; margin-top: 4px;">Sedans & SUVs</h3>
                </div>
                <div class="logo-mark" style="background: linear-gradient(135deg, var(--primary) 0%, #4338ca 100%);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M19 17h2c.6 0 1-.4 1-1v-3c0-.9-.7-1.7-1.5-1.9C18.7 10.6 16 10 16 10s-1.3-1.4-2.2-2.3c-.5-.4-1.1-.7-1.8-.7H5c-.6 0-1.1.4-1.4.9l-1.4 2.9A3.7 3.7 0 0 0 2 12v4c0 .6.4 1 1 1h2"/><circle cx="7" cy="17" r="2"/><path d="M9 17h6"/><circle cx="17" cy="17" r="2"/></svg>
                </div>
            </div>

            <p style="margin-bottom: 24px; font-size: 0.94rem; color: var(--text-secondary); line-height: 1.6;">
                Engineered for road trips and executive city transit. Premium sedans, luxury electric vehicles, and powerful 7-seater SUVs.
            </p>

            <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-light); padding-top: 18px;">
                <div>
                    <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Rates starting at</span>
                    <strong style="color: var(--cyan); font-size: 1.15rem; font-family: 'Space Grotesk', sans-serif;">₹1,800 <small style="font-weight: normal; font-size: 0.8rem; color: var(--text-muted);">/ day</small></strong>
                </div>
                <span class="btn btn-secondary" style="font-size: 0.85rem; padding: 8px 16px;">Browse Cars →</span>
            </div>
        </article>

        <!-- MOTORCYCLES -->
        <article class="card" style="cursor: pointer; padding: 28px;" onclick="location.href='${pageContext.request.contextPath}/vehicles?vehicleType=BIKE'">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                <div>
                    <span class="eyebrow" style="color: var(--cyan);">TWO-WHEELERS</span>
                    <h3 style="font-size: 1.45rem; margin-top: 4px;">Sport & Cruisers</h3>
                </div>
                <div class="logo-mark" style="background: linear-gradient(135deg, var(--cyan) 0%, #0891b2 100%);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="18.5" cy="17.5" r="3.5"/><circle cx="5.5" cy="17.5" r="3.5"/><circle cx="15" cy="5" r="1"/><path d="M12 17.5V14l-3-3 4-3 2 3h2"/></svg>
                </div>
            </div>

            <p style="margin-bottom: 24px; font-size: 0.94rem; color: var(--text-secondary); line-height: 1.6;">
                High-performance cruisers, adventure touring bikes, and sporty streetfighters built for exhilarating weekend escapes.
            </p>

            <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-light); padding-top: 18px;">
                <div>
                    <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Rates starting at</span>
                    <strong style="color: var(--cyan); font-size: 1.15rem; font-family: 'Space Grotesk', sans-serif;">₹700 <small style="font-weight: normal; font-size: 0.8rem; color: var(--text-muted);">/ day</small></strong>
                </div>
                <span class="btn btn-secondary" style="font-size: 0.85rem; padding: 8px 16px;">Browse Bikes →</span>
            </div>
        </article>

        <!-- CITY SCOOTERS -->
        <article class="card" style="cursor: pointer; padding: 28px;" onclick="location.href='${pageContext.request.contextPath}/vehicles?vehicleType=SCOOTER'">
            <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 20px;">
                <div>
                    <span class="eyebrow" style="color: var(--warning);">URBAN COMMUTE</span>
                    <h3 style="font-size: 1.45rem; margin-top: 4px;">Scooters & EVs</h3>
                </div>
                <div class="logo-mark" style="background: linear-gradient(135deg, var(--warning) 0%, #b45309 100%);">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="6" cy="18" r="3"/><circle cx="18" cy="18" r="3"/><path d="M6 18h12M11 6h2l2 6H9l2-6z"/></svg>
                </div>
            </div>

            <p style="margin-bottom: 24px; font-size: 0.94rem; color: var(--text-secondary); line-height: 1.6;">
                Smart, fuel-efficient city scooters and zero-emission electric vehicles for rapid, traffic-free urban commuting and daily errands.
            </p>

            <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border-light); padding-top: 18px;">
                <div>
                    <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Rates starting at</span>
                    <strong style="color: var(--cyan); font-size: 1.15rem; font-family: 'Space Grotesk', sans-serif;">₹400 <small style="font-weight: normal; font-size: 0.8rem; color: var(--text-muted);">/ day</small></strong>
                </div>
                <span class="btn btn-secondary" style="font-size: 0.85rem; padding: 8px 16px;">Browse Scooters →</span>
            </div>
        </article>

    </div>

    <!-- ================= PLATFORM ADVANTAGES ================= -->
    <div style="text-align: center; margin-bottom: 40px;">
        <span class="eyebrow" style="color: var(--success); justify-content: center;">
            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"></path></svg>
            ENTERPRISE STANDARDS
        </span>
        <h2 style="font-size: 2.3rem; margin-top: 6px;">Why Travelers Choose Us</h2>
        <p style="max-width: 580px; margin: 8px auto 0;">Engineered for safety, clear pricing, and 24/7 reliability throughout your trip.</p>
    </div>

    <div class="dashboard-grid" style="grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 24px; margin-bottom: 70px;">

        <div class="card" style="padding: 26px;">
            <div class="logo-mark" style="background: rgba(99, 102, 241, 0.12); border-color: rgba(99, 102, 241, 0.3); color: var(--primary-light); margin-bottom: 18px;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>
            </div>
            <h4 style="font-size: 1.15rem; margin-bottom: 8px;">Multi-Point Inspection</h4>
            <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.55;">Every vehicle undergoes brake, tire, battery, and sanitization tests before handover.</p>
        </div>

        <div class="card" style="padding: 26px;">
            <div class="logo-mark" style="background: rgba(6, 182, 212, 0.12); border-color: rgba(6, 182, 212, 0.3); color: var(--cyan); margin-bottom: 18px;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polygon points="13 2 3 14 12 14 11 22 21 10 12 10 13 2"></polygon></svg>
            </div>
            <h4 style="font-size: 1.15rem; margin-bottom: 8px;">Instant Approval</h4>
            <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.55;">Automated date-availability checking ensures zero double-booking and immediate response.</p>
        </div>

        <div class="card" style="padding: 26px;">
            <div class="logo-mark" style="background: rgba(16, 185, 129, 0.12); border-color: rgba(16, 185, 129, 0.3); color: var(--success); margin-bottom: 18px;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="4" width="22" height="16" rx="2" ry="2"></rect><line x1="1" y1="10" x2="23" y2="10"></line></svg>
            </div>
            <h4 style="font-size: 1.15rem; margin-bottom: 8px;">Transparent Pricing</h4>
            <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.55;">No hidden insurance surcharges or surprise depot fees. What you see is what you pay.</p>
        </div>

        <div class="card" style="padding: 26px;">
            <div class="logo-mark" style="background: rgba(245, 158, 11, 0.12); border-color: rgba(245, 158, 11, 0.3); color: var(--warning); margin-bottom: 18px;">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path><circle cx="12" cy="10" r="3"></circle></svg>
            </div>
            <h4 style="font-size: 1.15rem; margin-bottom: 8px;">City-Wide Drop Points</h4>
            <p style="font-size: 0.9rem; color: var(--text-secondary); line-height: 1.55;">Collect at prime city terminals, train junctions, or opt for depot delivery directly to you.</p>
        </div>

    </div>

    <!-- ================= CTA BANNER ================= -->
    <div class="card" style="text-align: center; padding: 56px 32px; background: linear-gradient(135deg, rgba(99, 102, 241, 0.14) 0%, rgba(6, 182, 212, 0.08) 100%); border-color: rgba(99, 102, 241, 0.35); box-shadow: var(--shadow-lg);">
        <span class="eyebrow" style="color: var(--cyan); justify-content: center; margin-bottom: 10px;">READY FOR DEPARTURE?</span>
        <h2 style="font-size: 2.3rem; margin-bottom: 14px;">Your Road Journey Begins Today</h2>
        <p style="max-width: 620px; margin: 0 auto 32px; font-size: 1.05rem; color: var(--text-secondary);">
            Reserve in minutes with instant digital confirmation. Available 24/7 across all major hubs.
        </p>

        <div class="hero-buttons" style="justify-content: center; gap: 16px;">
            <a href="${pageContext.request.contextPath}/vehicles" class="btn btn-primary" style="padding: 13px 30px; font-size: 1rem; font-weight: 700;">
                Browse Available Vehicles →
            </a>
<% if (!isLoggedIn) { %>
            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-secondary" style="padding: 13px 26px; font-size: 1rem;">
                Create Free Account
            </a>
<% } %>
        </div>
    </div>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <div style="max-width: 1280px; margin: 0 auto; display: flex; flex-wrap: wrap; justify-content: space-between; align-items: center; gap: 20px;">
        <div style="display: flex; align-items: center; gap: 12px;">
            <div class="logo-mark" style="width: 36px; height: 36px; font-size: 0.95rem;">VR</div>
            <div style="text-align: left;">
                <strong style="color: var(--text);">Vehicle Rental Management System</strong>
                <span style="display: block; font-size: 0.78rem; color: var(--text-muted);">Commercial Mobility Platform</span>
            </div>
        </div>

        <div style="display: flex; gap: 24px; font-size: 0.9rem;">
            <a href="${pageContext.request.contextPath}/vehicles">Fleet Catalog</a>
            <a href="${pageContext.request.contextPath}/login.jsp">Account Login</a>
            <a href="${pageContext.request.contextPath}/register.jsp">Register</a>
        </div>
    </div>

    <div style="margin-top: 24px; font-size: 0.8rem; color: var(--text-muted); text-align: center; border-top: 1px solid var(--border-light); padding-top: 18px;">
        © 2026 Vehicle Rental Management System • Jakarta Servlets & MySQL 8/9 Architecture
    </div>
</footer>

<script>
// Auto-set today as minimum date for pickup and return
document.addEventListener('DOMContentLoaded', function() {
    const today = new Date().toISOString().split('T')[0];
    const pickup = document.getElementById('pickupDate');
    const returnD = document.getElementById('returnDate');
    if (pickup) {
        pickup.min = today;
        pickup.addEventListener('change', function() {
            if (returnD) {
                returnD.min = pickup.value;
                if (returnD.value && returnD.value <= pickup.value) {
                    returnD.value = '';
                }
            }
        });
    }
    if (returnD) returnD.min = today;
});
</script>

</body>
</html>