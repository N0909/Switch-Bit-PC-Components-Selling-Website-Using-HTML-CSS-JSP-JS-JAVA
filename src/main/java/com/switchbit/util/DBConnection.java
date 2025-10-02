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
			Class.forName("com.mysql.cj.jdbc.Driver");
		}catch(Exception e) {
			throw new RuntimeException("Failed to Load DB config",e);
		}
	}
	
//	static {
//        try {
//            user = "root";
//            password = "WMfTPESucAPwQEXJSyNlWaxzPSzXNbXa";
//
//            // Build JDBC URL
//            url = "jdbc:"+"mysql://root:WMfTPESucAPwQEXJSyNlWaxzPSzXNbXa@gondola.proxy.rlwy.net:59615/SwitchBitDB"+"?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
//            
//            // Load MySQL driver
//            Class.forName("com.mysql.cj.jdbc.Driver");
//        } catch (Exception e) {
//            throw new RuntimeException("Failed to load DB config", e);
//        }
//    }
	    

	public static Connection getConnection() throws SQLException {
		return DriverManager.getConnection(url, user, password);
	}
}
