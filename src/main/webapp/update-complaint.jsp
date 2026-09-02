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
    // ADMIN PROTECTION
    // ==========================================

    String currentRole =
        (String) session.getAttribute("role");

    if (!"ADMIN".equals(currentRole)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }


    // ==========================================
    // GET COMPLAINT ID
    // ==========================================

    String complaintId =
        request.getParameter("id");

    if (complaintId == null || complaintId.trim().isEmpty()) {
        response.sendRedirect("admin-complaints.jsp");
        return;
    }
%>


<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Update Complaint</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .update-wrapper {
            max-width: 750px;
            margin: 40px auto;
        }

        .update-card {
            background: white;
            padding: 40px;
            border-radius: 22px;

            box-shadow:
                0 12px 35px
                rgba(15, 23, 42, 0.10);
        }

        .update-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .update-icon {
            font-size: 55px;
            margin-bottom: 10px;
        }

        .update-header h1 {
            background: none;
            padding: 0;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .update-header p {
            color: #64748b;
        }

        .complaint-info {
            background: #f8fafc;
            padding: 20px;
            border-radius: 12px;
            margin-bottom: 25px;
        }

        .info-row {
            margin-bottom: 10px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            font-weight: 700;
            color: #334155;
        }

        .field {
            margin-bottom: 20px;
        }

        .field label {
            display: block;
            font-weight: 600;
            color: #334155;
            margin-bottom: 8px;
        }

        .field select,
        .field textarea {
            width: 100%;
        }

        .field textarea {
            min-height: 130px;
            padding: 12px 14px;

            border: 1px solid #cbd5e1;
            border-radius: 9px;

            font-family: inherit;
            font-size: 15px;

            resize: vertical;
            outline: none;
        }

        .field textarea:focus {
            border-color: #2563eb;

            box-shadow:
                0 0 0 3px
                rgba(37, 99, 235, 0.12);
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
        }

        .form-actions button {
            flex: 1;
        }

        .cancel-button {
            display: inline-flex;

            align-items: center;
            justify-content: center;

            padding: 12px 22px;

            border-radius: 9px;

            background: #e2e8f0;

            color: #334155;

            text-decoration: none;

            font-weight: 600;
        }

        .cancel-button:hover {
            background: #cbd5e1;
            color: #0f172a;
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

        <a href="admin-complaints.jsp">
            📋 Complaints
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

    <div class="update-wrapper">

        <div class="update-card">


<%
Connection con = DriverManager.getConnection(
	    System.getenv("MYSQL_URL").replaceFirst("^mysql://", "jdbc:mysql://"),
	    System.getenv("MYSQLUSER"),
	    System.getenv("MYSQLPASSWORD")
	);

    try {

        Class.forName(
            "com.mysql.cj.jdbc.Driver"
        );


        Connection con = DBConnection.getConnection();

        String sql =
            "SELECT c.*, " +
            "u.first_name, u.last_name, u.email " +
            "FROM complaints c " +
            "JOIN users u ON c.user_id = u.id " +
            "WHERE c.id = ?";


        PreparedStatement ps =
            con.prepareStatement(sql);


        ps.setInt(
            1,
            Integer.parseInt(complaintId)
        );


        ResultSet rs =
            ps.executeQuery();


        if (rs.next()) {

%>


            <!-- HEADER -->

            <div class="update-header">

                <div class="update-icon">
                    🔄
                </div>

                <h1>
                    Update Complaint
                </h1>

                <p>
                    Review the complaint and
                    update its current status.
                </p>

            </div>


            <!-- COMPLAINT INFORMATION -->

            <div class="complaint-info">

                <div class="info-row">

                    <span class="info-label">
                        📋 Complaint ID:
                    </span>

                    CMP-<%= rs.getInt("id") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        👤 Citizen:
                    </span>

                    <%= rs.getString("first_name") %>
                    <%= rs.getString("last_name") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        📧 Email:
                    </span>

                    <%= rs.getString("email") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        📝 Complaint:
                    </span>

                    <%= rs.getString("title") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        📂 Category:
                    </span>

                    <%= rs.getString("category") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        📍 Location:
                    </span>

                    <%= rs.getString("location") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        ⚡ Priority:
                    </span>

                    <%= rs.getString("priority") %>

                </div>


                <div class="info-row">

                    <span class="info-label">
                        📄 Description:
                    </span>

                    <br><br>

                    <%= rs.getString("description") %>

                </div>

            </div>


            <!-- UPDATE FORM -->

            <form
                action="updateComplaint"
                method="post">


                <input
                    type="hidden"
                    name="id"
                    value="<%= rs.getInt("id") %>">


                <!-- STATUS -->

                <div class="field">

                    <label for="status">

                        🔄 Complaint Status

                    </label>


                    <select
                        id="status"
                        name="status"
                        required>


                        <option
                            value="PENDING"
                            <%= "PENDING".equals(
                                rs.getString("status")
                            ) ? "selected" : "" %>>

                            🟡 Pending

                        </option>


                        <option
                            value="IN_PROGRESS"
                            <%= "IN_PROGRESS".equals(
                                rs.getString("status")
                            ) ? "selected" : "" %>>

                            🔵 In Progress

                        </option>


                        <option
                            value="RESOLVED"
                            <%= "RESOLVED".equals(
                                rs.getString("status")
                            ) ? "selected" : "" %>>

                            🟢 Resolved

                        </option>


                        <option
                            value="REJECTED"
                            <%= "REJECTED".equals(
                                rs.getString("status")
                            ) ? "selected" : "" %>>

                            🔴 Rejected

                        </option>


                    </select>

                </div>


                <!-- ADMIN RESPONSE -->

                <div class="field">

                    <label for="admin_response">

                        💬 Admin Response

                    </label>


                    <textarea
                        id="admin_response"
                        name="admin_response"
                        placeholder="Enter a response for the citizen..."><%= rs.getString("admin_response") == null ? "" : rs.getString("admin_response") %></textarea>

                </div>


                <!-- BUTTONS -->

                <div class="form-actions">


                    <button
                        type="submit">

                        💾 Update Complaint

                    </button>


                    <a
                        href="admin-complaints.jsp"
                        class="cancel-button">

                        ↩️ Cancel

                    </a>


                </div>


            </form>


<%

        } else {

%>


            <div class="update-header">

                <div class="update-icon">
                    ⚠️
                </div>

                <h1>
                    Complaint Not Found
                </h1>

                <p>
                    The requested complaint does not
                    exist in the database.
                </p>

                <br>

                <a href="admin-complaints.jsp">
                    ← Back to Complaints
                </a>

            </div>


<%

        }


        rs.close();

        ps.close();

        con.close();


    } catch (Exception e) {

%>


        <div class="update-header">

            <div class="update-icon">
                ⚠️
            </div>

            <h1>
                Database Error
            </h1>

            <p>
                <%= e.getMessage() %>
            </p>

        </div>


<%

    }

%>


        </div>

    </div>

</div>


</body>

</html>