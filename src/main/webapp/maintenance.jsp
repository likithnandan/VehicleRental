<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Maintenance" %>
<%@ page import="model.Vehicle" %>
<%@ page import="model.User" %>

<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    boolean isAdmin = "ADMIN".equals(user.getRole());
    boolean isStaff = "STAFF".equals(user.getRole());

    if (!isAdmin && !isStaff) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    List<Maintenance> maintenanceList = (List<Maintenance>) request.getAttribute("maintenanceList");
    if (maintenanceList == null) {
        maintenanceList = new java.util.ArrayList<Maintenance>();
    }

    List<Vehicle> vehicles = (List<Vehicle>) request.getAttribute("vehicles");
    if (vehicles == null) {
        vehicles = new java.util.ArrayList<Vehicle>();
    }

    int reportedCount = 0;
    int inProgressCount = 0;
    int completedCount = 0;
    double totalCost = 0.0;

    for (Maintenance m : maintenanceList) {
        String s = m.getStatus() != null ? m.getStatus().toUpperCase() : "REPORTED";
        if ("REPORTED".equals(s)) reportedCount++;
        else if ("IN_PROGRESS".equals(s)) inProgressCount++;
        else if ("COMPLETED".equals(s)) completedCount++;
        totalCost += m.getCost();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Vehicle Maintenance Garage | Vehicle Rental</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <script src="${pageContext.request.contextPath}/js/app.js" defer></script>
</head>
<body>

<!-- ================= NAVBAR ================= -->
<nav class="navbar">
    <div class="nav-brand">
        <div class="logo-mark" style="background: <%= isAdmin ? "linear-gradient(135deg, var(--primary) 0%, #4338ca 100%)" : "linear-gradient(135deg, var(--cyan) 0%, #0e7490 100%)" %>;">VR</div>
        <div>
            <strong>Vehicle Rental</strong>
            <span><%= isAdmin ? "Admin Control Center" : "Staff Service Desk" %></span>
        </div>
    </div>

    <div class="nav-links">
<% if (isAdmin) { %>
        <a href="${pageContext.request.contextPath}/admin">Dashboard</a>
        <a href="${pageContext.request.contextPath}/admin-vehicles">Vehicles</a>
        <a href="${pageContext.request.contextPath}/admin-customers">Customers</a>
        <a href="${pageContext.request.contextPath}/admin-bookings">Bookings</a>
        <a href="${pageContext.request.contextPath}/maintenance" class="active">Maintenance</a>
        <a href="${pageContext.request.contextPath}/reports">Reports</a>
<% } else { %>
        <a href="${pageContext.request.contextPath}/staff">Active Rentals</a>
        <a href="${pageContext.request.contextPath}/maintenance" class="active">Maintenance Garage</a>
        <a href="${pageContext.request.contextPath}/index.jsp">Public Site</a>
<% } %>
        <a href="${pageContext.request.contextPath}/logout" class="nav-logout">Logout</a>
    </div>
</nav>

<!-- ================= MAIN CONTAINER ================= -->
<main class="container">

    <!-- PAGE HEADER -->
    <header class="page-header">
        <div>
            <span class="eyebrow" style="color: var(--warning);">
                <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                FLEET HEALTH & SERVICING
            </span>
            <h1>Vehicle Maintenance Center</h1>
            <p>Log mechanical issues, track garage repairs, record service expenses, and restore vehicles to available fleet status.</p>
        </div>

        <div class="hero-buttons">
<% if (isAdmin) { %>
            <a href="${pageContext.request.contextPath}/admin-vehicles" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><rect x="1" y="3" width="15" height="13"></rect><polygon points="16 8 20 8 23 11 23 16 16 16 8"></polygon><circle cx="5.5" cy="18.5" r="2.5"></circle><circle cx="18.5" cy="18.5" r="2.5"></circle></svg>
                Fleet Inventory
            </a>
<% } else { %>
            <a href="${pageContext.request.contextPath}/staff" class="btn btn-secondary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                Active Rentals
            </a>
<% } %>
            <a href="#reportFormSection" class="btn btn-primary">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="12" y1="5" x2="12" y2="19"></line><line x1="5" y1="12" x2="19" y2="12"></line></svg>
                Log New Issue
            </a>
        </div>
    </header>

    <!-- KPI STRIP -->
    <div class="stats-grid">
        <div class="stat-card">
            <span class="stat-label">Total Service Tickets</span>
            <div class="stat-value"><%= maintenanceList.size() %></div>
            <span class="stat-desc">Historical workshop records</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Pending / Reported</span>
            <div class="stat-value" style="color: var(--warning);"><%= reportedCount %></div>
            <span class="stat-desc">Awaiting repair commencement</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Active Repairs</span>
            <div class="stat-value" style="color: var(--cyan);"><%= inProgressCount %></div>
            <span class="stat-desc">Vehicles in workshop</span>
        </div>

        <div class="stat-card">
            <span class="stat-label">Total Service Expenses</span>
            <div class="stat-value" style="color: var(--text);">₹<%= String.format("%.0f", totalCost) %></div>
            <span class="stat-desc">Parts & maintenance costs</span>
        </div>
    </div>

    <!-- LOG NEW MAINTENANCE FORM -->
    <section id="reportFormSection" class="card" style="margin-bottom: 36px; border-color: rgba(245, 158, 11, 0.25);">
        <div class="card-header">
            <div>
                <span class="eyebrow" style="color: var(--warning);">WORK ORDER DISPATCH</span>
                <h2>Report Vehicle Maintenance</h2>
                <p>Register a defect, routine service, or accident repair into the garage queue.</p>
            </div>
            <div class="logo-mark" style="background: linear-gradient(135deg, var(--warning) 0%, #b45309 100%);">
                <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/maintenance" method="post" style="margin-top: 24px;">
            <div class="form-grid">

                <!-- VEHICLE DROPDOWN SELECTION -->
                <div class="form-group">
                    <label for="vehicleId">Target Fleet Vehicle <span style="color: var(--danger);">*</span></label>
                    <select id="vehicleId" name="vehicleId" required>
                        <option value="">-- Choose a Vehicle --</option>
<% for (Vehicle v : vehicles) { %>
                        <option value="<%= v.getVehicleId() %>">
                            #<%= v.getVehicleId() %> • <%= v.getBrand() %> <%= v.getModel() %> (<%= v.getVehicleNumber() %>) - [<%= v.getStatus() %>]
                        </option>
<% } %>
                    </select>
                </div>

                <!-- MAINTENANCE DATE -->
                <div class="form-group">
                    <label for="maintenanceDate">Service Date <span style="color: var(--danger);">*</span></label>
                    <input type="date" id="maintenanceDate" name="maintenanceDate" required>
                </div>

                <!-- ESTIMATED COST -->
                <div class="form-group">
                    <label for="cost">Estimated Repair Cost (₹) <span style="color: var(--danger);">*</span></label>
                    <input type="number" id="cost" name="cost" step="0.01" min="0" value="0.00" required placeholder="0.00">
                </div>

                <!-- PROBLEM DESCRIPTION -->
                <div class="form-group form-group-full">
                    <label for="problemDescription">Problem Description & Symptoms <span style="color: var(--danger);">*</span></label>
                    <textarea id="problemDescription" name="problemDescription" rows="4" required maxlength="500" placeholder="Detail the technical fault, brake wear, engine issue, or routine service requirement..."></textarea>
                </div>

                <!-- REMARKS / NOTES -->
                <div class="form-group form-group-full">
                    <label for="remarks">Technician Remarks & Workshop Notes</label>
                    <textarea id="remarks" name="remarks" rows="2" maxlength="500" placeholder="Optional notes: spare parts ordered, expected delivery time, mechanic assigned..."></textarea>
                </div>
            </div>

            <div class="form-actions" style="margin-top: 24px;">
                <button type="submit" class="btn btn-primary" style="background: linear-gradient(135deg, var(--warning) 0%, #d97706 100%); border-color: var(--warning); color: #07090e; font-weight: 700;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#07090e" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
                    Create Service Ticket
                </button>
            </div>
        </form>
    </section>

    <!-- FILTER & SEARCH BAR -->
    <div class="filter-bar">
        <div class="filter-group">
            <button type="button" class="filter-btn active" onclick="filterMaintenance('ALL', this)">All Tickets (<%= maintenanceList.size() %>)</button>
            <button type="button" class="filter-btn" onclick="filterMaintenance('REPORTED', this)">Reported (<%= reportedCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterMaintenance('IN_PROGRESS', this)">In Progress (<%= inProgressCount %>)</button>
            <button type="button" class="filter-btn" onclick="filterMaintenance('COMPLETED', this)">Completed (<%= completedCount %>)</button>
        </div>

        <div class="search-input-wrapper">
            <input type="text" id="maintenanceSearchInput" placeholder="Search by ticket #, vehicle, plate, or fault..." onkeyup="searchMaintenance()">
        </div>
    </div>

    <!-- MAINTENANCE RECORDS CONTAINER -->
    <section id="maintenanceContainer" class="dashboard-grid">

<%
    if (maintenanceList.isEmpty()) {
%>
        <div class="card empty-state" style="grid-column: 1 / -1;">
            <div class="empty-icon">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round"><path d="M14.7 6.3a1 1 0 0 0 0 1.4l1.6 1.6a1 1 0 0 0 1.4 0l3.77-3.77a6 6 0 0 1-7.94 7.94l-6.91 6.91a2.12 2.12 0 0 1-3-3l6.91-6.91a6 6 0 0 1 7.94-7.94l-3.76 3.76z"></path></svg>
            </div>
            <h3>Zero Active Service Tickets</h3>
            <p>All fleet vehicles are operating smoothly with zero recorded mechanical faults.</p>
        </div>
<%
    } else {
        for (Maintenance m : maintenanceList) {
            String status = m.getStatus() != null ? m.getStatus().toUpperCase() : "REPORTED";
            String statusClass = "status-" + status.toLowerCase();

            String vTitle = m.getVehicleTitle();
            if (vTitle == null || vTitle.trim().isEmpty()) {
                vTitle = (m.getVehicleBrand() != null ? m.getVehicleBrand() + " " : "") +
                         (m.getVehicleModel() != null ? m.getVehicleModel() : "Vehicle #" + m.getVehicleId());
            }

            String vPlate = m.getVehicleNumber() != null ? m.getVehicleNumber() : "ID #" + m.getVehicleId();
            String reporter = m.getReportedByName() != null ? m.getReportedByName() : "Staff #" + m.getReportedBy();
            String remarks = m.getRemarks() != null && !m.getRemarks().trim().isEmpty() ? m.getRemarks() : "No extra notes logged";

            String searchContent = ("#" + m.getMaintenanceId() + " " + vTitle + " " + vPlate + " " + reporter + " " + m.getProblemDescription() + " " + remarks).toLowerCase();
%>

        <article class="card booking-card maintenance-card"
                 data-status="<%= status %>"
                 data-search="<%= searchContent %>">

            <!-- HEADER -->
            <div class="booking-card-header">
                <div>
                    <span class="eyebrow" style="color: var(--warning);">SERVICE TICKET</span>
                    <h2>Ticket #<%= m.getMaintenanceId() %></h2>
                </div>

                <span class="status-badge <%= statusClass %>"><%= status.replace("_", " ") %></span>
            </div>

            <!-- VEHICLE SUMMARY -->
            <div style="padding: 12px 16px; background: rgba(255,255,255,0.02); border-radius: var(--radius-sm); border: 1px solid var(--border-light);">
                <div style="display: flex; justify-content: space-between; align-items: center;">
                    <div>
                        <div style="font-weight: 700; font-size: 1.05rem; color: #fff;"><%= vTitle %></div>
                        <div style="font-size: 0.85rem; color: var(--text-muted); margin-top: 3px;">
                            License Plate: <strong style="color: var(--cyan);"><%= vPlate %></strong>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <span style="font-size: 0.72rem; text-transform: uppercase; color: var(--text-muted); display: block;">Vehicle ID</span>
                        <strong style="color: var(--text-secondary);">#<%= m.getVehicleId() %></strong>
                    </div>
                </div>
            </div>

            <!-- TICKET DETAILS -->
            <div class="booking-details-grid">
                <div class="info-item">
                    <span class="info-label">Service Date</span>
                    <strong><%= m.getMaintenanceDate() %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Reported By</span>
                    <strong><%= reporter %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Repair Cost</span>
                    <strong style="color: var(--warning);">₹<%= String.format("%.2f", m.getCost()) %></strong>
                </div>

                <div class="info-item">
                    <span class="info-label">Current Phase</span>
                    <strong><%= status.replace("_", " ") %></strong>
                </div>
            </div>

            <!-- PROBLEM DESCRIPTION -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="8" x2="12" y2="12"></line><line x1="12" y1="16" x2="12.01" y2="16"></line></svg>
                    Defect Description
                </div>
                <p style="font-size: 0.92rem; color: var(--text); line-height: 1.5; margin-top: 4px;">
                    <%= m.getProblemDescription() %>
                </p>
            </div>

            <!-- REMARKS -->
            <div class="booking-section">
                <div class="section-title">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><polyline points="14 2 14 8 20 8"></polyline><line x1="16" y1="13" x2="8" y2="13"></line><line x1="16" y1="17" x2="8" y2="17"></line></svg>
                    Garage Remarks
                </div>
                <p style="font-size: 0.88rem; color: var(--text-secondary); line-height: 1.5; margin-top: 4px;">
                    <%= remarks %>
                </p>
            </div>

            <!-- INLINE STATUS UPDATE FORM (IF NOT COMPLETED) -->
<% if (!"COMPLETED".equals(status)) { %>
            <div style="margin-top: 20px; padding-top: 16px; border-top: 1px solid var(--border-light);">
                <div style="font-size: 0.78rem; font-weight: 700; text-transform: uppercase; color: var(--cyan); letter-spacing: 0.05em; margin-bottom: 12px;">
                    Update Repair Status & Expenses
                </div>

                <form action="${pageContext.request.contextPath}/update-maintenance" method="post">
                    <input type="hidden" name="maintenanceId" value="<%= m.getMaintenanceId() %>">

                    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 12px;">
                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.78rem;">New Phase</label>
                            <select name="status" required style="padding: 8px 12px; font-size: 0.85rem;">
                                <option value="REPORTED" <%= "REPORTED".equals(status) ? "selected" : "" %>>REPORTED</option>
                                <option value="IN_PROGRESS" <%= "IN_PROGRESS".equals(status) ? "selected" : "" %>>IN PROGRESS</option>
                                <option value="COMPLETED">COMPLETED (Return to Fleet)</option>
                            </select>
                        </div>

                        <div class="form-group" style="margin-bottom: 0;">
                            <label style="font-size: 0.78rem;">Final / Updated Cost (₹)</label>
                            <input type="number" name="cost" step="0.01" min="0" value="<%= String.format(java.util.Locale.US, "%.2f", m.getCost()) %>" required style="padding: 8px 12px; font-size: 0.85rem;">
                        </div>
                    </div>

                    <div class="form-group" style="margin-bottom: 12px;">
                        <label style="font-size: 0.78rem;">Updated Workshop Notes</label>
                        <input type="text" name="remarks" value="<%= m.getRemarks() != null ? m.getRemarks() : "" %>" placeholder="Work done, replacement parts, tester comments..." style="padding: 8px 12px; font-size: 0.85rem;">
                    </div>

                    <button type="submit" class="btn btn-secondary" style="width: 100%; border-color: var(--cyan); color: var(--cyan); font-size: 0.85rem; padding: 8px 16px;">
                        Update Service Record
                    </button>
                </form>
            </div>
<% } else { %>
            <div style="margin-top: 18px; padding: 10px 14px; background: rgba(16, 185, 129, 0.08); border: 1px solid var(--success-border); border-radius: var(--radius-sm); color: var(--success); font-size: 0.85rem; display: flex; align-items: center; gap: 8px;">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>
                <span>Maintenance completed. Vehicle automatically restored to available fleet.</span>
            </div>
<% } %>

        </article>

<%
        }
    }
%>

    </section>

</main>

<!-- ================= FOOTER ================= -->
<footer class="site-footer">
    <p><strong>Vehicle Rental Management System</strong> • Fleet Maintenance Division</p>
    <span>Safety Standards • Scheduled Servicing • Incident Reports</span>
</footer>

<!-- SCRIPTS FOR FILTER & SEARCH -->
<script>
document.addEventListener('DOMContentLoaded', function() {
    const dateInput = document.getElementById('maintenanceDate');
    if (dateInput && !dateInput.value) {
        dateInput.value = new Date().toISOString().split('T')[0];
    }
});

function filterMaintenance(status, btn) {
    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');

    const cards = document.querySelectorAll('.maintenance-card');
    cards.forEach(card => {
        const cardStatus = card.getAttribute('data-status');
        if (status === 'ALL' || cardStatus === status) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}

function searchMaintenance() {
    const q = document.getElementById('maintenanceSearchInput').value.trim().toLowerCase();
    const cards = document.querySelectorAll('.maintenance-card');
    cards.forEach(card => {
        const searchData = card.getAttribute('data-search') || '';
        if (!q || searchData.includes(q)) {
            card.style.display = '';
        } else {
            card.style.display = 'none';
        }
    });
}
</script>

</body>
</html>