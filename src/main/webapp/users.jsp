<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.*" %>

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

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


    <!-- PAGE TITLE -->

    <h1 class="page-title">
        👥 User Management
    </h1>

    <p>
        Manage all registered users in the system.
    </p>


    <!-- BACK TO DASHBOARD -->

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

    /*
     * DATABASE CONNECTION
     */
     String url = System.getenv("MYSQL_URL");
     String username = System.getenv("MYSQLUSER");
     String password = System.getenv("MYSQLPASSWORD");
   

    try {

        // Load MySQL JDBC Driver
        Class.forName("com.mysql.cj.jdbc.Driver");


        // Connect to database
        Connection con =
            DriverManager.getConnection(
                url,
                username,
                password
            );


        // Create SQL statement
        Statement st =
            con.createStatement();


        // Get users in ID order
        ResultSet rs =
            st.executeQuery(
                "SELECT id, first_name, last_name, email, phone, role " +
                "FROM users ORDER BY id ASC"
            );

        int displayNumber = 1;
        // Display users
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


                    <!-- ADMIN ACTIONS -->

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

        // Close database resources
        rs.close();

        st.close();

        con.close();


    } catch (Exception e) {

%>

                <!-- DATABASE ERROR -->

                <tr>

                    <td
                        colspan="<%= "ADMIN".equals(currentRole) ? "7" : "6" %>"
                        style="color: #dc2626; font-weight: bold;">

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