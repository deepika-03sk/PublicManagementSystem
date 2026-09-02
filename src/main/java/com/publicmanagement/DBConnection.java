package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String mysqlUrl = System.getenv("MYSQL_URL");

        if (mysqlUrl == null || mysqlUrl.isEmpty()) {
            throw new Exception("MYSQL_URL is not set in Railway.");
        }

        // Railway gives mysql://
        // JDBC requires jdbc:mysql://
        String jdbcUrl = mysqlUrl.replaceFirst("^mysql://", "jdbc:mysql://");

        return DriverManager.getConnection(jdbcUrl);
    }
}