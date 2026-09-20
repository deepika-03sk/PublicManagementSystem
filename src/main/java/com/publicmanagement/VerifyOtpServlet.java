package com.publicmanagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/verifyOtp")
public class VerifyOtpServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // OTP validity: 10 minutes
    private static final long OTP_VALIDITY =
            10 * 60 * 1000L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Make sure registration session exists
        if (session == null
                || session.getAttribute("registration_email") == null) {

            showMessage(
                    response,
                    "⚠️ Your registration session has expired. Please register again.",
                    "register.jsp"
            );
            return;
        }

        String enteredOtp =
                request.getParameter("otp");

        String storedOtp =
                (String) session.getAttribute("registration_otp");

        Long otpTime =
                (Long) session.getAttribute("registration_otp_time");

        // Validate OTP input
        if (enteredOtp == null
                || enteredOtp.trim().isEmpty()) {

            showMessage(
                    response,
                    "⚠️ Please enter the OTP.",
                    "verify-otp.jsp"
            );
            return;
        }

        // Check OTP expiry
        if (otpTime == null
                || System.currentTimeMillis() - otpTime
                > OTP_VALIDITY) {

            clearRegistrationSession(session);

            showMessage(
                    response,
                    "⏰ OTP expired. Please register again.",
                    "register.jsp"
            );
            return;
        }

        // Check OTP
        if (storedOtp == null
                || !storedOtp.equals(enteredOtp.trim())) {

            showMessage(
                    response,
                    "❌ Invalid OTP. Please enter the correct code.",
                    "verify-otp.jsp"
            );
            return;
        }

        // Get registration details
        String firstName =
                (String) session.getAttribute(
                        "registration_first_name");

        String lastName =
                (String) session.getAttribute(
                        "registration_last_name");

        String email =
                (String) session.getAttribute(
                        "registration_email");

        String phone =
                (String) session.getAttribute(
                        "registration_phone");

        String password =
                (String) session.getAttribute(
                        "registration_password");

        Connection con = null;
        PreparedStatement insertPs = null;

        try {

            // Connect to Railway MySQL
            con = DBConnection.getConnection();

            String insertSql =
                    "INSERT INTO users "
                    + "(first_name, last_name, email, phone, password, role) "
                    + "VALUES (?, ?, ?, ?, ?, 'CITIZEN')";

            insertPs =
                    con.prepareStatement(insertSql);

            insertPs.setString(1, firstName);
            insertPs.setString(2, lastName);
            insertPs.setString(3, email);
            insertPs.setString(4, phone);
            insertPs.setString(5, password);

            insertPs.executeUpdate();

            // Remove temporary registration data
            clearRegistrationSession(session);

            // Registration completed
            showMessage(
                    response,
                    "✅ Email verified! Your account has been created successfully.",
                    "index.jsp"
            );

        } catch (Exception e) {

            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                    "<html>"
                    + "<head>"
                    + "<title>Registration Error</title>"
                    + "</head>"
                    + "<body>"
                    + "<h2>⚠️ Registration Error</h2>"
                    + "<p>"
                    + e.getMessage()
                    + "</p>"
                    + "<a href='register.jsp'>"
                    + "← Back to Registration"
                    + "</a>"
                    + "</body>"
                    + "</html>"
            );

        } finally {

            try {
                if (insertPs != null) {
                    insertPs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception ignored) {
            }
        }
    }

    private void clearRegistrationSession(
            HttpSession session) {

        session.removeAttribute(
                "registration_first_name");

        session.removeAttribute(
                "registration_last_name");

        session.removeAttribute(
                "registration_email");

        session.removeAttribute(
                "registration_phone");

        session.removeAttribute(
                "registration_password");

        session.removeAttribute(
                "registration_otp");

        session.removeAttribute(
                "registration_otp_time");
    }

    private void showMessage(
            HttpServletResponse response,
            String message,
            String redirectPage)
            throws IOException {

        response.setContentType(
                "text/html;charset=UTF-8");

        response.getWriter().println(
                "<html>"
                + "<head>"
                + "<title>Public Management System</title>"
                + "<style>"
                + "body{"
                + "font-family:Arial;"
                + "background:#f4f7fc;"
                + "text-align:center;"
                + "padding-top:100px;"
                + "}"
                + ".box{"
                + "background:white;"
                + "padding:40px;"
                + "border-radius:20px;"
                + "max-width:500px;"
                + "margin:auto;"
                + "box-shadow:0 10px 30px rgba(0,0,0,0.1);"
                + "}"
                + "a{"
                + "display:inline-block;"
                + "margin-top:20px;"
                + "padding:12px 20px;"
                + "background:#2563eb;"
                + "color:white;"
                + "text-decoration:none;"
                + "border-radius:8px;"
                + "font-weight:bold;"
                + "}"
                + "</style>"
                + "</head>"
                + "<body>"
                + "<div class='box'>"
                + "<h2>"
                + message
                + "</h2>"
                + "<a href='"
                + redirectPage
                + "'>"
                + "Continue →"
                + "</a>"
                + "</div>"
                + "</body>"
                + "</html>"
        );
    }
}