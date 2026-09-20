package com.publicmanagement;

import java.io.IOException;
import java.security.SecureRandom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final SecureRandom RANDOM = new SecureRandom();

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        // Validate form
        if (firstName == null || firstName.trim().isEmpty()
                || lastName == null || lastName.trim().isEmpty()
                || email == null || email.trim().isEmpty()
                || phone == null || phone.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {

            showMessage(
                    response,
                    "⚠️ Please fill in all fields.",
                    "register.jsp"
            );
            return;
        }

        email = email.trim().toLowerCase();

        Connection con = null;
        PreparedStatement checkPs = null;
        ResultSet rs = null;

        try {

            // Connect to Railway MySQL
            con = DBConnection.getConnection();

            // Check whether email already exists
            String checkSql =
                    "SELECT id FROM users WHERE email = ?";

            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email);

            rs = checkPs.executeQuery();

            if (rs.next()) {

                showMessage(
                        response,
                        "❌ This email is already registered.",
                        "register.jsp"
                );
                return;
            }

            // Generate 6-digit OTP
            int otpNumber = 100000 + RANDOM.nextInt(900000);
            String otp = String.valueOf(otpNumber);

            // Store registration details temporarily in session
            HttpSession session = request.getSession();

            session.setAttribute("registration_first_name",
                    firstName.trim());

            session.setAttribute("registration_last_name",
                    lastName.trim());

            session.setAttribute("registration_email",
                    email);

            session.setAttribute("registration_phone",
                    phone.trim());

            session.setAttribute("registration_password",
                    password);

            session.setAttribute("registration_otp",
                    otp);

            session.setAttribute(
                    "registration_otp_time",
                    System.currentTimeMillis()
            );

            // Send OTP email
            boolean emailSent =
                    EmailService.sendOtp(email, otp);

            if (!emailSent) {

                // Remove temporary registration data
                session.removeAttribute("registration_first_name");
                session.removeAttribute("registration_last_name");
                session.removeAttribute("registration_email");
                session.removeAttribute("registration_phone");
                session.removeAttribute("registration_password");
                session.removeAttribute("registration_otp");
                session.removeAttribute("registration_otp_time");

                showMessage(
                        response,
                        "⚠️ Unable to send OTP. Please try again.",
                        "register.jsp"
                );

                return;
            }

            // OTP sent successfully
            response.sendRedirect("verify-otp.jsp");

        } catch (Exception e) {

            response.setContentType("text/html;charset=UTF-8");

            response.getWriter().println(
                    "<html>"
                    + "<head>"
                    + "<title>Registration Error</title>"
                    + "</head>"
                    + "<body>"
                    + "<h2>⚠️ Registration Error</h2>"
                    + "<p>" + e.getMessage() + "</p>"
                    + "<a href='register.jsp'>"
                    + "← Back to Registration"
                    + "</a>"
                    + "</body>"
                    + "</html>"
            );

        } finally {

            try {
                if (rs != null) {
                    rs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (checkPs != null) {
                    checkPs.close();
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

    private void showMessage(
            HttpServletResponse response,
            String message,
            String redirectPage)
            throws IOException {

        response.setContentType("text/html;charset=UTF-8");

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
                + "<h2>" + message + "</h2>"
                + "<a href='" + redirectPage + "'>"
                + "Continue →"
                + "</a>"
                + "</div>"
                + "</body>"
                + "</html>"
        );
    }
}