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

    private static final String DB_URL =
            "jdbc:mysql://localhost:3306/public_management_system";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "deepika@1234";

    protected void doGet(HttpServletRequest request,
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