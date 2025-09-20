package com.switchbit.service;

import java.sql.*;
import java.util.ArrayList;
import com.switchbit.dao.CartDAO;
import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.util.*;

public class CartService {
	private CartDAO dao;

	public CartService() {
		this.dao = new CartDAO();
	}

	/**
	 * Retrieves the cart for a given user.
	 *
	 * @param user the user whose cart needs to be fetched
	 * @return the Cart object associated with the user
	 * @throws NoCartFoundException if the user is null or no cart exists for the
	 *                              user
	 * @throws DataAccessException  if a database access error occurs
	 */
	public Cart getCart(User user) throws DataAccessException, NoCartFoundException {
		// Validate input first (avoid DB call if user is null)
		if (user == null) {
			throw new NoCartFoundException("No cart available for a null user");
		}

		try (Connection conn = DBConnection.getConnection()) {
			// Fetch the cart from DAO
			Cart cart = dao.getCart(conn, user);

			if (cart == null) {
				throw new NoCartFoundException("No cart found for user: " + user.getUserId());
			}

			return cart;
		} catch (SQLException e) {
			// Wrap SQL exception in a custom exception with context
			throw new DataAccessException("Failed to fetch cart for user: " + user.getUserId(), e);
		}
	}

	/**
	 * Adds a new item to the user's cart. If the cart does not exist, a new cart ID
	 * is generated and assigned.
	 *
	 * This method handles transactions manually: - Starts a transaction (disables
	 * auto-commit) - Creates a new cart if necessary - Inserts the cart item into
	 * the database - Advances the sequence for cart IDs - Commits the transaction
	 * 
	 * On failure, the transaction is rolled back safely.
	 *
	 * @param cart     existing cart (nullable — if null, a new cart ID will be
	 *                 generated)
	 * @param cartItem the item to be added to the cart
	 * @throws RollBackException        if rollback fails after an error
	 * @throws DataAccessException      if insertion fails
	 * @throws CloseConnectionException if closing the connection fails
	 */
	public Cart addCartitem(Cart cart, CartItem cartItem)
			throws RollBackException, DataAccessException, CloseConnectionException {

		Connection conn = null;
		int currentId = -1;
		int item_currentId = -1;

		try {
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false); // Begin transaction

			// If no cart exists, create one
			if (cart == null || cart.getCart_id() == null) {
				if (cart == null) {
					cart = new Cart(); // create a new cart object
				}
				currentId = IdGeneratorDAO.getCurrentIdVal(conn, "cart");
				String cartId = MiscUtil.idGenerator("CART0000", currentId);
				cart.setCart_id(cartId);
				dao.addCart(conn, cart); // persist new cart in DB
			}

			item_currentId = IdGeneratorDAO.getCurrentIdVal(conn, "cart_items");
			String cartItemId = MiscUtil.idGenerator("CI0000", item_currentId);
			// Attach the cart to the cartItem
			cartItem.setCart(cart);
			cartItem.setCart_item_id(cartItemId);
			System.out.println(cart);
			// Insert cart item into DB
			dao.addCartItem(conn, cartItem);

			// Advance the cart sequence only if a new cart was generated
			if (currentId != -1) {
				IdGeneratorDAO.setNextIdVal(conn, "cart", currentId);
				IdGeneratorDAO.setNextIdVal(conn, "cart_items", item_currentId);
			}

			conn.commit(); // Commit transaction
			
			return cart;
			
		} catch (SQLException e) {
			// Rollback in case of error
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException e2) {
					throw new RollBackException("Failed to rollback transaction", e2);
				}
			}
			throw new DataAccessException("Failed to add cart item", e);

		} finally {
			// Cleanup connection safely
			if (conn != null) {
				try {
					conn.setAutoCommit(true); // Restore default mode
					conn.close();
				} catch (SQLException e) {
					throw new CloseConnectionException("Failed to close connection", e);
				}
			}
		}
	}
	
	/**
	 * Updates the quantity of a given {@link CartItem} in the user's cart.
	 * This method explicitly manages the transaction:
	 * - Starts a manual transaction (auto-commit disabled)
	 * - Calls the DAO to update the item quantity
	 * - Commits the transaction on success
	 * - Rolls back in case of failure
	 *
	 * @param cartItem The {@link CartItem} containing the updated quantity and product reference
	 * @return {@code true} if the quantity was successfully updated,
	 *         {@code false} if no rows were affected (item not found or unchanged)
	 * @throws DataAccessException       If a database access error occurs
	 * @throws RollBackException         If rolling back the transaction fails after an error
	 * @throws CloseConnectionException  If closing or cleaning up the database connection fails
	 */
	public boolean updateCartItemQuantity(CartItem cartItem) 
	        throws DataAccessException, RollBackException, CloseConnectionException {

	    Connection conn = null;

	    try {
	        // Establish connection and begin transaction
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // Perform the update via DAO
	        int rowsAffected = dao.updateCartItemQuantity(conn, cartItem);

	        // If no row was updated, rollback and return false
	        if (rowsAffected <= 0) {
	            conn.rollback();
	            return false;
	        }

	        // Commit the transaction if update was successful
	        conn.commit();
	        return true;

	    } catch (SQLException e) {
	        // Rollback in case of SQL exception
	        if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException e2) {
	                throw new RollBackException("Failed to rollback transaction", e2);
	            }
	        }
	        throw new DataAccessException("Failed to update cart item quantity", e);

	    } finally {
	        // Always restore connection state and close
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true); // Restore default auto-commit
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to cleanup resources", e);
	            }
	        }
	    }
	}

	
	
	/**
	 * Deletes a given {@link CartItem} from the user's cart.
	 * This method handles the database transaction explicitly:
	 * - Begins a transaction by disabling auto-commit
	 * - Delegates the deletion operation to the DAO layer
	 * - Commits if successful, otherwise rolls back on failure
	 *
	 * @param cartItem The {@link CartItem} to be removed from the cart
	 * @return {@code true} if the item was deleted successfully, {@code false} if no rows were affected
	 * @throws DataAccessException       If a database error occurs during deletion
	 * @throws RollBackException         If the transaction rollback fails after an error
	 * @throws CloseConnectionException  If closing or cleaning up the database connection fails
	 */
	public boolean deleteCartItem(CartItem cartItem) 
	        throws DataAccessException, RollBackException, CloseConnectionException {

	    Connection conn = null;

	    try {
	        // Establish a database connection
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false); // Start transaction manually

	        // Perform the delete operation through DAO
	        int rowsAffected = dao.deleteCartItem(conn, cartItem);

	        // If nothing was deleted, rollback and return false
	        if (rowsAffected <= 0) {
	            conn.rollback();
	            return false;
	        }

	        // Commit transaction if delete successful
	        conn.commit();
	        return true;

	    } catch (SQLException e) {
	        // Rollback in case of any SQL exception
	        if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException e2) {
	                throw new RollBackException("Failed to rollback transaction", e2);
	            }
	        }
	        throw new DataAccessException("Failed to delete item from cart", e);

	    } finally {
	        // Ensure proper cleanup of resources
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true); // Restore default auto-commit
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to cleanup resources", e);
	            }
	        }
	    }
	}


}
