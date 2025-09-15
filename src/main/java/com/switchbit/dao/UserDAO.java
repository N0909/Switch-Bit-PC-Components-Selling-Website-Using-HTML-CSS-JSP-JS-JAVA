package com.switchbit.dao;
// Importing classes from model and utils
import com.switchbit.model.*;
import com.switchbit.util.*;

import java.sql.*;

// This Class is responsible for Handling Users
public class UserDAO {
	
	/**
	 * DAO method to add a new User and their Password entry into the database.
	 * Executes two stored procedures (addUser, addPassword) in a single transaction.
	 */
	public void addUser(User user, Password password) {
	    // Use try-with-resources to auto-close DB connection
	    try (Connection conn = DBConnection.getConnection();
	         CallableStatement callableUser = conn.prepareCall("{call addUser(?, ?, ?, ?, ?, ?)}");
	         CallableStatement callablePassword = conn.prepareCall("{call addPassword(?, ?, ?)}")) {

	        // Start transaction
	        conn.setAutoCommit(false);

	        // Set parameters for addUser procedure
	        callableUser.setString(1, user.getUserId());
	        callableUser.setString(2, user.getUserName());
	        callableUser.setString(3, user.getUserEmail());
	        callableUser.setString(4, user.getUserPhone());
	        callableUser.setString(5, user.getUserAddress());
	        callableUser.setTimestamp(6, user.getReg_date());

	        // Set parameters for addPassword procedure
	        callablePassword.setString(1, password.getUser_id());
	        callablePassword.setString(2, PasswordUtil.hashPassword(password.getPassword()));
	        callablePassword.setTimestamp(3, password.getLast_updated());

	        // Execute stored procedures
	        callableUser.execute();
	        callablePassword.execute();

	        // Commit transaction if both succeed
	        conn.commit();

	    } catch (SQLException e) {
	        // Log error
	        System.err.println("Error adding user: " + e.getMessage());
	        e.printStackTrace();
	        try {
	            // Attempt rollback if something failed
	            Connection conn = DBConnection.getConnection();
	            conn.rollback();
	        } catch (SQLException rollbackEx) {
	            System.err.println("Failed to rollback transaction: " + rollbackEx.getMessage());
	        }
	    }
	}

}
