<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.publicmanagement.DBConnection" %>

<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String currentRole = (String) session.getAttribute("role");
    boolean isAdmin = "ADMIN".equals(currentRole);
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

<nav class="navbar">
    <div class="logo">
        🏛️ Public Management System
    </div>

    <div class="nav-links">
        <a href="dashboard.jsp">🏠 Dashboard</a>
        <a href="users.jsp">👥 Users</a>
        <a href="logout">🚪 Logout</a>
    </div>
</nav>

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

    <div class="table-container">

        <table>

            <thead>
                <tr>
                    <th>ID</th>
                    <th>First Name</th>
                    <th>Last Name</th>
                    <th>Email</th>

                    <% if (isAdmin) { %>
                        <th>Phone</th>
                    <% } %>

                    <th>Role</th>

                    <% if (isAdmin) { %>
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
        con = DBConnection.getConnection();

        st = con.createStatement();

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

                    <% if (isAdmin) { %>
                        <td>
                            <%= rs.getString("phone") %>
                        </td>
                    <% } %>

                    <td>
                        <%= rs.getString("role") %>
                    </td>

                    <% if (isAdmin) { %>
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

    } catch (Exception e) {
%>

                <tr>
                    <td
                        colspan="<%= isAdmin ? "7" : "5" %>"
                        style="color:#dc2626; font-weight:bold; white-space:pre-wrap;">

                        ⚠️ Database Error:<br><br>

                        <%= e.getClass().getName() %><br>
                        <%= e.getMessage() %><br><br>

                        <% if (e.getCause() != null) { %>
                            CAUSE:<br>
                            <%= e.getCause().getClass().getName() %><br>
                            <%= e.getCause().getMessage() %>
                        <% } %>

                    </td>
                </tr>

<%
    } finally {
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

    <% if (isAdmin) { %>
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
