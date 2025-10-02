package com.switchbit.service;

import com.switchbit.model.*;
import com.switchbit.util.*;
import com.switchbit.dao.*;
import com.switchbit.exceptions.*;


import java.sql.*;
import java.util.List;

public class PaymentService {
	private PaymentDAO paymentDAO;
	private OrderDAO orderDAO;
	
	public PaymentService() {
		paymentDAO = new PaymentDAO();
		orderDAO = new OrderDAO();
	}
	
	/**
	 * Adds a new payment into the system.
	 * 
	 * Steps:
	 * 1. Get DB connection and start transaction.
	 * 2. Generate a unique payment ID using IdGenerator.
	 * 3. Insert the payment record into the database via DAO.
	 * 4. Update the IdGenerator for the next payment.
	 * 5. Commit the transaction if successful.
	 * 6. Rollback if any error occurs and throw custom exceptions.
	 * @throws DuplicateResourceException 
	 */
	public void addPayment(Payment payment) throws RollBackException, DataAccessException, CloseConnectionException, DuplicateResourceException {
	    Connection conn = null;
	    try {
	        // Establish DB connection and disable auto-commit (begin transaction)
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // Generate payment ID (fetch current value, then format using prefix)
	        int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "payment");
	        String payment_id = MiscUtil.idGenerator("P0000", current_val);
	        payment.setPaymentId(payment_id);
	        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));

	        // Insert payment record into DB using DAO
	        paymentDAO.addPayment(conn, payment);

	        // Update ID generator for future payments
	        IdGeneratorDAO.setNextIdVal(conn, "payment", current_val);

	        // Commit transaction if everything is successful
	        conn.commit();
	    } catch (SQLException e) {
	        // On error → rollback transaction
	        if (conn != null) {
	            try {
	                conn.rollback();
	                if (e.getErrorCode()==1062) {
	                	throw new DuplicateResourceException("payment already done for this order",e);
	                }
	            } catch (SQLException e1) {
	                // If rollback also fails, throw custom RollBackException
	                throw new RollBackException("Failed to rollback transaction", e1);
	            }
	        }
	        // Wrap and rethrow as a custom DataAccessException
	        throw new DataAccessException("Failed to add payment", e);
	    } finally {
	        // Always close resources in finally
	        if (conn != null) {
	            try {
	                // Reset auto-commit to true and close connection
	                conn.setAutoCommit(true);
	                conn.close();
	            } catch (SQLException e) {
	                // If closing fails, throw custom CloseConnectionException
	                throw new CloseConnectionException("Failed to close connection", e);
	            }
	        }
	    }
	}
	
	public List<Payment> getPaymentsByUser(User user) throws DataAccessException, CloseConnectionException {
	    Connection conn = null;
	    try {
	        // Get DB connection
	        conn = DBConnection.getConnection();

	        // Call DAO method to fetch payments by user
	        return paymentDAO.getPaymentsByUser(conn, user);

	    } catch (SQLException e) {
	        // Wrap and rethrow as custom exception
	        throw new DataAccessException("Failed to fetch payments for user: " + user.getUserId(), e);
	    } finally {
	        // Close connection safely
	        if (conn != null) {
	            try {
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to close connection", e);
	            }
	        }
	    }
	}
	
	public List<Payment> getPayments() throws DataAccessException, CloseConnectionException {
	    Connection conn = null;
	    try {
	        // Get DB connection
	        conn = DBConnection.getConnection();

	        // Call DAO method to fetch all payments
	        return paymentDAO.getPayments(conn);

	    } catch (SQLException e) {
	        // Wrap and rethrow as custom exception
	        throw new DataAccessException("Failed to fetch payments", e);
	    } finally {
	        // Always close connection
	        if (conn != null) {
	            try {
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to close connection", e);
	            }
	        }
	    }
	}
	
	public Payment getPayment(String paymentId) throws DataAccessException, CloseConnectionException {
	    Connection conn = null;
	    try {
	        // Get DB connection
	        conn = DBConnection.getConnection();

	        // Call DAO method to fetch the payment by ID
	        return paymentDAO.getPayment(conn, paymentId);

	    } catch (SQLException e) {
	        // Wrap and rethrow as custom exception
	        throw new DataAccessException("Failed to fetch payment with ID: " + paymentId, e);
	    } finally {
	        // Always close connection
	        if (conn != null) {
	            try {
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to close connection", e);
	            }
	        }
	    }
	}
	
	public void updateStockAfterPayment(String order_id) throws RollBackException, DataAccessException, CloseConnectionException {
		Connection conn = null;
		
		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			paymentDAO.updateStockAfterPayment(conn, order_id);
			
			conn.commit();
		}catch(SQLException e) {
			if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException e1) {
	                throw new RollBackException("failed to rollback transaction");
	            }
	            throw new DataAccessException("failed to update Stock"+e.getMessage());
	        }
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch(SQLException e) {
					throw new CloseConnectionException("failed to close connection");
				}
			}
		}
	}
	
	public void processPayment(Payment payment) throws CloseConnectionException, RollBackException, DataAccessException, DuplicateResourceException {
		Connection conn = null;
		try {
			// Establish DB connection and disable auto-commit (begin transaction)
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);
			
			// Generate payment ID (fetch current value, then format using prefix)
			int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "payment");
	        String payment_id = MiscUtil.idGenerator("P0000", current_val);
	        
	        // Setting payment id and payment date
	        payment.setPaymentId(payment_id);
	        payment.setPaymentDate(new Timestamp(System.currentTimeMillis()));
	        
	        // adding payment in database
	        paymentDAO.addPayment(conn, payment);
	        
	        // updating order status to paid and delivery date of current payment date + 10 days 
	        orderDAO.updateOrderStatus(conn, payment.getOrderId(), "PAID");
	        orderDAO.updateDeliveryDate(conn, payment.getOrderId() , new Date(System.currentTimeMillis()+(10 * 24 * 60 * 60 * 1000)));
	        // updating products stock in database
	        paymentDAO.updateStockAfterPayment(conn, payment.getOrderId());
	        	
	        
	        // Update ID generator for future payments
	        IdGeneratorDAO.setNextIdVal(conn, "payment", current_val);
	        
	        // Commiting transaction
	        conn.commit();
			
			
		}catch(SQLException e) {
			if (conn!=null) {
				try {
					// rollback if something fail
					conn.rollback();
				}catch (SQLException e2) {
					throw new RollBackException("failed to rollback transaction");
				}
				if (e.getErrorCode()==1062) {
                	throw new DuplicateResourceException("payment already done for this order");
                }
				throw new DataAccessException("failed to process payment");
			}
		}finally {
			if (conn!=null) {
				try {
					conn.setAutoCommit(true);
					conn.close();
				}catch(SQLException e) {
					throw new CloseConnectionException("failed to close connection");
				}
			}
		}
	}

}
