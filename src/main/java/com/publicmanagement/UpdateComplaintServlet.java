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
import jakarta.servlet.http.HttpSession;

@WebServlet("/updateComplaint")
public class UpdateComplaintServlet extends HttpServlet {

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

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        // =====================================
        // CHECK LOGIN
        // =====================================

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }


        // =====================================
        // CHECK ADMIN
        // =====================================

        String role =
                (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {

            response.sendRedirect("dashboard.jsp");
            return;
        }


        // =====================================
        // GET ADMIN ID
        // =====================================

        int adminId =
                (Integer) session.getAttribute("userId");


        // =====================================
        // GET FORM DATA
        // =====================================

        String id =
                request.getParameter("id");

        String newStatus =
                request.getParameter("status");

        String adminResponse =
                request.getParameter("admin_response");


        // =====================================
        // VALIDATE DATA
        // =====================================

        if (id == null ||
            id.trim().isEmpty() ||
            newStatus == null ||
            newStatus.trim().isEmpty()) {

            response.sendRedirect(
                    "admin-complaints.jsp");

            return;
        }


        int complaintId;

        try {

            complaintId =
                    Integer.parseInt(id);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "admin-complaints.jsp");

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
            // GET OLD STATUS
            // =================================

            String oldStatus = null;


            String getStatusSql =
                    "SELECT status " +
                    "FROM complaints " +
                    "WHERE id = ?";


            PreparedStatement getStatusPs =
                    con.prepareStatement(
                            getStatusSql);


            getStatusPs.setInt(
                    1,
                    complaintId);


            ResultSet statusRs =
                    getStatusPs.executeQuery();


            if (statusRs.next()) {

                oldStatus =
                        statusRs.getString("status");

            } else {

                statusRs.close();
                getStatusPs.close();
                con.close();

                response.sendRedirect(
                        "admin-complaints.jsp");

                return;
            }


            statusRs.close();
            getStatusPs.close();


            // =================================
            // UPDATE COMPLAINT
            // =================================

            String updateSql =
                    "UPDATE complaints " +
                    "SET status = ?, " +
                    "admin_response = ? " +
                    "WHERE id = ?";


            PreparedStatement updatePs =
                    con.prepareStatement(
                            updateSql);


            updatePs.setString(
                    1,
                    newStatus);


            updatePs.setString(
                    2,
                    adminResponse);


            updatePs.setInt(
                    3,
                    complaintId);


            updatePs.executeUpdate();


            updatePs.close();


            // =================================
            // ADD HISTORY ONLY WHEN STATUS
            // ACTUALLY CHANGES
            // =================================

            if (oldStatus == null ||
                !oldStatus.equals(newStatus)) {


                String historySql =
                        "INSERT INTO complaint_history " +
                        "(complaint_id, status, comment, changed_by) " +
                        "VALUES (?, ?, ?, ?)";


                PreparedStatement historyPs =
                        con.prepareStatement(
                                historySql);


                historyPs.setInt(
                        1,
                        complaintId);


                historyPs.setString(
                        2,
                        newStatus);


                // Use the admin response
                // as the history comment

                if (adminResponse != null &&
                    !adminResponse.trim().isEmpty()) {

                    historyPs.setString(
                            3,
                            adminResponse);

                } else {

                    historyPs.setString(
                            3,
                            "Complaint status updated by administrator.");

                }


                historyPs.setInt(
                        4,
                        adminId);


                historyPs.executeUpdate();


                historyPs.close();
            }


            // =================================
            // CLOSE CONNECTION
            // =================================

            con.close();


            // =================================
            // SUCCESS
            // =================================

            response.sendRedirect(
                    "admin-complaints.jsp");


        } catch (Exception e) {

            response.setContentType(
                    "text/html;charset=UTF-8");


            response.getWriter().println(

                "<html>" +

                "<head>" +

                "<title>Update Error</title>" +

                "</head>" +

                "<body>" +

                "<h2>⚠️ Complaint Update Error</h2>" +

                "<p>" +
                e.getMessage() +
                "</p>" +

                "<a href='admin-complaints.jsp'>" +
                "← Back to Complaints" +
                "</a>" +

                "</body>" +

                "</html>"
            );
        }
    }
}