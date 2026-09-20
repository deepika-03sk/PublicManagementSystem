package com.publicmanagement;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/submitComplaint")
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 6 * 1024 * 1024
)
public class ComplaintServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // CHECK LOGIN
        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect("index.jsp");
            return;
        }

        // GET LOGGED-IN USER
        int userId =
                (Integer) session.getAttribute("userId");

        String citizenName =
                (String) session.getAttribute("firstName");

        if (citizenName == null || citizenName.trim().isEmpty()) {
            citizenName = "A citizen";
        }

        // GET COMPLAINT DATA
        String title =
                request.getParameter("title");

        String category =
                request.getParameter("category");

        String location =
                request.getParameter("location");

        String priority =
                request.getParameter("priority");

        String description =
                request.getParameter("description");

        // GET ATTACHMENT
        Part attachment =
                request.getPart("attachment");

        String attachmentPath = null;

        // HANDLE ATTACHMENT
        if (attachment != null &&
            attachment.getSize() > 0) {

            String contentType =
                    attachment.getContentType();

            if (contentType == null ||
                !contentType.startsWith("image/")) {

                response.setContentType(
                        "text/html;charset=UTF-8");

                response.getWriter().println(
                    "<h2>⚠️ Invalid File</h2>" +
                    "<p>" +
                    "Please upload an image file only." +
                    "</p>" +
                    "<a href='raise-complaint.jsp'>" +
                    "← Back to Complaint Form" +
                    "</a>"
                );

                return;
            }

            // CREATE UPLOAD DIRECTORY
            String uploadPath =
                    getServletContext()
                    .getRealPath("/uploads");

            Path uploadDirectory =
                    Paths.get(uploadPath);

            if (!Files.exists(uploadDirectory)) {

                Files.createDirectories(
                        uploadDirectory);
            }

            // GET EXTENSION
            String originalName =
                    attachment.getSubmittedFileName();

            String extension = "";

            if (originalName != null) {

                int dotIndex =
                        originalName.lastIndexOf(".");

                if (dotIndex >= 0) {

                    extension =
                            originalName
                            .substring(dotIndex)
                            .toLowerCase();
                }
            }

            // CREATE UNIQUE FILENAME
            String fileName =
                    UUID.randomUUID().toString()
                    + extension;

            Path filePath =
                    uploadDirectory.resolve(
                            fileName);

            // SAVE FILE
            attachment.write(
                    filePath.toString());

            // SAVE PATH FOR DATABASE
            attachmentPath =
                    "uploads/" + fileName;
        }

        // DATABASE
        String sql =
                "INSERT INTO complaints " +
                "(user_id, title, category, description, " +
                "location, priority, status, attachment_path) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'UNDER_VERIFICATION', ?)";

        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");

            Connection con =
                    DBConnection.getConnection();

            // INSERT COMPLAINT
            PreparedStatement ps =
                    con.prepareStatement(
                            sql,
                            Statement.RETURN_GENERATED_KEYS);

            ps.setInt(1, userId);
            ps.setString(2, title);
            ps.setString(3, category);
            ps.setString(4, description);
            ps.setString(5, location);
            ps.setString(6, priority);
            ps.setString(7, attachmentPath);

            ps.executeUpdate();

            // GET GENERATED COMPLAINT ID
            int complaintId = 0;

            try (ResultSet generatedKeys =
                    ps.getGeneratedKeys()) {

                if (generatedKeys.next()) {

                    complaintId =
                            generatedKeys.getInt(1);
                }
            }

            ps.close();

            // ADD INITIAL HISTORY
            if (complaintId > 0) {

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
                        "UNDER_VERIFICATION");

                historyPs.setString(
                        3,
                        "Complaint submitted by citizen and is awaiting verification.");

                historyPs.setInt(
                        4,
                        userId);

                historyPs.executeUpdate();

                historyPs.close();
            }

            // ==========================================
            // NOTIFY ALL ADMINS - IN-APP
            // ==========================================

            if (complaintId > 0) {

                String notificationSql =
                        "INSERT INTO notifications " +
                        "(user_id, complaint_id, message) " +
                        "SELECT id, ?, ? " +
                        "FROM users " +
                        "WHERE role = 'ADMIN'";

                PreparedStatement notificationPs =
                        con.prepareStatement(
                                notificationSql);

                String notificationMessage =
                        "🔔 New Complaint Raised: " +
                        "Complaint #" + complaintId +
                        " was submitted by " +
                        citizenName +
                        ". Category: " +
                        category +
                        ". Location: " +
                        location +
                        ". Status: UNDER VERIFICATION.";

                notificationPs.setInt(
                        1,
                        complaintId);

                notificationPs.setString(
                        2,
                        notificationMessage);

                notificationPs.executeUpdate();

                notificationPs.close();
            }

            // ==========================================
            // EMAIL ALL ADMINS
            // ==========================================

            if (complaintId > 0) {

                String adminEmailSql =
                        "SELECT email, first_name " +
                        "FROM users " +
                        "WHERE role = 'ADMIN' " +
                        "AND email IS NOT NULL " +
                        "AND email <> ''";

                PreparedStatement adminEmailPs =
                        con.prepareStatement(
                                adminEmailSql);

                ResultSet adminEmailRs =
                        adminEmailPs.executeQuery();

                while (adminEmailRs.next()) {

                    String adminEmail =
                            adminEmailRs.getString("email");

                    String adminFirstName =
                            adminEmailRs.getString("first_name");

                    if (adminFirstName == null ||
                        adminFirstName.trim().isEmpty()) {

                        adminFirstName = "Administrator";
                    }

                    String emailSubject =
                            "🔔 New Complaint Raised - Complaint #"
                            + complaintId;

                    String emailBody =
                            "Dear " + adminFirstName + ",\n\n" +

                            "A new complaint has been submitted " +
                            "by a citizen in the Public Management System.\n\n" +

                            "Complaint ID: #" + complaintId + "\n" +
                            "Citizen: " + citizenName + "\n" +
                            "Title: " + title + "\n" +
                            "Category: " + category + "\n" +
                            "Location: " + location + "\n" +
                            "Priority: " + priority + "\n" +
                            "Status: UNDER VERIFICATION\n\n" +

                            "The complaint is waiting for administrator " +
                            "verification and further action.\n\n" +

                            "Please log in to the Public Management System " +
                            "to review the complaint.\n\n" +

                            "Regards,\n" +
                            "Public Management System";

                    // IMPORTANT:
                    // Email failure should NOT make complaint submission fail.
                    try {

                        EmailService.sendEmail(
                                adminEmail,
                                emailSubject,
                                emailBody);

                    } catch (Exception emailError) {

                        emailError.printStackTrace();
                    }
                }

                adminEmailRs.close();
                adminEmailPs.close();
            }

            // CLOSE CONNECTION
            con.close();

            // SUCCESS
            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                "<html>" +
                "<head>" +
                "<title>Complaint Submitted</title>" +
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
                "h1{color:#16a34a;}" +
                "a{" +
                "display:inline-block;" +
                "margin-top:20px;" +
                "padding:12px 20px;" +
                "background:#2563eb;" +
                "color:white;" +
                "text-decoration:none;" +
                "border-radius:8px;" +
                "}" +
                "</style>" +
                "</head>" +
                "<body>" +
                "<div class='box'>" +
                "<h1>✅ Complaint Submitted!</h1>" +
                "<p>" +
                "Your complaint has been successfully " +
                "registered." +
                "</p>" +
                "<p>" +
                "📋 Status: <strong>UNDER VERIFICATION</strong>" +
                "</p>" +
                "<p>" +
                "🔍 Your complaint will be reviewed " +
                "by an administrator before further action." +
                "</p>" +
                "<p>" +
                "📎 Evidence: " +
                (attachmentPath != null
                    ? "<strong>Attached</strong>"
                    : "Not attached") +
                "</p>" +
                "<a href='dashboard.jsp'>" +
                "🏠 Back to Dashboard" +
                "</a>" +
                "</div>" +
                "</body>" +
                "</html>"
            );

        } catch (Exception e) {

            response.setContentType(
                    "text/html;charset=UTF-8");

            response.getWriter().println(
                "<h2>⚠️ Complaint Submission Error</h2>" +
                "<p>" +
                e.getMessage() +
                "</p>" +
                "<a href='raise-complaint.jsp'>" +
                "← Back to Complaint Form" +
                "</a>"
            );
        }
    }
}