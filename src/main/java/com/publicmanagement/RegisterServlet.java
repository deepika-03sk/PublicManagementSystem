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

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/public_management_system";

    private static final String DB_USER =
            "root";

    private static final String DB_PASSWORD =
            "deepika@1234";


    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // =====================================
        // GET FORM DATA
        // =====================================

        String firstName =
                request.getParameter("first_name");

        String lastName =
                request.getParameter("last_name");

        String email =
                request.getParameter("email");

        String phone =
                request.getParameter("phone");

        String password =
                request.getParameter("password");


        // =====================================
        // BASIC VALIDATION
        // =====================================

        if (firstName == null ||
            lastName == null ||
            email == null ||
            phone == null ||
            password == null ||

            firstName.trim().isEmpty() ||
            lastName.trim().isEmpty() ||
            email.trim().isEmpty() ||
            phone.trim().isEmpty() ||
            password.trim().isEmpty()) {


            showMessage(
                response,
                "⚠️ Please fill in all fields.",
                "register.jsp"
            );

            return;
        }


        // =====================================
        // DATABASE
        // =====================================

        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");


            Connection con =
                    DriverManager.getConnection(
                            DB_URL,
                            DB_USER,
                            DB_PASSWORD);


            // =================================
            // CHECK EMAIL
            // =================================

            String checkSql =
                    "SELECT id FROM users WHERE email = ?";


            PreparedStatement checkPs =
                    con.prepareStatement(
                            checkSql);


            checkPs.setString(
                    1,
                    email.trim());


            ResultSet rs =
                    checkPs.executeQuery();


            if (rs.next()) {

                rs.close();

                checkPs.close();

                con.close();


                showMessage(
                    response,
                    "❌ This email is already registered.",
                    "register.jsp"
                );

                return;
            }


            rs.close();

            checkPs.close();


            // =================================
            // INSERT CITIZEN
            // =================================

            String insertSql =
                    "INSERT INTO users " +
                    "(first_name, last_name, email, phone, password, role) " +
                    "VALUES (?, ?, ?, ?, ?, 'CITIZEN')";


            PreparedStatement insertPs =
                    con.prepareStatement(
                            insertSql);


            insertPs.setString(
                    1,
                    firstName.trim());


            insertPs.setString(
                    2,
                    lastName.trim());


            insertPs.setString(
                    3,
                    email.trim());


            insertPs.setString(
                    4,
                    phone.trim());


            insertPs.setString(
                    5,
                    password);


            insertPs.executeUpdate();


            insertPs.close();

            con.close();


            // =================================
            // SUCCESS
            // =================================

            showMessage(
                response,
                "✅ Account created successfully! " +
                "You can now login.",
                "index.jsp"
            );


        } catch (Exception e) {


            response.setContentType(
                    "text/html;charset=UTF-8");


            response.getWriter().println(

                "<html>" +

                "<head>" +

                "<title>Registration Error</title>" +

                "</head>" +

                "<body>" +

                "<h2>⚠️ Registration Error</h2>" +

                "<p>" +
                e.getMessage() +
                "</p>" +

                "<a href='register.jsp'>" +
                "← Back to Registration" +
                "</a>" +

                "</body>" +

                "</html>"
            );
        }

    }


    // ==========================================
    // MESSAGE PAGE
    // ==========================================

    private void showMessage(
            HttpServletResponse response,
            String message,
            String redirectPage)
            throws IOException {


        response.setContentType(
                "text/html;charset=UTF-8");


        response.getWriter().println(

            "<html>" +

            "<head>" +

            "<title>Public Management System</title>" +

            "<style>" +

            "body{" +
            "font-family:Arial;" +
            "background:#f4f7fc;" +
            "text-align:center;" +
            "padding-top:100px;" +
            "}" +

            ".box{" +
            "background:white;" +
            "padding:40px;" +
            "border-radius:20px;" +
            "max-width:500px;" +
            "margin:auto;" +
            "box-shadow:0 10px 30px rgba(0,0,0,0.1);" +
            "}" +

            "h2{" +
            "color:#0f172a;" +
            "}" +

            "a{" +
            "display:inline-block;" +
            "margin-top:20px;" +
            "padding:12px 20px;" +
            "background:#2563eb;" +
            "color:white;" +
            "text-decoration:none;" +
            "border-radius:8px;" +
            "font-weight:bold;" +
            "}" +

            "</style>" +

            "</head>" +

            "<body>" +

            "<div class='box'>" +

            "<h2>" +
            message +
            "</h2>" +

            "<a href='" +
            redirectPage +
            "'>" +

            "Continue →" +

            "</a>" +

            "</div>" +

            "</body>" +

            "</html>"
        );
    }
}