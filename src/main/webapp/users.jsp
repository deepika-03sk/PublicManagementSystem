<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.publicmanagement.DBConnection" %>

<%
    // Protect the page: user must be logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Get logged-in user's role
    String currentRole = (String) session.getAttribute("role");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management</title>
    <link rel="stylesheet" href="style.css">
</head>

<body>

<!-- =========================
     NAVIGATION BAR
     ========================= -->

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


<!-- =========================
     MAIN CONTENT
     ========================= -->

<div class="container">

    <h1 class="page-title">
        👥 User Management
    </h1>

    <p>
        Manage all registered users in the system.
    </p>

    <br>

    <a class="back-link" href="dashboard.jsp">
        ← Back to Dashboard
    </a>


    <!-- =========================
         USER TABLE
         ========================= -->

    <div class="table-container">

        <table>

            <thead>

                <tr>

                    <th>ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>

                    <% if ("ADMIN".equals(currentRole)) { %>
                        <th>Action</th>
                    <% } %>

                </tr>

            </thead>


            <tbody>

<%
    Connection con = null;
    Statement st = null;
    ResultSet rs = null;

    try {

        // Use the central database connection
        con = DBConnection.getConnection();

        // Create SQL statement
        st = con.createStatement();

        // Get users
        rs = st.executeQuery(
            "SELECT id, first_name, last_name, email, phone, role " +
            "FROM users ORDER BY id ASC"
        );

        int displayNumber = 1;

        while (rs.next()) {
%>

                <tr>

                    <td>
                        <%= displayNumber %>
                    </td>

                    <td>
                        <%= rs.getString("first_name") %>
                    </td>

                    <td>
                        <%= rs.getString("last_name") %>
                    </td>

                    <td>
                        <%= rs.getString("email") %>
                    </td>

                    <td>
                        <%= rs.getString("phone") %>
                    </td>

                    <td>
                        <%= rs.getString("role") %>
                    </td>


                    <% if ("ADMIN".equals(currentRole)) { %>

                    <td>

                        <a
                            class="action-edit"
                            href="edit-user.jsp?id=<%= rs.getInt("id") %>">
                            ✏️ Edit
                        </a>

                        &nbsp;

                        <a
                            class="action-delete"
                            href="deleteUser?id=<%= rs.getInt("id") %>"
                            onclick="return confirm('Are you sure you want to delete this user?');">
                            🗑️ Delete
                        </a>

                    </td>

                    <% } %>

                </tr>

<%
            displayNumber++;
        }
        rs.close();
        st.close();
        con.close();

    } catch (Exception e) {
%>

                <tr>

                    <td
                        colspan="<%= "ADMIN".equals(currentRole) ? "7" : "6" %>"
                        style="color: #dc2626; font-weight: bold;">

                        ⚠️ Database Error:
                        <%= e.getMessage() %>

                    </td>

                </tr>

<%
    } finally {

        // Close database resources safely

        try {
            if (rs != null) rs.close();
        } catch (Exception ignored) {}

        try {
            if (st != null) st.close();
        } catch (Exception ignored) {}

        try {
            if (con != null) con.close();
        } catch (Exception ignored) {}
    }
%>

            </tbody>

        </table>

    </div>


    <!-- =========================
         ADMIN ADD USER BUTTON
         ========================= -->

    <% if ("ADMIN".equals(currentRole)) { %>

        <br>

        <a href="add-user.jsp">

            <button type="button">
                ➕ Add New User
            </button>

        </a>

    <% } %>

</div>

</body>

</html>