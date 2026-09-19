package com.publicmanagement;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        response.setContentType("text/html;charset=UTF-8");

        PrintWriter out = response.getWriter();

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || role == null || role.trim().isEmpty()) {

            out.println("<h1>Login Failed!</h1>");
            out.println("<p>Please enter all required details.</p>");
            out.println("<a href='index.jsp'>Back to Login</a>");

            return;
        }

        /*
         * ADMIN login:
         * role must be ADMIN
         *
         * USER login:
         * role must be CITIZEN
         */
        String sql =
                "SELECT id, first_name, last_name, email, role "
                + "FROM users "
                + "WHERE email = ? "
                + "AND password = ? "
                + "AND role = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, username.trim());
            ps.setString(2, password);
            ps.setString(3, role);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                HttpSession session =
                        request.getSession();

                session.setAttribute(
                        "userId",
                        rs.getInt("id")
                );

                session.setAttribute(
                        "firstName",
                        rs.getString("first_name")
                );

                session.setAttribute(
                        "email",
                        rs.getString("email")
                );

                session.setAttribute(
                        "role",
                        rs.getString("role")
                );


                response.sendRedirect(
                        "dashboard.jsp"
                );

            } else {

                out.println(
                        "<html>"
                        + "<head>"
                        + "<title>Login Failed</title>"
                        + "</head>"
                        + "<body style='"
                        + "font-family:Arial;"
                        + "text-align:center;"
                        + "padding-top:100px;"
                        + "'>"
                        + "<h1>❌ Login Failed</h1>"
                        + "<p>Invalid email, password, or login type.</p>"
                        + "<br>"
                        + "<a href='index.jsp'>"
                        + "← Back to Login"
                        + "</a>"
                        + "</body>"
                        + "</html>"
                );
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            out.println(
                    "<html>"
                    + "<head>"
                    + "<title>Login Error</title>"
                    + "</head>"
                    + "<body style='"
                    + "font-family:Arial;"
                    + "text-align:center;"
                    + "padding-top:100px;"
                    + "'>"
                    + "<h1>⚠️ Login Error</h1>"
                    + "<p>"
                    + e.getMessage()
                    + "</p>"
                    + "<br>"
                    + "<a href='index.jsp'>"
                    + "← Back to Login"
                    + "</a>"
                    + "</body>"
                    + "</html>"
            );
        }
    }
}