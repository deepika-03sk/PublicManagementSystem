package com.publicmanagement;

import java.io.IOException;
import java.sql.Connection;
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

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK LOGIN
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        // CHECK ADMIN
        String role = (String) session.getAttribute("role");

        if (!"ADMIN".equals(role)) {
            response.sendRedirect("dashboard.jsp");
            return;
        }

        // GET ADMIN ID
        int adminId = (Integer) session.getAttribute("userId");

        // GET FORM DATA
        String id = request.getParameter("id");
        String newStatus = request.getParameter("status");
        String adminResponse = request.getParameter("admin_response");

        // VALIDATE DATA
        if (id == null ||
            id.trim().isEmpty() ||
            newStatus == null ||
            newStatus.trim().isEmpty()) {

            response.sendRedirect("admin-complaints.jsp");
            return;
        }

        int complaintId;

        try {
            complaintId = Integer.parseInt(id);
        } catch (NumberFormatException e) {
            response.sendRedirect("admin-complaints.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement complaintPs = null;
        PreparedStatement updatePs = null;
        PreparedStatement historyPs = null;
        ResultSet complaintRs = null;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            con = DBConnection.getConnection();

            // GET OLD STATUS AND CITIZEN DETAILS
            String complaintSql =
                    "SELECT c.status, u.first_name, u.email " +
                    "FROM complaints c " +
                    "JOIN users u ON c.user_id = u.id " +
                    "WHERE c.id = ?";

            complaintPs = con.prepareStatement(complaintSql);
            complaintPs.setInt(1, complaintId);

            complaintRs = complaintPs.executeQuery();

            if (!complaintRs.next()) {
                response.sendRedirect("admin-complaints.jsp");
                return;
            }

            String oldStatus = complaintRs.getString("status");
            String citizenName = complaintRs.getString("first_name");
            String citizenEmail = complaintRs.getString("email");

            complaintRs.close();
            complaintRs = null;

            complaintPs.close();
            complaintPs = null;

            // UPDATE COMPLAINT
            String updateSql =
                    "UPDATE complaints " +
                    "SET status = ?, admin_response = ? " +
                    "WHERE id = ?";

            updatePs = con.prepareStatement(updateSql);

            updatePs.setString(1, newStatus);
            updatePs.setString(2, adminResponse);
            updatePs.setInt(3, complaintId);

            updatePs.executeUpdate();

            updatePs.close();
            updatePs = null;

            // ADD HISTORY ONLY WHEN STATUS CHANGES
            if (oldStatus == null ||
                !oldStatus.equals(newStatus)) {

                String historySql =
                        "INSERT INTO complaint_history " +
                        "(complaint_id, status, comment, changed_by) " +
                        "VALUES (?, ?, ?, ?)";

                historyPs = con.prepareStatement(historySql);

                historyPs.setInt(1, complaintId);
                historyPs.setString(2, newStatus);

                if (adminResponse != null &&
                    !adminResponse.trim().isEmpty()) {

                    historyPs.setString(3, adminResponse);

                } else {

                    historyPs.setString(
                            3,
                            "Complaint status updated by administrator.");
                }

                historyPs.setInt(4, adminId);

                historyPs.executeUpdate();

                historyPs.close();
                historyPs = null;
            }

            // SEND EMAIL NOTIFICATION
            if (citizenEmail != null &&
                !citizenEmail.trim().isEmpty()) {

                String emailBody =
                        "Dear " + citizenName + ",\n\n"
                        + "Your complaint has been updated in the "
                        + "Public Management System.\n\n"
                        + "Complaint ID: " + complaintId + "\n"
                        + "New Status: " + newStatus + "\n\n";

                if (adminResponse != null &&
                    !adminResponse.trim().isEmpty()) {

                    emailBody +=
                            "Admin Response:\n"
                            + adminResponse
                            + "\n\n";
                }

                emailBody +=
                        "You can log in to the Public Management System "
                        + "to view the complete complaint details.\n\n"
                        + "Regards,\n"
                        + "Public Management System";

                EmailService.sendEmail(
                        citizenEmail,
                        "Complaint Update - Public Management System",
                        emailBody
                );
            }

            response.sendRedirect("admin-complaints.jsp");

        } catch (Exception e) {

            response.setContentType("text/html;charset=UTF-8");

            response.getWriter().println(
                "<html>" +
                "<head>" +
                "<title>Update Error</title>" +
                "</head>" +
                "<body>" +
                "<h2>Complaint Update Error</h2>" +
                "<p>" +
                e.getMessage() +
                "</p>" +
                "<a href='admin-complaints.jsp'>" +
                "Back to Complaints" +
                "</a>" +
                "</body>" +
                "</html>"
            );

        } finally {

            try {
                if (complaintRs != null) {
                    complaintRs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (complaintPs != null) {
                    complaintPs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (updatePs != null) {
                    updatePs.close();
                }
            } catch (Exception ignored) {
            }

            try {
                if (historyPs != null) {
                    historyPs.close();
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
}