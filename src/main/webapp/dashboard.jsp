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
    // GET CURRENT USER INFORMATION
    // ==========================================

    String firstName =
        (String) session.getAttribute("firstName");

    String email =
        (String) session.getAttribute("email");

    String role =
        (String) session.getAttribute("role");


    // ==========================================
    // DATABASE VARIABLES
    // ==========================================

    int totalUsers = 0;
    int totalAdmins = 0;
    int totalCitizens = 0;


    String url =
        "jdbc:mysql://localhost:3306/public_management_system";

    String username = "root";

    String password = "deepika@1234";


    // ==========================================
    // GET STATISTICS FROM DATABASE
    // ==========================================

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        Connection con =
            DriverManager.getConnection(
                url,
                username,
                password
            );


        // Total users

        PreparedStatement psTotal =
            con.prepareStatement(
                "SELECT COUNT(*) FROM users"
            );

        ResultSet rsTotal =
            psTotal.executeQuery();

        if (rsTotal.next()) {
            totalUsers = rsTotal.getInt(1);
        }


        // Total admins

        PreparedStatement psAdmin =
            con.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE role = 'ADMIN'"
            );

        ResultSet rsAdmin =
            psAdmin.executeQuery();

        if (rsAdmin.next()) {
            totalAdmins = rsAdmin.getInt(1);
        }


        // Total citizens

        PreparedStatement psCitizen =
            con.prepareStatement(
                "SELECT COUNT(*) FROM users WHERE role = 'CITIZEN'"
            );

        ResultSet rsCitizen =
            psCitizen.executeQuery();

        if (rsCitizen.next()) {
            totalCitizens = rsCitizen.getInt(1);
        }


        // Close resources

        rsTotal.close();
        psTotal.close();

        rsAdmin.close();
        psAdmin.close();

        rsCitizen.close();
        psCitizen.close();

        con.close();


    } catch (Exception e) {

        // If database fails, keep dashboard running

        totalUsers = 0;
        totalAdmins = 0;
        totalCitizens = 0;

    }

%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>
        Public Management System
    </title>

    <link rel="stylesheet"
          href="style.css">


    <style>

        /* =====================================
           STATISTICS
           ===================================== */

        .stats-grid {

            display: grid;

            grid-template-columns:
                repeat(
                    auto-fit,
                    minmax(220px, 1fr)
                );

            gap: 22px;

            margin-bottom: 35px;

        }


        .stat-card {

            position: relative;

            background: white;

            padding: 25px;

            border-radius: 18px;

            box-shadow:
                0 8px 25px
                rgba(15, 23, 42, 0.08);

            border: 1px solid #e5e7eb;

            transition: 0.25s;

        }


        .stat-card:hover {

            transform:
                translateY(-6px);

            box-shadow:
                0 16px 35px
                rgba(15, 23, 42, 0.13);

        }


        .stat-icon {

            font-size: 38px;

            margin-bottom: 10px;

        }


        .stat-title {

            color: #64748b;

            font-size: 14px;

            font-weight: 600;

            text-transform: uppercase;

            letter-spacing: 0.5px;

        }


        .stat-number {

            font-size: 36px;

            font-weight: 800;

            color: #1d4ed8;

            margin-top: 5px;

        }


        .stat-description {

            color: #94a3b8;

            font-size: 13px;

            margin-top: 5px;

        }


        /* =====================================
           QUICK ACTIONS TITLE
           ===================================== */

        .section-title {

            font-size: 24px;

            color: #0f172a;

            margin-bottom: 20px;

        }


        /* =====================================
           SYSTEM STATUS
           ===================================== */

        .status-card {

            background:
                linear-gradient(
                    135deg,
                    #ecfdf5,
                    #f0fdf4
                );

            border:
                1px solid #bbf7d0;

            padding: 20px;

            border-radius: 15px;

            margin-top: 30px;

            display: flex;

            align-items: center;

            gap: 15px;

        }


        .status-dot {

            width: 13px;

            height: 13px;

            background: #22c55e;

            border-radius: 50%;

            box-shadow:
                0 0 10px
                rgba(34,197,94,0.7);

        }


        .status-text strong {

            color: #166534;

        }


        .status-text span {

            color: #4b5563;

            font-size: 14px;

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

        <a href="users.jsp">
            👥 Users
        </a>

        <a href="logout">
            🚪 Logout
        </a>

    </div>


</nav>



<!-- ==========================================
     MAIN CONTAINER
     ========================================== -->

<div class="container">

<%
    int totalComplaints = 0;
    int pendingComplaints = 0;
    int inProgressComplaints = 0;
    int resolvedComplaints = 0;
    int rejectedComplaints = 0;

    if ("ADMIN".equals(session.getAttribute("role"))) {

        String dbUrl =
            "jdbc:mysql://localhost:3306/public_management_system";

        String dbUser = "root";
        String dbPassword = "deepika@1234";

        try {

            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con =
                DriverManager.getConnection(
                    dbUrl,
                    dbUser,
                    dbPassword
                );

            Statement st = con.createStatement();

            ResultSet rs =
                st.executeQuery(
                    "SELECT " +
                    "COUNT(*) AS total, " +
                    "SUM(status = 'PENDING') AS pending, " +
                    "SUM(status = 'IN_PROGRESS') AS progress, " +
                    "SUM(status = 'RESOLVED') AS resolved, " +
                    "SUM(status = 'REJECTED') AS rejected " +
                    "FROM complaints"
                );

            if (rs.next()) {

                totalComplaints =
                    rs.getInt("total");

                pendingComplaints =
                    rs.getInt("pending");

                inProgressComplaints =
                    rs.getInt("progress");

                resolvedComplaints =
                    rs.getInt("resolved");

                rejectedComplaints =
                    rs.getInt("rejected");
            }

            rs.close();
            st.close();
            con.close();

        } catch (Exception e) {

            out.println(
                "<p style='color:red;'>"
                + "Statistics Error: "
                + e.getMessage()
                + "</p>"
            );
        }
%>


<!-- =========================================
     COMPLAINT STATISTICS
     ========================================= -->

<div class="stats-section">

    <div class="stats-title">

        <h2>
            📊 Complaint Overview
        </h2>

        <p>
            Monitor citizen complaints and their current status.
        </p>

    </div>


    <div class="stats-grid">


        <div class="stat-card">

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


        <div class="stat-card">

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


        <div class="stat-card">

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


        <div class="stat-card">

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


        <div class="stat-card">

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

    <!-- ======================================
         WELCOME
         ====================================== -->

    <div class="welcome">


        <h1>

            Welcome back,
            <%= firstName %>! 👋

        </h1>


        <p>

            📧 Email:
            <%= email %>

        </p>


        <p>

            🛡️ Role:

            <strong>
                <%= role %>
            </strong>

        </p>


    </div>



    <!-- ======================================
         STATISTICS
         ====================================== -->

    <div class="stats-grid">


        <!-- TOTAL USERS -->

        <div class="stat-card">

            <div class="stat-icon">
                👥
            </div>

            <div class="stat-title">
                Total Users
            </div>

            <div class="stat-number">
                <%= totalUsers %>
            </div>

            <div class="stat-description">
                Registered users
            </div>

        </div>


        <!-- ADMINS -->

        <div class="stat-card">

            <div class="stat-icon">
                👑
            </div>

            <div class="stat-title">
                Administrators
            </div>

            <div class="stat-number">
                <%= totalAdmins %>
            </div>

            <div class="stat-description">
                System administrators
            </div>

        </div>


        <!-- CITIZENS -->

        <div class="stat-card">

            <div class="stat-icon">
                👤
            </div>

            <div class="stat-title">
                Citizens
            </div>

            <div class="stat-number">
                <%= totalCitizens %>
            </div>

            <div class="stat-description">
                Registered citizens
            </div>

        </div>


        <!-- SYSTEM STATUS -->

        <div class="stat-card">

            <div class="stat-icon">
                🟢
            </div>

            <div class="stat-title">
                System Status
            </div>

            <div class="stat-number"
                 style="font-size: 25px; color: #16a34a;">

                ACTIVE

            </div>

            <div class="stat-description">
                Database connected
            </div>

        </div>


    </div>



    <!-- ======================================
         QUICK ACTIONS
         ====================================== -->

    <h2 class="section-title">

        ⚡ Quick Actions

    </h2>


    <div class="dashboard-grid">


        <!-- USERS -->

        <div class="card">

            <h3>
                👥 User Management
            </h3>

            <p>

                View and manage all registered
                users in the system.

            </p>

            <a href="users.jsp">

                View Users →

            </a>

        </div>



        <!-- ADD USER - ADMIN ONLY -->

        <%
        if ("ADMIN".equals(role)) {
        %>


        <div class="card">

            <h3>
                ➕ Add New User
            </h3>

            <p>

                Register a new user and
                assign their system role.

            </p>

            <a href="add-user.jsp">

                Add User →

            </a>

        </div>


        <%
        }
        %>



        <!-- APPLICATIONS -->

        <div class="card">

    <h3>
        📝 Raise Complaint
    </h3>

    <p>
        Report a public issue or problem
        in your area.
    </p>

    <a href="raise-complaint.jsp">
        Raise Complaint →
    </a>

</div>

<div class="card">

    <h3>
        📋 My Complaints
    </h3>

    <p>
        Track the complaints you have
        submitted and check their status.
    </p>

    <a href="my-complaints.jsp">
        View My Complaints →
    </a>

</div>

<%
if ("ADMIN".equals(role)) {
%>

<div class="card">

    <h3>
        📋 Complaint Management
    </h3>

    <p>
        Review, monitor and manage
        citizen complaints.
    </p>

    <a href="admin-complaints.jsp">
        Manage Complaints →
    </a>

</div>

<%
}
%>
        <!-- REPORTS -->

        <div class="card">

            <h3>
                  📊 Reports & Analytics
            </h3>

            <p>

                View reports and analyze
                system information.

            </p>

            <a href="#">

                View Reports →

            </a>

        </div>


    </div>



    <!-- ======================================
         SYSTEM STATUS
         ====================================== -->

    <div class="status-card">


        <div class="status-dot">
        </div>


        <div class="status-text">

            <strong>
                System is running normally
            </strong>

            <br>

            <span>
                🛡️ Your session is active and
                your account is protected.
            </span>

        </div>


    </div>


</div>


</body>

</html>