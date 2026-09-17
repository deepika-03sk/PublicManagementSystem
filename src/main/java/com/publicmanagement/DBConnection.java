package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = System.getenv("MYSQL_PUBLIC_URL");

        if (url == null || url.isBlank()) {
            throw new Exception("MYSQL_PUBLIC_URL is missing from Railway.");
        }

        if (url.startsWith("mysql://")) {
            url = "jdbc:" + url;
        }

        if (!url.startsWith("jdbc:")) {
            throw new Exception("Invalid MYSQL_PUBLIC_URL format.");
        }

        System.out.println("Connecting using Railway MYSQL_PUBLIC_URL...");

        return DriverManager.getConnection(url);
    }
}