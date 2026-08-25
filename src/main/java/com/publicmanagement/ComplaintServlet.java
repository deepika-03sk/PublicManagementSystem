package com.publicmanagement;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.sql.Connection;
import java.sql.DriverManager;
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
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME;
    


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
        // GET LOGGED-IN USER
        // =====================================

        int userId =
                (Integer) session.getAttribute("userId");


        // =====================================
        // GET COMPLAINT DATA
        // =====================================

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


        // =====================================
        // GET ATTACHMENT
        // =====================================

        Part attachment =
                request.getPart("attachment");

        String attachmentPath = null;


        // =====================================
        // HANDLE ATTACHMENT
        // =====================================

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


            // Create upload directory

            String uploadPath =
                    getServletContext()
                    .getRealPath("/uploads");


            Path uploadDirectory =
                    Paths.get(uploadPath);


            if (!Files.exists(uploadDirectory)) {

                Files.createDirectories(
                        uploadDirectory);
            }


            // Get extension

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


            // Create unique filename

            String fileName =
                    UUID.randomUUID().toString()
                    + extension;


            Path filePath =
                    uploadDirectory.resolve(
                            fileName);


            // Save file

            attachment.write(
                    filePath.toString());


            // Save path for database

            attachmentPath =
                    "uploads/" + fileName;
        }


        // =====================================
        // DATABASE
        // =====================================

        String sql =
                "INSERT INTO complaints " +
                "(user_id, title, category, description, " +
                "location, priority, status, attachment_path) " +
                "VALUES (?, ?, ?, ?, ?, ?, 'PENDING', ?)";


        try {

            Class.forName(
                    "com.mysql.cj.jdbc.Driver");


            Connection con =
                    DriverManager.getConnection(
                            DB_URL,
                            DB_USER,
                            DB_PASSWORD);


            // =================================
            // INSERT COMPLAINT
            // =================================

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


            // =================================
            // GET GENERATED COMPLAINT ID
            // =================================

            int complaintId = 0;


            try (ResultSet generatedKeys =
                    ps.getGeneratedKeys()) {

                if (generatedKeys.next()) {

                    complaintId =
                            generatedKeys.getInt(1);
                }
            }


            ps.close();


            // =================================
            // ADD INITIAL HISTORY
            // =================================

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
                        "PENDING");

                historyPs.setString(
                        3,
                        "Complaint submitted by citizen.");

                historyPs.setInt(
                        4,
                        userId);


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
                "📋 Status: <strong>PENDING</strong>" +
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