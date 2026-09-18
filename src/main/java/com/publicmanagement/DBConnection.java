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
            throw new Exception("Railway MySQL variables are missing.");
        }

        String url = "jdbc:mysql://" + host + ":" + port + "/" + database
        	
                + "&serverTimezone=UTC"
                + "&connectTimeout=15000"
                + "&socketTimeout=15000";

        return DriverManager.getConnection(url, user, password);
    }
}