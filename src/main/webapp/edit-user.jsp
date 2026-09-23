<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.publicmanagement.DBConnection" %>

<%
    // ============================
    // LOGIN PROTECTION
    // ============================

    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // ============================
    // ADMIN PROTECTION
    // ============================

    String currentRole =
        (String) session.getAttribute("role");

    if (!"ADMIN".equals(currentRole)) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Edit User</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .edit-user-wrapper {
            max-width: 700px;
            margin: 40px auto;
        }

        .edit-user-card {
            background: white;
            padding: 40px;
            border-radius: 22px;
            box-shadow:
                0 12px 35px
                rgba(15, 23, 42, 0.10);
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header .icon {
            font-size: 55px;
            margin-bottom: 10px;
        }

        .form-header h1 {
            background: none;
            padding: 0;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .form-header p {
            color: #64748b;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
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

        .field input,
        .field select {
            width: 100%;
            box-sizing: border-box;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 10px;
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

        @media (max-width: 650px) {

            .form-row {
                grid-template-columns: 1fr;
                gap: 0;
            }

            .edit-user-card {
                padding: 25px;
            }

        }

    </style>

</head>

<body>

<!-- ============================
     NAVIGATION
     ============================ -->

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


<!-- ============================
     MAIN CONTENT
     ============================ -->

<div class="container">

    <div class="edit-user-wrapper">

        <div class="edit-user-card">

            <!-- HEADER -->

            <div class="form-header">

                <div class="icon">
                    ✏️👤
                </div>

                <h1>
                    Edit User
                </h1>

                <p>
                    Update the user's information
                    and account role.
                </p>

            </div>


<%
    // ============================
    // GET USER ID
    // ============================

    String id = request.getParameter("id");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {

        // ============================
        // CONNECT TO DATABASE
        // ============================

        Class.forName(
            "com.mysql.cj.jdbc.Driver"
        );

        con = DBConnection.getConnection();

        // ============================
        // GET USER
        // ============================

        ps = con.prepareStatement(
            "SELECT * FROM users WHERE id = ?"
        );

        ps.setInt(
            1,
            Integer.parseInt(id)
        );

        rs = ps.executeQuery();

        if (rs.next()) {

%>

            <!-- ============================
                 EDIT FORM
                 ============================ -->

            <form
                action="updateUser"
                method="post">

                <!-- Hidden ID -->

                <input
                    type="hidden"
                    name="id"
                    value="<%= rs.getInt("id") %>">


                <!-- FIRST + LAST NAME -->

                <div class="form-row">

                    <div class="field">

                        <label for="first_name">
                            👤 First Name
                        </label>

                        <input
                            type="text"
                            id="first_name"
                            name="first_name"
                            value="<%= rs.getString("first_name") %>"
                            required>

                    </div>


                    <div class="field">

                        <label for="last_name">
                            👤 Last Name
                        </label>

                        <input
                            type="text"
                            id="last_name"
                            name="last_name"
                            value="<%= rs.getString("last_name") %>"
                            required>

                    </div>

                </div>


                <!-- EMAIL -->

                <div class="field">

                    <label for="email">
                        📧 Email Address
                    </label>

                    <input
                        type="email"
                        id="email"
                        name="email"
                        value="<%= rs.getString("email") %>"
                        required>

                </div>


                <!-- PHONE -->

                <div class="field">

                    <label for="phone">
                        📱 Phone Number
                    </label>

                    <input
                        type="text"
                        id="phone"
                        name="phone"
                        value="<%= rs.getString("phone") %>"
                        required>

                </div>


                <!-- ROLE -->

                <div class="field">

                    <label for="role">
                        🛡️ User Role
                    </label>

                    <select
                        id="role"
                        name="role"
                        required>

                        <option
                            value="CITIZEN"
                            <%= "CITIZEN".equals(
                                rs.getString("role")
                            ) ? "selected" : "" %>>

                            👤 Citizen

                        </option>

                        <option
                            value="ADMIN"
                            <%= "ADMIN".equals(
                                rs.getString("role")
                            ) ? "selected" : "" %>>

                            👑 Administrator

                        </option>

                    </select>

                </div>


                <!-- BUTTONS -->

                <div class="form-actions">

                    <button
                        type="submit">

                        💾 Update User

                    </button>

                    <a
                        href="users.jsp"
                        class="cancel-button">

                        ↩️ Cancel

                    </a>

                </div>

            </form>


<%
        } else {
%>

            <div class="card">

                <h3>
                    ⚠️ User Not Found
                </h3>

                <p>
                    The requested user could not
                    be found in the database.
                </p>

            </div>

<%
        }

    } catch (Exception e) {
%>

        <div class="card">

            <h3>
                ⚠️ Database Error
            </h3>

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