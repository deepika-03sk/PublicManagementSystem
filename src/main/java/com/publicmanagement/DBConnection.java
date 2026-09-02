package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        System.out.println("=== DATABASE TEST ===");
        System.out.println("MYSQLHOST: " + host);
        System.out.println("MYSQLPORT: " + port);
        System.out.println("MYSQLDATABASE: " + database);
        System.out.println("MYSQLUSER: " + user);
        System.out.println("PASSWORD EXISTS: " + (password != null));

        if (host == null || port == null || database == null
                || user == null || password == null) {
            throw new Exception("MYSQL variables are missing");
        }

        Class.forName("com.mysql.cj.jdbc.Driver");

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false"
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC"
                + "&connectTimeout=10000"
                + "&socketTimeout=10000";

        System.out.println("Connecting to Railway MySQL...");

        return DriverManager.getConnection(url, user, password);
    }
}