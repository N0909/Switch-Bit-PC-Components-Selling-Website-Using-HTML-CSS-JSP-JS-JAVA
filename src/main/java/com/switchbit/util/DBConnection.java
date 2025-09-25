package com.switchbit.util;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.sql.*;

public class DBConnection {
	private static String url;
	private static String user;
	private static String password;
	
	
//	static {
//		try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")){
//			Properties properties = new Properties();
//			
//			properties.load(input);
//			
//			url = properties.getProperty("db.url");
//			user = properties.getProperty("db.username");
//			password = properties.getProperty("db.password");
//			Class.forName("com.mysql.cj.jdbc.Driver");
//		}catch(Exception e) {
//			throw new RuntimeException("Failed to Load DB config",e);
//		}
//	}
	
	    static {
	        try {
	            // Read Railway internal env variables
	            String host = System.getenv("MYSQLHOST");
	            String port = System.getenv("MYSQLPORT");
	            String database = System.getenv("MYSQLDATABASE");
	            user = System.getenv("MYSQLUSER");
	            password = System.getenv("MYSQLROOTPASSWORD");

	            // Build JDBC URL
	            url = String.format("jdbc:mysql://%s:%s/%s?useSSL=false&serverTimezone=UTC", host, port, database);
	            
	            // Load MySQL driver
	            Class.forName("com.mysql.cj.jdbc.Driver");
	        } catch (Exception e) {
	            throw new RuntimeException("Failed to load DB config", e);
	        }
	    }
	    

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, user, password);
	}
}
