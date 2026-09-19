<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.publicmanagement.DBConnection" %>

<%
    // ==========================================
    // LOGIN PROTECTION
    // ==========================================
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // ==========================================
    // ADMIN PROTECTION
    // ==========================================
    String currentRole = (String) session.getAttribute("role");

    if (!"ADMIN".equals(currentRole)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    // ==========================================
    // GET COMPLAINT ID
    // ==========================================
    String complaintId = request.getParameter("id");

    if (complaintId == null || complaintId.trim().isEmpty()) {
        response.sendRedirect("admin-complaints.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint Details</title>
    <link rel="stylesheet" href="style.css">

    <style>
        .details-wrapper {
            max-width: 900px;
            margin: 40px auto;
        }

        .details-card {
            background: white;
            padding: 40px;
            border-radius: 22px;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.10);
        }

        .details-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .details-icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .details-header h1 {
            background: none;
            padding: 0;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .details-header p {
            color: #64748b;
        }

        .info-section {
            margin-bottom: 25px;
            padding: 22px;
            background: #f8fafc;
            border-radius: 14px;
        }

        .section-heading {
            font-size: 18px;
            font-weight: 700;
            color: #0f172a;
            margin-bottom: 18px;
        }

        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .info-item {
            padding: 12px;
            background: white;
            border-radius: 10px;
        }

        .info-label {
            display: block;
            font-size: 12px;
            font-weight: 700;
            color: #64748b;
            margin-bottom: 5px;
            text-transform: uppercase;
        }

        .info-value {
            color: #1e293b;
            font-weight: 600;
            word-break: break-word;
        }

        .description-box {
            background: white;
            padding: 18px;
            border-radius: 10px;
            line-height: 1.7;
            color: #334155;
            white-space: pre-wrap;
        }

        .status-box {
            text-align: center;
            padding: 20px;
            border-radius: 14px;
            margin-bottom: 25px;
        }

        .status-pending {
            background: #fef3c7;
            color: #92400e;
        }

        .status-progress {
            background: #dbeafe;
            color: #1e40af;
        }

        .status-resolved {
            background: #dcfce7;
            color: #166534;
        }

        .status-rejected {
            background: #fee2e2;
            color: #991b1b;
        }

        .status-label {
            font-size: 13px;
            font-weight: 600;
        }

        .status-value {
            font-size: 22px;
            font-weight: 800;
            margin-top: 5px;
        }

        .response-box {
            background: #eff6ff;
            border-left: 5px solid #2563eb;
            padding: 20px;
            border-radius: 10px;
            color: #1e3a8a;
            line-height: 1.6;
            white-space: pre-wrap;
        }

        .no-response {
            color: #64748b;
            font-style: italic;
        }

        .action-buttons {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        .action-button {
            flex: 1;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 12px 20px;
            border-radius: 9px;
            text-decoration: none;
            font-weight: 600;
        }

        .update-button {
            background: #2563eb;
            color: white;
        }

        .update-button:hover {
            background: #1d4ed8;
            color: white;
        }

        .back-button {
            background: #e2e8f0;
            color: #334155;
        }

        .back-button:hover {
            background: #cbd5e1;
            color: #0f172a;
        }

        @media (max-width: 650px) {
            .details-card {
                padding: 25px;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .action-buttons {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>

<nav class="navbar">
    <div class="logo">
        🏛️ Public Management System
    </div>

    <div class="nav-links">
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="admin-complaints.jsp">📋 Complaints</a>
        <a href="logout">🚪 Logout</a>
    </div>
</nav>

<div class="container">

    <div class="details-wrapper">
        <div class="details-card">

<%
    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");

        String sql =
            "SELECT c.*, " +
            "u.first_name, u.last_name, u.email, u.phone " +
            "FROM complaints c " +
            "JOIN users u ON c.user_id = u.id " +
            "WHERE c.id = ?";

        con = DBConnection.getConnection();

        ps = con.prepareStatement(sql);

        ps.setInt(1, Integer.parseInt(complaintId));

        rs = ps.executeQuery();

        if (rs.next()) {

            String status = rs.getString("status");

            String statusClass = "status-pending";
            String statusText = "🟡 PENDING";

            if ("IN_PROGRESS".equals(status)) {
                statusClass = "status-progress";
                statusText = "🔵 IN PROGRESS";
            } else if ("RESOLVED".equals(status)) {
                statusClass = "status-resolved";
                statusText = "🟢 RESOLVED";
            } else if ("REJECTED".equals(status)) {
                statusClass = "status-rejected";
                statusText = "🔴 REJECTED";
            }
%>

            <div class="details-header">
                <div class="details-icon">📋</div>

                <h1>Complaint Details</h1>

                <p>
                    Complete information about this citizen complaint.
                </p>
            </div>

            <div class="info-section">
                <div class="section-heading">
                    📝 Complaint Information
                </div>

                <div class="info-grid">

                    <div class="info-item">
                        <span class="info-label">Complaint ID</span>
                        <span class="info-value">
                            CMP-<%= rs.getInt("id") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Category</span>
                        <span class="info-value">
                            📂 <%= rs.getString("category") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Complaint Title</span>
                        <span class="info-value">
                            📝 <%= rs.getString("title") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Location</span>
                        <span class="info-value">
                            📍 <%= rs.getString("location") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Priority</span>
                        <span class="info-value">
                            ⚡ <%= rs.getString("priority") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Submitted</span>
                        <span class="info-value">
                            📅 <%= rs.getTimestamp("created_at") %>
                        </span>
                    </div>

                </div>
            </div>

            <div class="info-section">
                <div class="section-heading">
                    📄 Complaint Description
                </div>

                <div class="description-box">
                    <%= rs.getString("description") %>
                </div>
            </div>

            <div class="info-section">
                <div class="section-heading">
                    👤 Citizen Information
                </div>

                <div class="info-grid">

                    <div class="info-item">
                        <span class="info-label">Name</span>
                        <span class="info-value">
                            <%= rs.getString("first_name") %>
                            <%= rs.getString("last_name") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Email</span>
                        <span class="info-value">
                            📧 <%= rs.getString("email") %>
                        </span>
                    </div>

                    <div class="info-item">
                        <span class="info-label">Phone</span>
                        <span class="info-value">
                            📱 <%= rs.getString("phone") %>
                        </span>
                    </div>

                </div>
            </div>

            <div class="status-box <%= statusClass %>">
                <div class="status-label">
                    CURRENT STATUS
                </div>

                <div class="status-value">
                    <%= statusText %>
                </div>
            </div>

            <div class="info-section">
                <div class="section-heading">
                    📎 Complaint Evidence
                </div>

<%
            String attachmentPath = rs.getString("attachment_path");

            if (attachmentPath == null ||
                attachmentPath.trim().isEmpty()) {
%>

                <div class="response-box">
                    <span class="no-response">
                        📭 No evidence was attached to this complaint.
                    </span>
                </div>

<%
            } else {
%>

                <div style="
                    text-align:center;
                    background:white;
                    padding:20px;
                    border-radius:12px;
                ">

                    <img
                        src="<%= attachmentPath %>"
                        alt="Complaint Evidence"
                        style="
                            max-width:100%;
                            max-height:500px;
                            border-radius:12px;
                            box-shadow:0 8px 25px rgba(15,23,42,0.12);
                        "
                    >

                    <br><br>

                    <a
                        href="<%= attachmentPath %>"
                        target="_blank"
                        style="
                            display:inline-block;
                            padding:10px 18px;
                            border-radius:8px;
                            background:#2563eb;
                            color:white;
                            text-decoration:none;
                            font-weight:600;
                        "
                    >
                        🔍 Open Full Image
                    </a>

                </div>

<%
            }
%>

            </div>

            <div class="info-section">
                <div class="section-heading">
                    💬 Admin Response
                </div>

<%
            String adminResponse = rs.getString("admin_response");

            if (adminResponse == null ||
                adminResponse.trim().isEmpty()) {
%>

                <div class="response-box">
                    <span class="no-response">
                        ⏳ No response has been provided by the administrator yet.
                    </span>
                </div>

<%
            } else {
%>

                <div class="response-box">
                    💬 <%= adminResponse %>
                </div>

<%
            }
%>

            </div>

            <div class="action-buttons">

                <a
                    href="update-complaint.jsp?id=<%= rs.getInt("id") %>"
                    class="action-button update-button"
                >
                    ✏️ Update Complaint
                </a>

                <a
                    href="admin-complaints.jsp"
                    class="action-button back-button"
                >
                    ↩️ Back to Complaints
                </a>

            </div>

<%
        } else {
%>

            <div class="details-header">
                <div class="details-icon">⚠️</div>

                <h1>Complaint Not Found</h1>

                <p>
                    The requested complaint could not be found in the database.
                </p>
            </div>

            <div class="action-buttons">

                <a
                    href="admin-complaints.jsp"
                    class="action-button back-button"
                >
                    ← Back to Complaints
                </a>

            </div>

<%
        }

    } catch (Exception e) {
%>

        <div class="details-header">
            <div class="details-icon">⚠️</div>

            <h1>Database Error</h1>

            <p>
                <%= e.getMessage() %>
            </p>
        </div>

<%
    } finally {

        try {
            if (rs != null) {
                rs.close();
            }
        } catch (Exception ignored) {
        }

        try {
            if (ps != null) {
                ps.close();
            }
        } catch (Exception ignored) {
        }

        try {
            if (con != null) {
                con.close();
            }
        } catch (Exception ignored) {
        }
    }
%>

        </div>
    </div>

</div>

</body>
</html>
