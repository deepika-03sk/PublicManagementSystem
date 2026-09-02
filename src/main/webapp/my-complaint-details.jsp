<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

<%
    // ==========================================
    // LOGIN PROTECTION
    // ==========================================

    if (session.getAttribute("userId") == null) {

        response.sendRedirect("index.jsp");
        return;
    }


    // ==========================================
    // GET LOGGED-IN USER ID
    // ==========================================

    String userIdString =
            String.valueOf(session.getAttribute("userId"));

    int userId =
            Integer.parseInt(userIdString);


    // ==========================================
    // GET COMPLAINT ID
    // ==========================================

    String complaintId =
            request.getParameter("id");


    if (complaintId == null ||
        complaintId.trim().isEmpty()) {

        response.sendRedirect("my-complaints.jsp");
        return;
    }

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>My Complaint Details</title>

    <link rel="stylesheet" href="style.css">


    <style>

        /* ==========================================
           MAIN DETAILS PAGE
           ========================================== */

        .details-wrapper {

            max-width: 850px;

            margin: 40px auto;

        }


        .details-card {

            background: white;

            padding: 40px;

            border-radius: 22px;

            box-shadow:
                0 12px 35px
                rgba(15, 23, 42, 0.10);

        }


        /* ==========================================
           HEADER
           ========================================== */

        .details-header {

            text-align: center;

            margin-bottom: 30px;

        }


        .details-icon {

            font-size: 55px;

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


        /* ==========================================
           INFORMATION SECTIONS
           ========================================== */

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


        /* ==========================================
           DESCRIPTION
           ========================================== */

        .description-box {

            background: white;

            padding: 18px;

            border-radius: 10px;

            line-height: 1.7;

            color: #334155;

            white-space: pre-wrap;

        }


        /* ==========================================
           CURRENT STATUS
           ========================================== */

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


        /* ==========================================
           RESPONSE BOX
           ========================================== */

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


        /* ==========================================
           EVIDENCE
           ========================================== */

        .evidence-container {

            text-align: center;

            background: white;

            padding: 20px;

            border-radius: 12px;

        }


        .evidence-image {

            max-width: 100%;

            max-height: 500px;

            border-radius: 12px;

            box-shadow:
                0 8px 25px
                rgba(15, 23, 42, 0.12);

        }


        .full-image-button {

            display: inline-block;

            padding: 10px 18px;

            border-radius: 8px;

            background: #2563eb;

            color: white;

            text-decoration: none;

            font-weight: 600;

            margin-top: 15px;

        }


        .full-image-button:hover {

            background: #1d4ed8;

        }


        /* ==========================================
           STATUS TIMELINE
           ========================================== */

        .timeline {

            position: relative;

            margin-top: 20px;

            padding-left: 10px;

        }


        .timeline-item {

            position: relative;

            display: flex;

            gap: 18px;

            padding-bottom: 25px;

        }


        .timeline-item:not(:last-child)::before {

            content: "";

            position: absolute;

            left: 19px;

            top: 42px;

            width: 3px;

            height: calc(100% - 20px);

            background: #e2e8f0;

            border-radius: 5px;

        }


        .timeline-marker {

            width: 42px;

            height: 42px;

            min-width: 42px;

            display: flex;

            align-items: center;

            justify-content: center;

            border-radius: 50%;

            font-size: 20px;

            position: relative;

            z-index: 2;

        }


        .timeline-pending {

            background: #fef3c7;

        }


        .timeline-progress {

            background: #dbeafe;

        }


        .timeline-resolved {

            background: #dcfce7;

        }


        .timeline-rejected {

            background: #fee2e2;

        }


        .timeline-content {

            flex: 1;

            background: white;

            padding: 15px 18px;

            border-radius: 12px;

            box-shadow:
                0 4px 12px
                rgba(15, 23, 42, 0.06);

        }


        .timeline-status {

            font-weight: 800;

            color: #0f172a;

            font-size: 15px;

            margin-bottom: 5px;

        }


        .timeline-date {

            color: #64748b;

            font-size: 12px;

            margin-bottom: 10px;

        }


        .timeline-comment {

            color: #334155;

            line-height: 1.6;

            white-space: pre-wrap;

        }


        /* ==========================================
           BACK BUTTON
           ========================================== */

        .back-button {

            display: inline-flex;

            align-items: center;

            justify-content: center;

            padding: 12px 22px;

            border-radius: 9px;

            background: #e2e8f0;

            color: #334155;

            text-decoration: none;

            font-weight: 600;

            margin-top: 5px;

        }


        .back-button:hover {

            background: #cbd5e1;

            color: #0f172a;

        }


        /* ==========================================
           MOBILE
           ========================================== */

        @media (max-width: 650px) {

            .details-card {

                padding: 25px;

            }


            .info-grid {

                grid-template-columns: 1fr;

            }


            .timeline-content {

                padding: 13px;

            }

        }

    </style>

</head>


<body>


<!-- ==========================================
     NAVIGATION
     ========================================== -->

<nav class="navbar">

    <div class="logo">

        🏛️ Public Management System

    </div>


    <div class="nav-links">

        <a href="dashboard.jsp">

            🏠 Dashboard

        </a>


        <a href="my-complaints.jsp">

            📋 My Complaints

        </a>


        <a href="logout">

            🚪 Logout

        </a>

    </div>

</nav>


<!-- ==========================================
     MAIN CONTENT
     ========================================== -->

<div class="container">

    <div class="details-wrapper">

        <div class="details-card">


<%

    // ==========================================
    // DATABASE CONNECTION
    // ==========================================

    Connection con = DriverManager.getConnection(
    System.getenv("MYSQL_URL").replaceFirst("^mysql://", "jdbc:mysql://"),
    System.getenv("MYSQLUSER"),
    System.getenv("MYSQLPASSWORD")
);
    Connection con = null;

    PreparedStatement ps = null;

    ResultSet rs = null;


    try {

        Class.forName(
                "com.mysql.cj.jdbc.Driver");


        
        Connection con = DBConnection.getConnection();
        // ======================================
        // SECURITY:
        // ONLY THIS USER'S COMPLAINT
        // ======================================

        String sql =
            "SELECT * FROM complaints " +
            "WHERE id = ? AND user_id = ?";


        ps =
            con.prepareStatement(sql);


        ps.setInt(
            1,
            Integer.parseInt(complaintId)
        );


        ps.setInt(
            2,
            userId
        );


        rs =
            ps.executeQuery();


        if (rs.next()) {


            // =================================
            // CURRENT STATUS
            // =================================

            String currentStatus =
                rs.getString("status");


            String currentStatusClass =
                "status-pending";


            String currentStatusText =
                "🟡 PENDING";


            if ("IN_PROGRESS".equals(currentStatus)) {

                currentStatusClass =
                    "status-progress";

                currentStatusText =
                    "🔵 IN PROGRESS";

            }

            else if ("RESOLVED".equals(currentStatus)) {

                currentStatusClass =
                    "status-resolved";

                currentStatusText =
                    "🟢 RESOLVED";

            }

            else if ("REJECTED".equals(currentStatus)) {

                currentStatusClass =
                    "status-rejected";

                currentStatusText =
                    "🔴 REJECTED";

            }

%>


<!-- ==========================================
     HEADER
     ========================================== -->

<div class="details-header">

    <div class="details-icon">

        📋

    </div>


    <h1>

        My Complaint Details

    </h1>


    <p>

        View the complete details and
        current status of your complaint.

    </p>

</div>


<!-- ==========================================
     COMPLAINT INFORMATION
     ========================================== -->

<div class="info-section">

    <div class="section-heading">

        📝 Complaint Information

    </div>


    <div class="info-grid">


        <div class="info-item">

            <span class="info-label">

                Complaint ID

            </span>


            <span class="info-value">

                CMP-<%= rs.getInt("id") %>

            </span>

        </div>


        <div class="info-item">

            <span class="info-label">

                Category

            </span>


            <span class="info-value">

                📂
                <%= rs.getString("category") %>

            </span>

        </div>


        <div class="info-item">

            <span class="info-label">

                Complaint Title

            </span>


            <span class="info-value">

                📝
                <%= rs.getString("title") %>

            </span>

        </div>


        <div class="info-item">

            <span class="info-label">

                Location

            </span>


            <span class="info-value">

                📍
                <%= rs.getString("location") %>

            </span>

        </div>


        <div class="info-item">

            <span class="info-label">

                Priority

            </span>


            <span class="info-value">

                ⚡
                <%= rs.getString("priority") %>

            </span>

        </div>


        <div class="info-item">

            <span class="info-label">

                Submitted

            </span>


            <span class="info-value">

                📅
                <%= rs.getTimestamp("created_at") %>

            </span>

        </div>


    </div>

</div>


<!-- ==========================================
     DESCRIPTION
     ========================================== -->

<div class="info-section">

    <div class="section-heading">

        📄 My Complaint

    </div>


    <div class="description-box">

        <%= rs.getString("description") %>

    </div>

</div>


<!-- ==========================================
     CURRENT STATUS
     ========================================== -->

<div class="status-box <%= currentStatusClass %>">

    <div class="status-label">

        CURRENT STATUS

    </div>


    <div class="status-value">

        <%= currentStatusText %>

    </div>

</div>


<!-- ==========================================
     COMPLAINT EVIDENCE
     ========================================== -->

<div class="info-section">

    <div class="section-heading">

        📎 Complaint Evidence

    </div>


<%

    String attachmentPath =
        rs.getString("attachment_path");


    if (attachmentPath == null ||
        attachmentPath.trim().isEmpty()) {

%>

    <div class="response-box">

        <span class="no-response">

            📭 No evidence was attached
            to this complaint.

        </span>

    </div>

<%

    }

    else {

%>

    <div class="evidence-container">

        <img

            src="<%= attachmentPath %>"

            alt="Complaint Evidence"

            class="evidence-image">


        <br>


        <a

            href="<%= attachmentPath %>"

            target="_blank"

            class="full-image-button">

            🔍 Open Full Image

        </a>

    </div>

<%

    }

%>

</div>


<!-- ==========================================
     STATUS TIMELINE
     ========================================== -->

<div class="info-section">

    <div class="section-heading">

        📋 Complaint Status Timeline

    </div>


    <div class="timeline">

<%

    // ==========================================
    // GET COMPLAINT HISTORY
    // ==========================================

    String historySql =
        "SELECT status, comment, changed_at " +
        "FROM complaint_history " +
        "WHERE complaint_id = ? " +
        "ORDER BY changed_at ASC, id ASC";


    PreparedStatement historyPs =
        null;


    ResultSet historyRs =
        null;


    boolean historyFound =
        false;


    try {

        historyPs =
            con.prepareStatement(
                historySql
            );


        historyPs.setInt(
            1,
            Integer.parseInt(complaintId)
        );


        historyRs =
            historyPs.executeQuery();


        while (historyRs.next()) {

            historyFound = true;


            String historyStatus =
                historyRs.getString("status");


            String historyComment =
                historyRs.getString("comment");


            // =================================
            // TIMELINE-SPECIFIC VARIABLES
            // =================================

            String timelineIcon =
                "🟡";


            String timelineClass =
                "timeline-pending";


            String timelineText =
                "PENDING";


            if ("IN_PROGRESS".equals(historyStatus)) {

                timelineIcon =
                    "🔵";

                timelineClass =
                    "timeline-progress";

                timelineText =
                    "IN PROGRESS";

            }

            else if ("RESOLVED".equals(historyStatus)) {

                timelineIcon =
                    "🟢";

                timelineClass =
                    "timeline-resolved";

                timelineText =
                    "RESOLVED";

            }

            else if ("REJECTED".equals(historyStatus)) {

                timelineIcon =
                    "🔴";

                timelineClass =
                    "timeline-rejected";

                timelineText =
                    "REJECTED";

            }

%>


        <div class="timeline-item">


            <div class="timeline-marker <%= timelineClass %>">

                <%= timelineIcon %>

            </div>


            <div class="timeline-content">


                <div class="timeline-status">

                    <%= timelineText %>

                </div>


                <div class="timeline-date">

                    📅
                    <%= historyRs.getTimestamp("changed_at") %>

                </div>


                <div class="timeline-comment">

<%

                if (historyComment != null &&
                    !historyComment.trim().isEmpty()) {

%>

                    <%= historyComment %>

<%

                }

                else {

%>

                    Status updated by administrator.

<%

                }

%>

                </div>


            </div>


        </div>


<%

        }


    }

    finally {

        if (historyRs != null) {

            historyRs.close();

        }


        if (historyPs != null) {

            historyPs.close();

        }

    }


    if (!historyFound) {

%>


        <div class="response-box">

            <span class="no-response">

                📭 No status history is available yet.

            </span>

        </div>


<%

    }

%>

    </div>

</div>


<!-- ==========================================
     ADMIN RESPONSE
     ========================================== -->

<div class="info-section">

    <div class="section-heading">

        💬 Response from Administration

    </div>


<%

    String adminResponse =
        rs.getString("admin_response");


    if (adminResponse == null ||
        adminResponse.trim().isEmpty()) {

%>

    <div class="response-box">

        <span class="no-response">

            ⏳ The administration has not
            responded to this complaint yet.

        </span>

    </div>

<%

    }

    else {

%>

    <div class="response-box">

        💬 <%= adminResponse %>

    </div>

<%

    }

%>

</div>


<!-- ==========================================
     BACK BUTTON
     ========================================== -->

<a

    href="my-complaints.jsp"

    class="back-button">

    ← Back to My Complaints

</a>


<%

        }

        else {

%>


<!-- ==========================================
     COMPLAINT NOT FOUND
     ========================================== -->

<div class="details-header">

    <div class="details-icon">

        🔒

    </div>


    <h1>

        Complaint Not Available

    </h1>


    <p>

        This complaint does not exist
        or does not belong to your account.

    </p>

</div>


<a

    href="my-complaints.jsp"

    class="back-button">

    ← Back to My Complaints

</a>


<%

        }


    }

    catch (Exception e) {

%>


<!-- ==========================================
     DATABASE ERROR
     ========================================== -->

<div class="details-header">

    <div class="details-icon">

        ⚠️

    </div>


    <h1>

        Database Error

    </h1>


    <p>

        <%= e.getMessage() %>

    </p>

</div>


<a

    href="my-complaints.jsp"

    class="back-button">

    ← Back to My Complaints

</a>


<%

    }

    finally {

        if (rs != null) {

            try {
                rs.close();
            } catch (Exception ignored) {}

        }


        if (ps != null) {

            try {
                ps.close();
            } catch (Exception ignored) {}

        }


        if (con != null) {

            try {
                con.close();
            } catch (Exception ignored) {}

        }

    }

%>


        </div>

    </div>

</div>


</body>

</html>