package com.publicmanagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // Railway MySQL environment variables
    private static final String DB_HOST = System.getenv("MYSQLHOST");
    private static final String DB_PORT = System.getenv("MYSQLPORT");
    private static final String DB_NAME = System.getenv("MYSQLDATABASE");
    private static final String DB_USER = System.getenv("MYSQLUSER");
    private static final String DB_PASSWORD = System.getenv("MYSQLPASSWORD");

    private static final String DB_URL =
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&connectTimeout=10000"
            + "&socketTimeout=10000";

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // Get form data
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

        Connection con = null;
        PreparedStatement checkPs = null;
        PreparedStatement insertPs = null;
        ResultSet rs = null;

        try {

            // Load MySQL driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Connect to Railway MySQL
            con = DriverManager.getConnection(
                    DB_URL,
                    DB_USER,
                    DB_PASSWORD
            );

            // Check whether email already exists
            String checkSql =
                    "SELECT id FROM users WHERE email = ?";

            checkPs = con.prepareStatement(checkSql);
            checkPs.setString(1, email.trim());

            rs = checkPs.executeQuery();

            if (rs.next()) {

                showMessage(
                        response,
                        "❌ This email is already registered.",
                        "register.jsp"
                );

                return;
            }

            // Insert new citizen
            String insertSql =
                    "INSERT INTO users "
                    + "(first_name, last_name, email, phone, password, role) "
                    + "VALUES (?, ?, ?, ?, ?, 'CITIZEN')";

            insertPs = con.prepareStatement(insertSql);

            insertPs.setString(1, firstName.trim());
            insertPs.setString(2, lastName.trim());
            insertPs.setString(3, email.trim());
            insertPs.setString(4, phone.trim());
            insertPs.setString(5, password);

            insertPs.executeUpdate();

            // Registration successful
            showMessage(
                    response,
                    "✅ Account created successfully! You can now login.",
                    "index.jsp"
            );

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
                    + "<a href='register.jsp'>← Back to Registration</a>"
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
                + "<a href='" + redirectPage + "'>Continue →</a>"
                + "</div>"
                + "</body>"
                + "</html>"
        );
    }
}