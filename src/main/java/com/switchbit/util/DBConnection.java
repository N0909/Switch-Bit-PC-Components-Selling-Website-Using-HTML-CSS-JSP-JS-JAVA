package com.switchbit.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.sql.*;

/**
 * DBConnection Utility Class
 * 
 * This class is responsible for:
 * - Loading database configuration from db.properties
 * - Registering the MySQL JDBC Driver
 * - Providing a reusable method to obtain database connections
 * 
 * It follows a static initialization block approach so that configuration is 
 * loaded only once when the class is first accessed.
 */
public class DBConnection {
    
    // Database connection details loaded from properties file
    private static String url;       // Database URL
    private static String user;      // Database Username
    private static String password;  // Database Password
    
    // Static initialization block runs once when the class is loaded
    static {
        try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")) {
            
            // Load properties from db.properties file
            Properties properties = new Properties();
            properties.load(input);
            
            // Assign values from properties file
            url = properties.getProperty("db.url");
            user = properties.getProperty("db.username");
            password = properties.getProperty("db.password");
            
            // Register JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            
        } catch (Exception e) {
            // Throw runtime exception if any step fails
            throw new RuntimeException("Failed to load DB config", e);
        }
    }
    
    /**
     * Provides a connection to the database using values loaded from db.properties.
     * 
     * @return Connection object
     * @throws SQLException if a database access error occurs
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(url, user, password);
    }
}


