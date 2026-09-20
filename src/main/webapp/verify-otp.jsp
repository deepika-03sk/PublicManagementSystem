<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    if (session.getAttribute("registration_email") == null) {
        response.sendRedirect("register.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Verify Email - Public Management System</title>

    <link rel="stylesheet" href="style.css">

    <style>
        body {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background:
                linear-gradient(
                    135deg,
                    #0f172a,
                    #1d4ed8,
                    #581c87
                );
        }

        .otp-wrapper {
            width: 92%;
            max-width: 500px;
        }

        .otp-card {
            background: white;
            padding: 40px;
            border-radius: 22px;
            box-shadow:
                0 25px 60px
                rgba(0, 0, 0, 0.25);
            text-align: center;
        }

        .otp-icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .otp-card h1 {
            color: #0f172a;
            margin-bottom: 10px;
        }

        .otp-card p {
            color: #64748b;
            line-height: 1.6;
        }

        .email-text {
            color: #2563eb;
            font-weight: 700;
            word-break: break-word;
        }

        .otp-input {
            width: 100%;
            box-sizing: border-box;
            padding: 14px;
            margin-top: 20px;
            border: 1px solid #cbd5e1;
            border-radius: 9px;
            text-align: center;
            font-size: 24px;
            letter-spacing: 8px;
            outline: none;
        }

        .otp-input:focus {
            border-color: #2563eb;
            box-shadow:
                0 0 0 3px
                rgba(37, 99, 235, 0.12);
        }

        .verify-button {
            width: 100%;
            margin-top: 20px;
            padding: 13px;
            border: none;
            border-radius: 9px;
            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #4f46e5
                );
            color: white;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
        }

        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #64748b;
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            color: #2563eb;
        }

        .note {
            margin-top: 20px;
            padding: 12px;
            background: #eff6ff;
            border-radius: 8px;
            color: #1e40af;
            font-size: 13px;
        }
    </style>
</head>

<body>

<div class="otp-wrapper">

    <div class="otp-card">

        <div class="otp-icon">
            📧
        </div>

        <h1>Verify Your Email</h1>

        <p>
            We sent a 6-digit verification code to:
        </p>

        <p class="email-text">
            <%= session.getAttribute("registration_email") %>
        </p>

        <form action="verifyOtp" method="post">

            <input
                type="text"
                name="otp"
                class="otp-input"
                placeholder="000000"
                maxlength="6"
                pattern="[0-9]{6}"
                inputmode="numeric"
                required>

            <button
                type="submit"
                class="verify-button">
                ✅ Verify Email
            </button>

        </form>

        <div class="note">
            🔐 Your verification code is valid for 10 minutes.
        </div>

        <a href="register.jsp" class="back-link">
            ← Back to Registration
        </a>

    </div>

</div>

</body>
</html>