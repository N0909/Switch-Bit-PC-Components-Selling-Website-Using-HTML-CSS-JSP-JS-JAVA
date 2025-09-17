package com.switchbit.dao;

// Importing classes from model and utils
import com.switchbit.model.*;
import com.switchbit.dto.UserWithPassword;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.DuplicateResourceException;
import com.switchbit.util.*;

import java.sql.*;

// This Class is responsible for Handling Users
public class UserDAO {

	/**
	 * DAO method to add a new User and their Password entry into the database.
	 * Executes two stored procedures (addUser, addPassword) in a single
	 * transaction.
	 */
	public void addUser(Connection conn, User user, Password password) throws SQLException {
		try(CallableStatement callableUser = conn.prepareCall("{call addUser(?, ?, ?, ?, ?, ?, ?, ?)}");){
			

			// Set parameters for addUser procedure
			callableUser.setString(1, user.getUserId());
			callableUser.setString(2, user.getUserName());
			callableUser.setString(3, user.getUserEmail());
			callableUser.setString(4, user.getUserPhone());
			callableUser.setString(5, user.getUserAddress());
			callableUser.setTimestamp(6, user.getReg_date());
			callableUser.setString(7, password.getPassword());
			callableUser.setTimestamp(8, password.getLast_updated());

			// Execute stored procedures
			callableUser.execute();
		}
	}

	/**
	 * Fetches a User record based on a single identifier.
	 * The identifier can be a phone number (all digits), an email (contains '@'),
	 * or a user ID (fallback if it's neither phone nor email).
	 *
	 * Stored Procedures Used:
	 *   - getUserByPhone
	 *   - getUserByEmail
	 *   - getUserByUserId
	 *
	 * @param conn current connection,identifier The user's phone, email, or ID.
	 * @throws SQLException
	 * @return UserWithPassword object.
	 */
	public UserWithPassword getUser(Connection conn,String identifier) throws SQLException{
	    User user = null;
	    Password password = null;

	        CallableStatement callableUser;

	        // 1️ Detect if the input is a phone number (all digits)
	        if (identifier.matches("\\d+")) {
	            callableUser = conn.prepareCall("{call getUserByPhone(?)}");
	            callableUser.setString(1, identifier);

	        // 2️ Detect if the input is an email (contains '@')
	        } else if (identifier.contains("@")) {
	            callableUser = conn.prepareCall("{call getUserByEmail(?)}");
	            callableUser.setString(1, identifier);

	        // 3️ Otherwise, treat it as a user ID
	        } else {
	            callableUser = conn.prepareCall("{call getUserById(?)}");
	            callableUser.setString(1, identifier);
	        }

	        // Execute the procedure and map the result set
	        ResultSet rs = callableUser.executeQuery();
	         if (rs.next()) {
	                user = new User(
	                        rs.getString("user_id"),
	                        rs.getString("name"),
	                        rs.getString("email"),
	                        rs.getString("phone"),
	                        rs.getString("address"),
	                        rs.getTimestamp("reg_date")
	                );
	                password = new Password(
	                		rs.getString("user_id"),
	                		rs.getString("password_hash"),
	                		rs.getTimestamp("last_updated")
	                );
	            }
	    return new UserWithPassword(user, password);
	}

	/**
	 * Update a user record based on user object
	 * 
	 * Store Procedure Used updateUser
	 * 
	 * @param user, conn Connection
	 * @return void
	 * @throws SQLException
	 */
	public void updateUser(Connection conn, User user) throws SQLException {
		
		try(CallableStatement updateuser = conn.prepareCall("{call updateUser(?, ?, ?, ?, ?)}");){
			
			// Setting UpdateUser Procedure parameters
			updateuser.setString(1, user.getUserId());
			updateuser.setString(2, user.getUserName());
			updateuser.setString(3, user.getUserEmail());
			updateuser.setString(4, user.getUserPhone());
			updateuser.setString(5, user.getUserAddress());

			// Executing Procedure
			updateuser.execute();
		}
	}
	
	/**
	 * update the user password
	 * 
	 * @param conn - Database Connection
	 * @param password - password object 
	 * @throws SQLException
	 */
	public void updatePassword(Connection conn, Password password) throws SQLException {
		try(CallableStatement updatePassword =  conn.prepareCall("{call updatePassword (?, ?, ?)}");){
			
			// Setting updatePassword procedure parameters
			updatePassword.setString(1, password.getUser_id());		
			updatePassword.setString(2, password.getPassword());
			updatePassword.setTimestamp(3, password.getLast_updated());
		
		
			// Executing Procedure
			updatePassword.execute();
		}
	}
	
	

}
