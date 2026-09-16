package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String mysqlUrl = System.getenv("MYSQL_URL");

        if (mysqlUrl == null || mysqlUrl.isBlank()) {
            throw new Exception("MYSQL_URL is missing from Railway.");
        }

        // Railway provides mysql://...
        // JDBC requires jdbc:mysql://...
        String jdbcUrl = mysqlUrl.startsWith("jdbc:")
                ? mysqlUrl
                : "jdbc:" + mysqlUrl;

        System.out.println("Connecting using Railway MYSQL_URL...");

        return DriverManager.getConnection(jdbcUrl);
    }
}