<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.publicmanagement.DBConnection" %>

<%
    String message = "";
    String messageType = "";

    if ("POST".equalsIgnoreCase(request.getMethod())) {

        String email = request.getParameter("email");
        String newPassword = request.getParameter("new_password");
        String confirmPassword = request.getParameter("confirm_password");

        if (email == null || email.trim().isEmpty()
                || newPassword == null || newPassword.trim().isEmpty()
                || confirmPassword == null || confirmPassword.trim().isEmpty()) {

            message = "Please fill in all fields.";
            messageType = "error";

        } else if (!newPassword.equals(confirmPassword)) {

            message = "New password and confirm password do not match.";
            messageType = "error";

        } else {

            Connection con = null;
            PreparedStatement checkPs = null;
            PreparedStatement updatePs = null;
            ResultSet rs = null;

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");

                con = DBConnection.getConnection();

                String checkSql = "SELECT id FROM users WHERE email = ?";
                checkPs = con.prepareStatement(checkSql);
                checkPs.setString(1, email.trim());
                rs = checkPs.executeQuery();

                if (!rs.next()) {

                    message = "No account was found with this email address.";
                    messageType = "error";

                } else {

                    String updateSql =
                            "UPDATE users SET password = ? WHERE email = ?";

                    updatePs = con.prepareStatement(updateSql);
                    updatePs.setString(1, newPassword);
                    updatePs.setString(2, email.trim());

                    int updated = updatePs.executeUpdate();

                    if (updated > 0) {
                        message = "Password reset successfully. You can now login.";
                        messageType = "success";
                    } else {
                        message = "Password could not be updated.";
                        messageType = "error";
                    }
                }

            } catch (Exception e) {

                message = "Unable to reset password: " + e.getMessage();
                messageType = "error";

            } finally {

                try {
                    if (rs != null) rs.close();
                } catch (Exception ignored) {}

                try {
                    if (checkPs != null) checkPs.close();
                } catch (Exception ignored) {}

                try {
                    if (updatePs != null) updatePs.close();
                } catch (Exception ignored) {}

                try {
                    if (con != null) con.close();
                } catch (Exception ignored) {}
            }
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password - Public Management System</title>

    <link rel="stylesheet" href="style.css">

    <style>
        body {
            margin: 0;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f4f7fc;
            font-family: Arial, sans-serif;
        }

        .forgot-card {
            width: 100%;
            max-width: 450px;
            background: white;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 12px 35px rgba(15, 23, 42, 0.12);
            box-sizing: border-box;
        }

        .icon {
            text-align: center;
            font-size: 52px;
            margin-bottom: 10px;
        }

        h1 {
            text-align: center;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .subtitle {
            text-align: center;
            color: #64748b;
            margin-bottom: 28px;
        }

        label {
            display: block;
            margin-bottom: 7px;
            font-weight: 600;
            color: #334155;
        }

        input {
            width: 100%;
            box-sizing: border-box;
            padding: 12px 14px;
            margin-bottom: 18px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            font-size: 15px;
            outline: none;
        }

        input:focus {
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.12);
        }

        .reset-button {
            width: 100%;
            padding: 13px;
            border: none;
            border-radius: 9px;
            background: #2563eb;
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .reset-button:hover {
            background: #1d4ed8;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #2563eb;
            text-decoration: none;
            font-weight: 600;
        }

        .message {
            padding: 12px 14px;
            border-radius: 9px;
            margin-bottom: 20px;
            text-align: center;
            font-weight: 600;
        }

        .success {
            background: #dcfce7;
            color: #166534;
        }

        .error {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
</head>

<body>

<div class="forgot-card">

    <div class="icon">🔐</div>

    <h1>Forgot Password?</h1>

    <p class="subtitle">
        Enter your registered email and create a new password.
    </p>

    <% if (!message.isEmpty()) { %>
        <div class="message <%= messageType %>">
            <%= message %>
        </div>
    <% } %>

    <form method="post" action="forgot-password.jsp">

        <label for="email">Registered Email</label>
        <input
            type="email"
            id="email"
            name="email"
            placeholder="Enter your registered email"
            required>

        <label for="new_password">New Password</label>
        <input
            type="password"
            id="new_password"
            name="new_password"
            placeholder="Enter new password"
            required>

        <label for="confirm_password">Confirm New Password</label>
        <input
            type="password"
            id="confirm_password"
            name="confirm_password"
            placeholder="Confirm new password"
            required>

        <button type="submit" class="reset-button">
            Reset Password
        </button>

    </form>

    <a href="index.jsp" class="back-link">
        ← Back to Login
    </a>

</div>

</body>
</html>