<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // =========================================
    // LOGIN PROTECTION
    // =========================================

    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get logged-in user's ID safely
    String userIdString =
            String.valueOf(session.getAttribute("userId"));

    int userId =
            Integer.parseInt(userIdString);
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Complaints</title>

    <link rel="stylesheet" href="style.css">

</head>

<body>

<!-- =========================================
     NAVIGATION
     ========================================= -->

<nav class="navbar">

    <div class="logo">
        🏛️ Public Management System
    </div>

    <div class="nav-links">

        <a href="dashboard.jsp">
            🏠 Dashboard
        </a>

        <a href="users.jsp">
            👥 Users
        </a>

        <a href="logout">
            🚪 Logout
        </a>

    </div>

</nav>


<!-- =========================================
     MAIN CONTENT
     ========================================= -->

<div class="container">
<%
    /*
     * ==========================================
     * COMPLAINT STATISTICS
     * ==========================================
     */

    int totalComplaints = 0;
    int pendingComplaints = 0;
    int inProgressComplaints = 0;
    int resolvedComplaints = 0;
    int rejectedComplaints = 0;

    String dbUrl =
        "jdbc:mysql://localhost:3306/public_management_system";

    String dbUsername = "root";
    String dbPassword = "deepika@1234";


    try {

        Class.forName(
            "com.mysql.cj.jdbc.Driver"
        );

        Connection statsCon =
            DriverManager.getConnection(
                dbUrl,
                dbUsername,
                dbPassword
            );


        /*
         * Get total complaints
         */

        PreparedStatement totalPs =
            statsCon.prepareStatement(
                "SELECT COUNT(*) FROM complaints"
            );

        ResultSet totalRs =
            totalPs.executeQuery();

        if (totalRs.next()) {
            totalComplaints =
                totalRs.getInt(1);
        }


        /*
         * Get Pending complaints
         */

        PreparedStatement pendingPs =
            statsCon.prepareStatement(
                "SELECT COUNT(*) FROM complaints " +
                "WHERE status = 'PENDING'"
            );

        ResultSet pendingRs =
            pendingPs.executeQuery();

        if (pendingRs.next()) {
            pendingComplaints =
                pendingRs.getInt(1);
        }


        /*
         * Get In Progress complaints
         */

        PreparedStatement progressPs =
            statsCon.prepareStatement(
                "SELECT COUNT(*) FROM complaints " +
                "WHERE status = 'IN_PROGRESS'"
            );

        ResultSet progressRs =
            progressPs.executeQuery();

        if (progressRs.next()) {
            inProgressComplaints =
                progressRs.getInt(1);
        }


        /*
         * Get Resolved complaints
         */

        PreparedStatement resolvedPs =
            statsCon.prepareStatement(
                "SELECT COUNT(*) FROM complaints " +
                "WHERE status = 'RESOLVED'"
            );

        ResultSet resolvedRs =
            resolvedPs.executeQuery();

        if (resolvedRs.next()) {
            resolvedComplaints =
                resolvedRs.getInt(1);
        }


        /*
         * Get Rejected complaints
         */

        PreparedStatement rejectedPs =
            statsCon.prepareStatement(
                "SELECT COUNT(*) FROM complaints " +
                "WHERE status = 'REJECTED'"
            );

        ResultSet rejectedRs =
            rejectedPs.executeQuery();

        if (rejectedRs.next()) {
            rejectedComplaints =
                rejectedRs.getInt(1);
        }


        /*
         * Close everything
         */

        totalRs.close();
        totalPs.close();

        pendingRs.close();
        pendingPs.close();

        progressRs.close();
        progressPs.close();

        resolvedRs.close();
        resolvedPs.close();

        rejectedRs.close();
        rejectedPs.close();

        statsCon.close();


    } catch (Exception e) {

        out.println(
            "<p style='color:red;'>"
            + "Statistics Error: "
            + e.getMessage()
            + "</p>"
        );
    }
%>


<!-- ==========================================
     COMPLAINT STATISTICS
     ========================================== -->

<%
if ("ADMIN".equals(session.getAttribute("role"))) {
%>

<div class="stats-section">

    <div class="stats-title">

        <h2>
            📊 Complaint Overview
        </h2>

        <p>
            Monitor the current status of citizen complaints.
        </p>

    </div>


    <div class="stats-grid">


        <!-- TOTAL -->

        <div class="stat-card total-card">

            <div class="stat-icon">
                📋
            </div>

            <div class="stat-content">

                <span>
                    Total Complaints
                </span>

                <strong>
                    <%= totalComplaints %>
                </strong>

            </div>

        </div>


        <!-- PENDING -->

        <div class="stat-card pending-card">

            <div class="stat-icon">
                🟡
            </div>

            <div class="stat-content">

                <span>
                    Pending
                </span>

                <strong>
                    <%= pendingComplaints %>
                </strong>

            </div>

        </div>


        <!-- IN PROGRESS -->

        <div class="stat-card progress-card">

            <div class="stat-icon">
                🔵
            </div>

            <div class="stat-content">

                <span>
                    In Progress
                </span>

                <strong>
                    <%= inProgressComplaints %>
                </strong>

            </div>

        </div>


        <!-- RESOLVED -->

        <div class="stat-card resolved-card">

            <div class="stat-icon">
                🟢
            </div>

            <div class="stat-content">

                <span>
                    Resolved
                </span>

                <strong>
                    <%= resolvedComplaints %>
                </strong>

            </div>

        </div>


        <!-- REJECTED -->

        <div class="stat-card rejected-card">

            <div class="stat-icon">
                🔴
            </div>

            <div class="stat-content">

                <span>
                    Rejected
                </span>

                <strong>
                    <%= rejectedComplaints %>
                </strong>

            </div>

        </div>


    </div>

</div>

<%
}
%>

    <h1 class="page-title">
        📋 My Complaints
    </h1>

    <p>
        View and track the complaints you have submitted.
    </p>

    <br>

    <a class="back-link" href="dashboard.jsp">
        ← Back to Dashboard
    </a>


    <div class="table-container">

        <table>

            <thead>

                <tr>

                    <th>No.</th>

                    <th>Complaint</th>

                    <th>Category</th>

                    <th>Location</th>

                    <th>Priority</th>

                    <th>Status</th>
                    
                    <th>Admin Response</th>

                    <th>Date</th>
                    
                    <th>Action</th>

                </tr>

            </thead>

            <tbody>

<%

    String url =
        "jdbc:mysql://localhost:3306/public_management_system";

    String username = "root";

    String password = "deepika@1234";


    try {

        Class.forName(
            "com.mysql.cj.jdbc.Driver"
        );


        Connection con =
            DriverManager.getConnection(
                url,
                username,
                password
            );


        /*
         * IMPORTANT:
         *
         * We search using the logged-in
         * user's ID.
         */

        String sql =
        		
        	    "SELECT id, title, category, location, " +
        	    "priority, status, admin_response, created_at " +
        	    "FROM complaints " +
        	    "WHERE user_id = ? " +
        	    "ORDER BY id ASC";

        PreparedStatement ps =
            con.prepareStatement(sql);


        ps.setInt(1, userId);


        ResultSet rs =
            ps.executeQuery();


        // This is ONLY for displaying
        // 1, 2, 3, 4...
        int displayNumber = 1;


        boolean found = false;


        while (rs.next()) {

            found = true;

            String status =
                rs.getString("status");

            String priority =
                rs.getString("priority");

%>

                <tr>

                    <!-- DISPLAY NUMBER -->

                    <td>
                        <strong>
                            <%= displayNumber %>
                        </strong>
                    </td>
                    


                    <!-- COMPLAINT -->

                    <td>
                        📝
                        <%= rs.getString("title") %>
                    </td>


                    <!-- CATEGORY -->

                    <td>
                        📂
                        <%= rs.getString("category") %>
                    </td>


                    <!-- LOCATION -->

                    <td>
                        📍
                        <%= rs.getString("location") %>
                    </td>


                    <!-- PRIORITY -->

                    <td>

<%
                    if ("HIGH".equals(priority)) {
%>

                        🔴 HIGH

<%
                    } else if ("MEDIUM".equals(priority)) {
%>

                        🟡 MEDIUM

<%
                    } else {
%>

                        🟢 LOW

<%
                    }
%>

                    </td>


                    <!-- STATUS -->

                    <td>

<%
                    if ("PENDING".equals(status)) {
%>

                        🟡 PENDING

<%
                    } else if ("IN_PROGRESS".equals(status)) {
%>

                        🔵 IN PROGRESS

<%
                    } else if ("RESOLVED".equals(status)) {
%>

                        🟢 RESOLVED

<%
                    } else if ("REJECTED".equals(status)) {
%>

                        🔴 REJECTED

<%
                    } else {
%>

                        <%= status %>

<%
                    }
%>

                    </td>
<td>

    <%
    String adminResponse =
        rs.getString("admin_response");

    if (adminResponse == null ||
        adminResponse.trim().isEmpty()) {
    %>

        <span style="color:#94a3b8;">
            ⏳ Awaiting admin response
        </span>

    <%
    } else {
    %>

        💬 <%= adminResponse %>

    <%
    }
    %>

</td>

                

                    <!-- DATE -->

                    <td>
                    
<td>

<a
    href="my-complaint-details.jsp?id=<%= rs.getInt("id") %>"
    class="action-edit">

    👀 View

</a>

</td>
                    
                        <%= rs.getTimestamp("created_at") %>
                    </td>

                </tr>

<%

            // Increase display number
            displayNumber++;

        }


        // =====================================
        // NO COMPLAINTS
        // =====================================

        if (!found) {

%>

                <tr>

                    <td colspan="9"
                        style="text-align:center;
                               padding:50px;">

                        <div style="font-size:50px;">
                            📭
                        </div>

                        <br>

                        <strong>
                            You have not submitted
                            any complaints yet.
                        </strong>

                        <br><br>

                        <a href="raise-complaint.jsp">

                            📝 Raise a Complaint

                        </a>

                    </td>

                </tr>

<%

        }


        rs.close();

        ps.close();

        con.close();


    } catch (Exception e) {

%>

                <tr>

                    <td colspan="9"
                        style="color:red;
                               padding:20px;">

                        ⚠️ Database Error:

                        <%= e.getMessage() %>

                    </td>

                </tr>

<%

    }

%>

            </tbody>

        </table>

    </div>

</div>


</body>

</html>