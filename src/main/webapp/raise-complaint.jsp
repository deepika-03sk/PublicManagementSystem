<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    // User must be logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Raise Complaint</title>

    <link rel="stylesheet" href="style.css">

    <style>

        .complaint-wrapper {
            max-width: 750px;
            margin: 40px auto;
        }

        .complaint-card {
            background: white;
            padding: 40px;
            border-radius: 22px;

            box-shadow:
                0 12px 35px rgba(15, 23, 42, 0.10);
        }

        .complaint-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .complaint-icon {
            font-size: 60px;
            margin-bottom: 10px;
        }

        .complaint-header h1 {
            background: none;
            padding: 0;
            color: #0f172a;
            margin-bottom: 8px;
        }

        .complaint-header p {
            color: #64748b;
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
        .field select,
        .field textarea {
            width: 100%;
        }

        .field textarea {
            min-height: 140px;
            padding: 12px 14px;

            border: 1px solid #cbd5e1;
            border-radius: 9px;

            font-family: inherit;
            font-size: 15px;

            resize: vertical;
            outline: none;
        }

        .field textarea:focus {
            border-color: #2563eb;

            box-shadow:
                0 0 0 3px
                rgba(37, 99, 235, 0.12);
        }

        .form-actions {
            display: flex;
            gap: 12px;
            margin-top: 25px;
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

        .info-box {
            background: #eff6ff;

            border-left: 4px solid #2563eb;

            padding: 14px 16px;

            margin-bottom: 25px;

            border-radius: 8px;

            color: #1e40af;

            font-size: 14px;
        }

        @media (max-width: 650px) {

            .complaint-card {
                padding: 25px;
            }

            .form-actions {
                flex-direction: column;
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

    <div class="complaint-wrapper">

        <div class="complaint-card">


            <!-- HEADER -->

            <div class="complaint-header">

                <div class="complaint-icon">
                    📝
                </div>

                <h1>
                    Raise a Complaint
                </h1>

                <p>
                    Report a public issue and help us
                    improve your community.
                </p>

            </div>


            <!-- INFORMATION -->

            <div class="info-box">

                💡 Please provide accurate information
                about the problem so the concerned
                department can take appropriate action.

            </div>


            <!-- FORM -->

<form
    action="submitComplaint"
    method="post"
    enctype="multipart/form-data">
                <!-- TITLE -->

                <div class="field">

                    <label for="title">
                        📝 Complaint Title
                    </label>

                    <input
                        type="text"
                        id="title"
                        name="title"
                        placeholder="Example: Street light not working"
                        maxlength="150"
                        required>

                </div>


                <!-- CATEGORY -->

                <div class="field">

                    <label for="category">
                        📂 Category
                    </label>

                    <select
                        id="category"
                        name="category"
                        required>

                        <option value="">
                            -- Select Category --
                        </option>

                        <option value="ROADS">
                            🛣️ Roads
                        </option>

                        <option value="ELECTRICITY">
                            💡 Electricity
                        </option>

                        <option value="WATER">
                            💧 Water Supply
                        </option>

                        <option value="SANITATION">
                            🗑️ Sanitation
                        </option>

                        <option value="STREET_LIGHT">
                            🔦 Street Lights
                        </option>

                        <option value="PUBLIC_SAFETY">
                            🛡️ Public Safety
                        </option>

                        <option value="OTHER">
                            📌 Other
                        </option>

                    </select>

                </div>


                <!-- LOCATION -->

                <div class="field">

                    <label for="location">
                        📍 Location
                    </label>

                    <input
                        type="text"
                        id="location"
                        name="location"
                        placeholder="Example: Main Road, Ward 5"
                        maxlength="255"
                        required>

                </div>


                <!-- PRIORITY -->

                <div class="field">

                    <label for="priority">
                        ⚡ Priority
                    </label>

                    <select
                        id="priority"
                        name="priority"
                        required>

                        <option value="LOW">
                            🟢 Low
                        </option>

                        <option value="MEDIUM" selected>
                            🟡 Medium
                        </option>

                        <option value="HIGH">
                            🔴 High
                        </option>

                    </select>

                </div>


                <!-- DESCRIPTION -->

                <div class="field">

                    <label for="description">
                        📄 Complaint Description
                    </label>

                    <textarea
                        id="description"
                        name="description"
                        placeholder="Describe the problem in detail..."
                        required></textarea>

                </div>


<!-- ==========================================
     ATTACHMENT
     ========================================== -->

<div class="field">

    <label for="attachment">

        📎 Attach Evidence

    </label>

    <input
        type="file"
        id="attachment"
        name="attachment"
        accept="image/*"
        required>

    <small style="
        display:block;
        margin-top:8px;
        color:#64748b;
    ">

        📷 You can attach a photo showing
        the problem or issue.

    </small>

</div>

                <!-- BUTTONS -->

                <div class="form-actions">

                    <button type="submit">
                        🚀 Submit Complaint
                    </button>

                    <a
                        href="dashboard.jsp"
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