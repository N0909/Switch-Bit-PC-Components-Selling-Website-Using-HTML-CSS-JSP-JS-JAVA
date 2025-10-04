package com.switchbit.dao;

import com.switchbit.model.Admin;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AdminDAO {
	
	public Admin getAdmin(Connection conn, String admin_identifier) throws SQLException {
		Admin admin = null;
		CallableStatement cs = null;
		
		if (admin_identifier.matches("\\d+")) {
			cs = conn.prepareCall("call getAdminById(?)");
			cs.setInt(1, Integer.parseInt(admin_identifier));
		}else if (admin_identifier.contains("@")) {
			cs = conn.prepareCall("call getAdminByEmail(?)");
			cs.setString(1, admin_identifier);
		}else {
			cs = conn.prepareCall("call getAdminByUserName(?)");
			cs.setString(1, admin_identifier);
		}
		
		try (ResultSet rs = cs.executeQuery()){
			if (rs.next()) {
				
			admin = new Admin(
						rs.getInt("admin_id"),
						rs.getString("admin_username"),
						rs.getString("password_hash"),
						rs.getString("email"),
						rs.getTimestamp("created_at")
					);
			}
		}
		return admin;
	}
	
	public void addAdmin(Connection conn, Admin admin) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("call addAdmin(?, ?, ?, ?)")){
			cs.setString(1, admin.getAdmin_username());
			cs.setString(2, admin.getPassword());
			cs.setString(3, admin.getEmail());
			cs.setTimestamp(4, admin.getCreated_at());
			
			cs.executeUpdate();
		}
	}
	
	public List<Admin> getAdmins(Connection conn) throws SQLException {
		List<Admin> admins = new ArrayList<Admin>();
		try (Statement stmt = conn.createStatement();){
			try (ResultSet rs = stmt.executeQuery("SELECT admin_id,admin_username,email,created_at FROM admin");){
				while (rs.next()) {
					Admin admin = new Admin();
					admin.setAdmin_id(rs.getInt("admin_id"));
					admin.setAdmin_username(rs.getString("admin_username"));
					admin.setEmail(rs.getString("email"));
					admin.setCreated_at(rs.getTimestamp("created_at"));
					
					admins.add(admin);
				}
			}
		}
		return admins;
	}
	
}
