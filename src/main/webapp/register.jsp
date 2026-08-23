<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Register - Public Management System</title>

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

        .register-wrapper {
            width: 92%;
            max-width: 520px;
        }

        .register-card {
            background: white;

            padding: 40px;

            border-radius: 22px;

            box-shadow:
                0 25px 60px
                rgba(0,0,0,0.25);
        }

        .register-header {
            text-align: center;

            margin-bottom: 28px;
        }

        .register-icon {
            font-size: 55px;

            margin-bottom: 8px;
        }

        .register-header h1 {
            background: none;

            padding: 0;

            color: #0f172a;

            font-size: 28px;

            margin-bottom: 8px;
        }

        .register-header p {
            color: #64748b;
        }

        .register-form label {
            display: block;

            font-weight: 600;

            margin-bottom: 7px;

            color: #334155;
        }

        .register-form input {
            width: 100%;

            margin-bottom: 17px;

            box-sizing: border-box;
        }

        .register-button {
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
        }

        .register-button:hover {
            transform: translateY(-2px);

            box-shadow:
                0 8px 20px
                rgba(37,99,235,0.3);
        }

        .login-link {
            text-align: center;

            margin-top: 22px;

            color: #64748b;
        }

        .login-link a {
            color: #2563eb;

            font-weight: 700;

            text-decoration: none;
        }

        .login-link a:hover {
            text-decoration: underline;
        }

    </style>

</head>


<body>


<div class="register-wrapper">

    <div class="register-card">


        <div class="register-header">

            <div class="register-icon">

                📝

            </div>

            <h1>

                Create Your Account

            </h1>

            <p>

                Join the Public Management System ✨

            </p>

        </div>


        <form
            class="register-form"
            action="register"
            method="post">


            <label for="first_name">

                👤 First Name

            </label>

            <input
                type="text"
                id="first_name"
                name="first_name"
                placeholder="Enter your first name"
                required>


            <label for="last_name">

                👤 Last Name

            </label>

            <input
                type="text"
                id="last_name"
                name="last_name"
                placeholder="Enter your last name"
                required>


            <label for="email">

                📧 Email Address

            </label>

            <input
                type="email"
                id="email"
                name="email"
                placeholder="Enter your email"
                required>


            <label for="phone">

                📱 Phone Number

            </label>

            <input
                type="text"
                id="phone"
                name="phone"
                placeholder="Enter your phone number"
                required>


            <label for="password">

                🔐 Password

            </label>

            <input
                type="password"
                id="password"
                name="password"
                placeholder="Create a password"
                required>


            <button
                type="submit"
                class="register-button">

                🚀 Create Account

            </button>


        </form>


        <div class="login-link">

            Already have an account?

            <a href="index.jsp">

                🔐 Login here

            </a>

        </div>


    </div>

</div>


</body>

</html>