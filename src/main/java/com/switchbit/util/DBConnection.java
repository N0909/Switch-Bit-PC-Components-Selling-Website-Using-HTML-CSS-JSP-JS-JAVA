package com.switchbit.util;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;
import java.sql.*;

public class DBConnection {
	private static String url;
	private static String user;
	private static String password;
	
	
	static {
		try (InputStream input = DBConnection.class.getClassLoader().getResourceAsStream("db.properties")){
			Properties properties = new Properties();
			
			properties.load(input);
			
			url = properties.getProperty("db.url");
			user = properties.getProperty("db.username");
			password = properties.getProperty("db.password");
			
			url = url.replace("${DB_URL}", System.getenv("DB_URL"));
		    user = user.replace("${DB_USER}", System.getenv("DB_USER"));
		    password = password.replace("${DB_PASSWORD}", System.getenv("DB_PASSWORD"));
			
			Class.forName("com.mysql.cj.jdbc.Driver");
		}catch(Exception e) {
			throw new RuntimeException("Failed to Load DB config",e);
		}
	}
	
	    

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, user, password);
	}
}
