<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

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

        .subtitle {
            color: #64748b;
            margin-bottom: 30px;
        }

        .role-title {
            color: #334155;
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .role-button {
            width: 100%;
            padding: 15px;
            margin-bottom: 15px;

            border: none;
            border-radius: 10px;

            color: white;
            font-size: 16px;
            font-weight: 700;

            cursor: pointer;
            transition: 0.25s;
        }

        .admin-button {
            background:
                linear-gradient(
                    135deg,
                    #7c3aed,
                    #4f46e5
                );
        }

        .user-button {
            background:
                linear-gradient(
                    135deg,
                    #2563eb,
                    #0891b2
                );
        }

        .role-button:hover {
            transform: translateY(-2px);
            box-shadow:
                0 8px 20px rgba(37,99,235,0.25);
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
            box-sizing: border-box;
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
                0 8px 20px rgba(37,99,235,0.3);
        }

        .forgot-password {
            display: block;
            text-align: right;
            margin-top: -8px;
            margin-bottom: 18px;

            color: #2563eb;
            font-size: 14px;
            font-weight: 600;

            text-decoration: none;
        }

        .forgot-password:hover {
            text-decoration: underline;
        }

        .back-button {
            width: 100%;
            margin-top: 12px;
            padding: 11px;

            border: 1px solid #cbd5e1;
            border-radius: 9px;

            background: white;
            color: #475569;

            font-size: 14px;
            font-weight: 600;

            cursor: pointer;
        }

        .register-link {
            margin-top: 20px;
            color: #64748b;
            font-size: 14px;
            text-align: center;
        }

        .register-link a {
            color: #2563eb;
            font-weight: 700;
            text-decoration: none;
        }

        .login-footer {
            margin-top: 25px;
            color: #94a3b8;
            font-size: 13px;
        }

        #loginSection {
            display: none;
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


        <!-- ============================= -->
        <!-- ROLE SELECTION -->
        <!-- ============================= -->

        <div id="roleSection">

            <div class="role-title">
                Choose Login Type
            </div>

            <button
                type="button"
                class="role-button admin-button"
                onclick="selectRole('ADMIN')">

                👨‍💼 ADMIN

            </button>

            <button
                type="button"
                class="role-button user-button"
                onclick="selectRole('CITIZEN')">

                👤 USER

            </button>

        </div>


        <!-- ============================= -->
        <!-- LOGIN FORM -->
        <!-- ============================= -->

        <div id="loginSection">

            <div
                id="selectedRole"
                style="
                    margin-bottom:20px;
                    color:#475569;
                    font-weight:700;
                ">
            </div>

            <form
                class="login-form"
                action="login"
                method="post">

                <!-- Selected role is sent to LoginServlet -->
                <input
                    type="hidden"
                    id="role"
                    name="role"
                    value="">

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


                <a
                    href="forgot-password.jsp"
                    class="forgot-password">

                    Forgot Password?

                </a>


                <button
                    type="submit"
                    class="login-button">

                    🚀 Login

                </button>

            </form>


            <!-- Registration is only shown for users -->
            <div
                id="registerSection"
                class="register-link">

                Don't have an account?

                <a href="register.jsp">
                    📝 Register here
                </a>

            </div>


            <button
                type="button"
                class="back-button"
                onclick="goBack()">

                ← Choose Different Login Type

            </button>

        </div>


        <div class="login-footer">

            🔒 Secure Public Management System

            <br><br>

            Made with ❤️ for better public services

        </div>

    </div>

</div>


<script>

function selectRole(role) {

    document.getElementById("role").value = role;

    document.getElementById("roleSection").style.display = "none";

    document.getElementById("loginSection").style.display = "block";


    if (role === "ADMIN") {

        document.getElementById("selectedRole").innerHTML =
            "👨‍💼 Admin Login";

        document.getElementById("registerSection").style.display =
            "none";

    } else {

        document.getElementById("selectedRole").innerHTML =
            "👤 User Login";

        document.getElementById("registerSection").style.display =
            "block";
    }
}


function goBack() {

    document.getElementById("loginSection").style.display = "none";

    document.getElementById("roleSection").style.display = "block";

    document.getElementById("role").value = "";

}

</script>

</body>
</html>