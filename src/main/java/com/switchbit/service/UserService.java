package com.switchbit.service;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.SQLIntegrityConstraintViolationException;

import com.switchbit.model.*;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;
import com.switchbit.dao.*;
import com.switchbit.dto.UserWithPassword;

public class UserService {

	private final UserDAO userDAO;

	// Constructor initializes DAO dependencies
	public UserService() {
		this.userDAO = new UserDAO();
	}
	
	public User getUser(String user_id) throws DataAccessException {
		User user = null;
		try(Connection conn = DBConnection.getConnection()){
			user = userDAO.getUser(conn, user_id).getUser();
		} catch (SQLException e) {
			throw new DataAccessException("Failed to getUser", e);
		}
		return user;
	}

	/**
	 * Adds a new user into the system.
	 *
	 * Workflow: 1. Open a DB connection and start a transaction. 2. Generate the
	 * next User ID (by reading current ID and incrementing). 3. Hash the provided
	 * raw password. 4. Populate the User object with the generated ID. 5. Create a
	 * Password entity tied to the User. 6. Insert both User and Password into the
	 * DB using DAO. 7. Update the sequence table to reflect the new ID value. 8.
	 * Commit the transaction (all-or-nothing). 9. Rollback in case of failure,
	 * ensuring no partial changes.
	 *
	 * @param user        The user object without an ID or password hash.
	 * @param rawPassword The plain text password to be hashed and stored.
	 * @return The persisted User with its assigned ID.
	 * @throws DuplicateResourceException
	 */
	public User addUser(User user, String rawPassword) throws DuplicateResourceException,DataAccessException,RollBackException, CloseConnectionException {
		Connection conn = null;

		try {
			// 1. Get connection and start transaction
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false); // begin transaction

			
			// 2. Generate next user ID (based on sequence table, but not updated yet)
			int currentId = IdGeneratorDAO.getCurrentIdVal(conn,"USER");
			String nextId = MiscUtil.idGenerator("USR00000", currentId);

			// 3. Securely hash the password
			String hashedPassword = PasswordUtil.hashPassword(rawPassword);

			// 4. Update the user object with generated ID
			user.setUserId(nextId);

			// 5. Build a Password entity (linked to the user)
			Password password = new Password(user.getUserId(), hashedPassword, user.getReg_date());

			// 6. Insert user and password atomically
			userDAO.addUser(conn, user, password);

			// 7. Now that user insert succeeded, advance the sequence
			IdGeneratorDAO.setNextIdVal(conn, "USER", currentId);

			// 8. Commit transaction (both inserts + sequence update succeed)
			conn.commit();

		} catch (SQLException e) {
			// 9. Rollback if *anything* goes wrong
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					throw new RollBackException("Failed to rollback transaction", ex);
				}
			}

			if (e.getErrorCode() == 1062 || "23000".equals(e.getSQLState())) {
				throw new DuplicateResourceException("Email or Phone already exists", e);
			} else {
				throw new DataAccessException("Failed to add user. Internal Error", e);
			}

		} finally {
			// Always release resources safely
			if (conn != null) {
				try {
					conn.setAutoCommit(true); // restore autocommit
					conn.close();
				} catch (SQLException ex) {
					throw new CloseConnectionException("Failed to clean up connection", ex);
				}
			}
		}

		return user;
	}
	

	/**
	 * Verifies user credentials (identifier + password).
	 * 
	 * Workflow: 1. Fetch user + stored password hash by identifier
	 * (userId/email/phone). 2. Compare raw password with stored hash using
	 * PasswordUtil. 3. If match → return User object. 4. If mismatch → throw
	 * AuthenticationException.
	 *
	 * @param identifier User identifier (email, phone, or userId)
	 * @param password   Raw password entered by user
	 * @return User object if authentication succeeds
	 * @throws AuthenticationException
	 */
	public User verifyUser(String identifier, String password) throws AuthenticationException, InvalidUserException, DataAccessException {

		try {
			Connection conn = DBConnection.getConnection();
			UserWithPassword uwp = userDAO.getUser(conn, identifier);

			if (uwp.getUser() == null) {
				throw new InvalidUserException("Invalid User with identifier: " + identifier);
			}

			boolean valid = PasswordUtil.verifyPassword(password, uwp.getPassword().getPassword());

			if (valid) {
				return uwp.getUser();
			} else {
				throw new AuthenticationException("Invalid password for user: " + identifier);
			}

		} catch (SQLException e) {
			throw new DataAccessException("Failed to getUser", e);
		}

	}

	/**
	 * Updates an existing user's details. Responsibilities: 1. Validate the input
	 * (e.g., non-null fields). 2. Start a transaction. 3. Call DAO to perform the
	 * update. 4. Commit or rollback on failure.
	 *
	 * @param user User object with updated fields (must contain userId).
	 * @return Updated user object (fresh from DB if needed).
	 */
	public User updateUser(User user) throws DuplicateResourceException, DataAccessException, RollBackException, CloseConnectionException {
		User updatedUser = null;
		Connection conn = null;
		try {
			conn = DBConnection.getConnection();

			conn.setAutoCommit(false);

			userDAO.updateUser(conn, user);

			conn.commit();

			updatedUser = userDAO.getUser(conn, user.getUserId()).getUser();

		} catch (SQLException e) {
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException ex) {
					throw new RollBackException("Failed to rollback transaction during user update", ex);
				}
			}

			if (e.getErrorCode() == 1062 || "23000".equals(e.getSQLState())) {
				throw new DuplicateResourceException("Email or Phone already exists", e);
			}
			throw new DataAccessException("Failed to update user", e);
		} finally {
			if (conn != null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				} catch (SQLException e) {
					throw new CloseConnectionException("Failed to cleanup Connection after updateUser", e);
				}
			}
		}
		return updatedUser;
	}
	
	/**
	 * Updates a user's password if the old password is correct.
	 *
	 * @param oldPassword  The user's current (raw) password entered for verification.
	 * @param newPassword  A Password object containing the userId, new hashed password, and updated date.
	 * @throws AuthenticationException if the old password does not match.
	 * @throws DataAccessException if any database error occurs.
	 */
	public void updatePassword(String oldPassword, Password newPassword) throws AuthenticationException, DataAccessException, RollBackException, CloseConnectionException {
	    Connection conn = null;

	    try {
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // 1. Fetch the existing password object for this user
	        Password existingPassword = userDAO
	                .getUser(conn, newPassword.getUser_id())
	                .getPassword();

	        // 2. Verify the old password
	        boolean valid = PasswordUtil.verifyPassword(oldPassword, existingPassword.getPassword());

	        if (valid) {
	        	// Hash the new Password
		    	String newHashedPassword = PasswordUtil.hashPassword(newPassword.getPassword());
		    	newPassword.setPassword(newHashedPassword);
	            // 3. Update password
	            userDAO.updatePassword(conn, newPassword);

	            // 4. Commit transaction
	            conn.commit();
	        } else {
	            throw new AuthenticationException("Invalid current password. Try again.");
	        }

	    } catch (SQLException e) {
	        // Rollback in case of DB error
	        if (conn != null) {
	            try { conn.rollback(); } 
	            catch (SQLException rollbackEx) {
	                throw new RollBackException("Failed to rollback transaction", rollbackEx);
	            }
	        }
	        throw new DataAccessException("Failed to update password", e);

	    } finally {
	        // Always clean up
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true); // restore auto-commit
	                conn.close();
	            } catch (SQLException ex) {
	                throw new CloseConnectionException("Failed to close connection", ex);
	            }
	        }
	    }
	}

	
	

}
