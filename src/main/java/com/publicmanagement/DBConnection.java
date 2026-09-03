package com.publicmanagement;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    public static Connection getConnection() throws Exception {

        System.out.println("========== DATABASE TEST ==========");

        Class.forName("com.mysql.cj.jdbc.Driver");

        String host = System.getenv("MYSQLHOST");
        String port = System.getenv("MYSQLPORT");
        String database = System.getenv("MYSQLDATABASE");
        String user = System.getenv("MYSQLUSER");
        String password = System.getenv("MYSQLPASSWORD");

        System.out.println("MYSQLHOST = " + host);
        System.out.println("MYSQLPORT = " + port);
        System.out.println("MYSQLDATABASE = " + database);
        System.out.println("MYSQLUSER = " + user);
        System.out.println("MYSQLPASSWORD exists = " + (password != null));

        if (host == null || port == null || database == null
                || user == null || password == null) {

            throw new Exception("One or more Railway MySQL variables are missing.");
        }

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
                + "?useSSL=false"
                + "&allowPublicKeyRetrieval=true"
                + "&serverTimezone=UTC"
                + "&connectTimeout=10000"
                + "&socketTimeout=10000";

        System.out.println("MYSQL JDBC URL = jdbc:mysql://" + host + ":" + port + "/" + database);

        System.out.println("Trying database connection...");

        Connection connection = DriverManager.getConnection(
                url,
                user,
                password
        );

        System.out.println("========== DATABASE CONNECTION SUCCESS ==========");

        return connection;
    }
}