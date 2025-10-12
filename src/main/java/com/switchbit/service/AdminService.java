package com.switchbit.service;

import com.switchbit.model.Admin;
import com.switchbit.util.DBConnection;
import com.switchbit.util.PasswordUtil;
import com.switchbit.dao.AdminDAO;
import com.switchbit.exceptions.*;

import java.sql.*;
import java.util.List;

public class AdminService {
	private AdminDAO adminDAO;
	
	public AdminService () {
		adminDAO = new AdminDAO();
	}
	
	public void addAdmin(Admin admin) throws RollBackException, CloseConnectionException, DataAccessException {
		Connection conn = null;
		
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			adminDAO.addAdmin(conn, admin);
			
			conn.commit();
			
		}catch(SQLException e) {
			if (conn!=null) {
				try {
					conn.rollback();
				}catch (SQLException e2) {
					throw new RollBackException ("failed to rollback transaction", e);
				}
			}
			throw new DataAccessException("failed to add admin", e);
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch (SQLException e) {
					throw new CloseConnectionException("failed to close connection", e);
				}
			}
		}
	}
	
	public Admin verifyAdmin(String identifier, String password) throws InvalidUserException, AuthenticationException, DataAccessException {
		try(Connection conn = DBConnection.getConnection();) {

			Admin admin = adminDAO.getAdmin(conn, identifier);
			
			if (admin==null) {
				throw new InvalidUserException("Invalid Admin with identifier: " + identifier);
			}
			
			boolean valid = PasswordUtil.verifyPassword(password, admin.getPassword());
			
			if (valid) {
				admin.setPassword("");
				return admin;
			}else {
				throw new AuthenticationException("Invalid password for admin: " + identifier);
			}
		}catch (SQLException e) {
			throw new DataAccessException("Failed to getAdmin", e);
		}
	}
	
	public List<Admin> getAdmins() throws DataAccessException{
		try (Connection conn = DBConnection.getConnection()){
			return adminDAO.getAdmins(conn);
		}catch (SQLException e) {
			throw new DataAccessException("Failed to getAdmins", e);
		}
	}
	
	
	

}
