<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Public Management System - Login</title>

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

        .login-wrapper {
            width: 92%;
            max-width: 430px;
        }

        .login-card {
            background: white;

            padding: 42px;

            border-radius: 22px;

            box-shadow:
                0 25px 60px rgba(0,0,0,0.25);

            text-align: center;
        }

        .login-icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .login-card h1 {
            background: none;
            padding: 0;
            color: #0f172a;
            font-size: 28px;
            margin-bottom: 8px;
        }

        .login-card .subtitle {
            color: #64748b;
            margin-bottom: 30px;
        }

        .login-form {
            text-align: left;
        }

        .login-form label {
            display: block;
            font-weight: 600;
            margin-bottom: 7px;
            color: #334155;
        }

        .login-form input {
            width: 100%;
            margin-bottom: 18px;
        }

        .login-button {
            width: 100%;

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

            transition: 0.25s;
        }

        .login-button:hover {
            transform: translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(37,99,235,0.3);
        }

        .login-footer {
            margin-top: 25px;

            color: #94a3b8;

            font-size: 13px;
        }

    </style>

</head>


<body>


<div class="login-wrapper">


    <div class="login-card">


        <div class="login-icon">
            🏛️
        </div>


        <h1>
            Public Management System
        </h1>


        <p class="subtitle">
            Smart Administration, Better Services ✨
        </p>


        <form
            class="login-form"
            action="login"
            method="post">


            <label for="email">
                📧 Email Address
            </label>

            <input
                type="email"
                id="email"
                name="username"
                placeholder="Enter your email"
                required>


            <label for="password">
                🔐 Password
            </label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Enter your password"
                required>


            <button
                type="submit"
                class="login-button">

                🚀 Login

            </button>


        </form>

<div style="
    margin-top:20px;
    color:#64748b;
    font-size:14px;
">

    Don't have an account?

    <a
        href="register.jsp"
        style="
            color:#2563eb;
            font-weight:700;
            text-decoration:none;
        ">

        📝 Register here

    </a>

</div>

        <div class="login-footer">

            🔒 Secure Public Management System

            <br><br>

            Made with ❤️ for better public services

        </div>


    </div>


</div>


</body>

</html>