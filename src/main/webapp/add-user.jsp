<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // User must be logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Only ADMIN can access this page
    if (!"ADMIN".equals(session.getAttribute("role"))) {
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

    <title>Add New User</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .add-user-wrapper {
            max-width: 700px;
            margin: 40px auto;
        }

        .add-user-card {
            background: white;

            padding: 40px;

            border-radius: 22px;

            box-shadow:
                0 12px 35px rgba(15, 23, 42, 0.10);
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
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 10px;
        }

        .form-actions input[type="submit"] {
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

            .add-user-card {
                padding: 25px;
            }

        }

    </style>

</head>


<body>


<!-- NAVIGATION -->

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


<!-- MAIN -->

<div class="container">


    <div class="add-user-wrapper">


        <div class="add-user-card">


            <!-- HEADER -->

            <div class="form-header">

                <div class="icon">
                    👤➕
                </div>

                <h1>
                    Add New User
                </h1>

                <p>
                    Register a new user in the
                    Public Management System.
                </p>

            </div>


            <!-- FORM -->

            <form
                action="addUser"
                method="post">


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
                            placeholder="Enter first name"
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
                            placeholder="Enter last name"
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
                        placeholder="Enter email address"
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
                        placeholder="Enter phone number"
                        required>

                </div>


                <!-- PASSWORD -->

                <div class="field">

                    <label for="password">
                        🔐 Password
                    </label>

                    <input
                        type="password"
                        id="password"
                        name="password"
                        placeholder="Create a password"
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

                        <option value="CITIZEN">
                            👤 Citizen
                        </option>

                        <option value="ADMIN">
                            👑 Administrator
                        </option>

                    </select>

                </div>


                <!-- BUTTONS -->

                <div class="form-actions">

                    <input
                        type="submit"
                        value="➕ Add User">

                    <a
                        href="users.jsp"
                        class="cancel-button">

                        ↩️ Cancel

                    </a>

                </div>


            </form>


        </div>


    </div>


</div>


</body>

</html>