package com.publicmanagement;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addUser")
public class AddUserServlet extends HttpServlet {

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

        String firstName = request.getParameter("first_name");
        String lastName = request.getParameter("last_name");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        String sql = "INSERT INTO users " +
                "(first_name, last_name, email, phone, password) " +
                "VALUES (?, ?, ?, ?, ?)";

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, firstName);
            ps.setString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, phone);
            ps.setString(5, password);

            ps.executeUpdate();

            out.println("<h1>User Added Successfully!</h1>");
            out.println("<a href='dashboard.jsp'>Back to Dashboard</a>");

            ps.close();
            con.close();

        } catch (Exception e) {
            out.println("<h1>Database Error</h1>");
            out.println("<p>" + e.getMessage() + "</p>");
        }
    }
}