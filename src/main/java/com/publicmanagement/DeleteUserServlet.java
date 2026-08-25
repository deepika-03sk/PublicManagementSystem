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

@WebServlet("/deleteUser")
public class DeleteUserServlet extends HttpServlet {

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
	        + "?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {
    	HttpSession session = request.getSession(false);

    	if (session == null ||
    	    !"ADMIN".equals(session.getAttribute("role"))) {

    	    response.sendRedirect("dashboard.jsp");
    	    return;
    	}
        int id = Integer.parseInt(request.getParameter("id"));

        String sql = "DELETE FROM users WHERE id = ?";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            Connection con = DriverManager.getConnection(
                    DB_URL, DB_USER, DB_PASSWORD);

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, id);

            ps.executeUpdate();

            ps.close();
            con.close();

            response.sendRedirect("users.jsp");

        } catch (Exception e) {
            response.setContentType("text/html");
            response.getWriter().println(
                    "<h1>Delete Error</h1><p>" + e.getMessage() + "</p>");
        }
    }
}