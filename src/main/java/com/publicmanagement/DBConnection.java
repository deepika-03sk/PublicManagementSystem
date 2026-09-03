package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        Class.forName("com.mysql.cj.jdbc.Driver");

        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        if (host == null || port == null || database == null
                || user == null || password == null) {

            throw new Exception(
                "DATABASE VARIABLES MISSING: " +
                "HOST=" + host +
                ", PORT=" + port +
                ", DATABASE=" + database +
                ", USER=" + user
            );
        }

        String url =
                "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false"
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC"
                + "&connectTimeout=10000"
                + "&socketTimeout=10000";

        System.out.println("========== DATABASE CONNECTION TEST ==========");
        System.out.println("MYSQLHOST = " + host);
        System.out.println("MYSQLPORT = " + port);
        System.out.println("MYSQLDATABASE = " + database);
        System.out.println("MYSQLUSER = " + user);
        System.out.println("MYSQLPASSWORD = [HIDDEN]");
        System.out.println("JDBC URL = " + url);

        try {

            Connection connection =
                    DriverManager.getConnection(url, user, password);

            System.out.println("========== DATABASE CONNECTION SUCCESS ==========");

            return connection;

        } catch (SQLException e) {

            System.err.println("========== DATABASE CONNECTION FAILED ==========");
            System.err.println("SQL State: " + e.getSQLState());
            System.err.println("Error Code: " + e.getErrorCode());
            System.err.println("Message: " + e.getMessage());

            e.printStackTrace();

            throw e;
        }
    }
}