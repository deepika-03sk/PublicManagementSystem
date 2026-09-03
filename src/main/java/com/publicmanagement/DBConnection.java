package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

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
                "Railway MySQL variables are missing."
            );
        }

        String url =
            "jdbc:mysql://" + host + ":" + port + "/" + database
            + "?useSSL=false"
            + "&allowPublicKeyRetrieval=true"
            + "&serverTimezone=UTC"
            + "&connectTimeout=10000"
            + "&socketTimeout=10000";

        System.out.println("========== DATABASE TEST ==========");
        System.out.println("MYSQLHOST = " + host);
        System.out.println("MYSQLPORT = " + port);
        System.out.println("MYSQLDATABASE = " + database);
        System.out.println("MYSQLUSER = " + user);
        System.out.println("Attempting database connection...");
        System.out.println("===================================");

        try {

            Connection con =
                DriverManager.getConnection(
                    url,
                    user,
                    password
                );

            System.out.println("========== DATABASE TEST ==========");
            System.out.println("DATABASE CONNECTION: SUCCESS");
            System.out.println("===================================");

            return con;

        } catch (Exception e) {

            System.out.println("========== DATABASE TEST ==========");
            System.out.println("DATABASE CONNECTION: FAILED");
            System.out.println("ERROR TYPE = "
                + e.getClass().getName());
            System.out.println("ERROR = "
                + e.getMessage());
            System.out.println("===================================");

            throw e;
        }
    }
}