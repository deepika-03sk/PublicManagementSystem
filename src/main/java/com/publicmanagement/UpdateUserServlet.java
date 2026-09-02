package com.publicmanagement;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateUser")
public class UpdateUserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private static final String DB_HOST =
            System.getenv("MYSQLHOST");

    private static final String DB_PORT =
            System.getenv("MYSQLPORT");

    private static final String DB_NAME =
            System.getenv("MYSQLDATABASE");

    private static final String DB_USER =
            System.getenv("MYSQLUSER");

    private static final String DB_PASSWORD =
            System.getenv("MYSQLPASSWORD");

    private static final String DB_URL =
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME
            + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

    	HttpSession session = request.getSession(false);

    	if (session == null ||
    	    !"ADMIN".equals(session.getAttribute("role"))) {

    	    response.sendRedirect("dashboard.jsp");
    	    return;
    	}
    	int id = Integer.parseInt(request.getParameter("id"));

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");

        String sql = "UPDATE users SET " +
                "first_name = ?, " +
                "last_name = ?, " +
                "email = ?, " +
                "phone = ?, " +
                "role = ? " +
                "WHERE id = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, role);
            ps.setInt(6, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("users.jsp");

        } catch (Exception e) {

            response.setContentType("text/html");

            response.getWriter().println(
                    "<h1>Update Error</h1>");
            response.getWriter().println(
                    "<p>" + e.getMessage() + "</p>");
        }
    }
}