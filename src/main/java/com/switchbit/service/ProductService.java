package com.switchbit.service;

import java.util.List;
import java.sql.*;

import com.switchbit.dao.ProductDAO;
import com.switchbit.util.*;
import com.switchbit.model.Product;
import com.switchbit.model.Category;
import com.switchbit.exceptions.*;

public class ProductService {
	private ProductDAO productDAO;

	public ProductService() {
		this.productDAO = new ProductDAO();
	}

	// Fetch all products from database
	public List<Product> getProducts(int limit) throws DataAccessException {
		try (Connection conn = DBConnection.getConnection()) {
			List<Product> products = productDAO.getProducts(conn, limit);

			return products;
		} catch (SQLException e) {
			throw new DataAccessException("Failed to retrieve all products", e);
		}
	}

	// Fetch products filtered by category name
	public List<Product> getProductsByCategory(String categoryName) throws DataAccessException {
		try (Connection conn = DBConnection.getConnection()) {
			List<Product> products = productDAO.getProductsByCategory(conn, categoryName);

			return products; // return list (empty if no matches found)
		} catch (SQLException e) {
			throw new DataAccessException("Failed to retrieve products for category: " + categoryName, e);
		}
	}

	public List<Product> searchProducts(String search_var) throws DataAccessException {
		try (Connection conn = DBConnection.getConnection()) {
			List<Product> products = productDAO.searchProducts(conn, search_var);

			return products;
		} catch (SQLException e) {
			throw new DataAccessException("Failed to retrieve products for query: " + search_var, e);
		}
	}
	
	public Product getProduct(String product_id) throws DataAccessException {
		try (Connection conn = DBConnection.getConnection()){
			return productDAO.getProduct(conn, product_id);
		}catch(SQLException e) {
			throw new DataAccessException("failed to retreive product with id: "+product_id);
		}
	}

	/**
	 * Adds a new product to the database in a transactional manner.
	 *
	 * Workflow: 1. Open DB connection and disable auto-commit (start transaction).
	 * 2. Generate the next product ID from the sequence table. 3. Insert the
	 * product into the DB. 4. Update the sequence value. 5. Commit if everything
	 * succeeds.
	 *
	 * If any step fails: - Rollback the transaction on the same connection. - Wrap
	 * and rethrow as a DataAccessException.
	 *
	 * Finally: - Always restore auto-commit and close the connection.
	 *
	 * @param product The product to insert
	 * @throws DataAccessException      if insertion or DB operations fail
	 * @throws RollBackException        if rollback fails after an update error.
	 * @throws CloseConnectionException if closing the connection fails.
	 */
	public Product addProduct(Product product) throws DataAccessException, RollBackException, CloseConnectionException {
		Connection conn = null;

		try {
			// Step 1: Open connection & begin transaction
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			// Step 2: Generate product ID
			int currentId = IdGeneratorDAO.getCurrentIdVal(conn, "Product");
			String productId = MiscUtil.idGenerator("PROD000", currentId);
			product.setProduct_id(productId);

			// Step 3: Insert product
			productDAO.addProduct(conn, product);

			// Step 4: Update sequence
			IdGeneratorDAO.setNextIdVal(conn, "Product", currentId);

			// Step 5: Commit transaction
			conn.commit();

			return productDAO.getProduct(conn, product.getProduct_id());

		} catch (SQLException e) {
			// Rollback if something fails
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException rollbackEx) {
					throw new RollBackException("Failed to rollback transaction", rollbackEx);
				}
			}
			throw new DataAccessException("Failed to add product", e);

		} finally {
			// Cleanup connection safely
			if (conn != null) {
				try {
					conn.setAutoCommit(true); // restore default mode
					conn.close();
				} catch (SQLException closeEx) {
					throw new CloseConnectionException("Failed to close connection", closeEx);
				}
			}
		}
	}

	/**
	 * Updates an existing product in the database. Responsibilities: 1. Open a
	 * database connection. 2. Begin a transaction (disable auto-commit). 3. Call
	 * the DAO to perform the update. 4. Commit if successful, rollback if failure
	 * occurs. 5. Ensure the connection is always cleaned up.
	 *
	 * @param product The product object containing updated details.
	 * @throws DataAccessException      if the update fails due to SQL/DB errors.
	 * @throws RollBackException        if rollback fails after an update error.
	 * @throws CloseConnectionException if closing the connection fails.
	 */
	public Product updateProduct(Product product)
			throws DataAccessException, CloseConnectionException, RollBackException {

		Connection conn = null;

		try {
			// 1. Get connection and begin transaction
			conn = DBConnection.getConnection();
			conn.setAutoCommit(false);

			// 2. Delegate actual update to DAO
			productDAO.updateProduct(conn, product);

			// 3. Commit transaction on success
			conn.commit();

			return productDAO.getProduct(conn, product.getProduct_id());

		} catch (SQLException e) {
			// 4. Rollback if something fails
			if (conn != null) {
				try {
					conn.rollback();
				} catch (SQLException rollbackEx) {
					throw new RollBackException("Failed to rollback transaction", rollbackEx);
				}
			}
			throw new DataAccessException("Failed to update product", e);

		} finally {
			// 5. Cleanup resources safely
			if (conn != null) {
				try {
					conn.setAutoCommit(true); // restore default
					conn.close();
				} catch (SQLException closeEx) {
					// Closing failures are not user-facing issues
					throw new CloseConnectionException("Failed to close connection", closeEx);
				}
			}
		}
	}
	/**
	 * Deletes an existing product from the database.
	 * Workflow:
	 * 1. Establish a DB connection.
	 * 2. Begin a transaction (disable auto-commit).
	 * 3. Delegate delete operation to DAO.
	 * 4. Commit if successful.
	 * 5. Rollback if any failure occurs.
	 * 6. Always clean up connection resources in the finally block.
	 *
	 * @param product The product object to be deleted (must contain a valid product_id).
	 * @return true if the product was deleted, false if no product matched the given product_id.
	 * @throws DataAccessException        if the delete operation fails due to SQL/DB issues.
	 * @throws RollBackException          if rollback fails after a delete error.
	 * @throws CloseConnectionException   if closing the connection fails.
	 */
	public boolean deleteProduct(Product product) 
	        throws DataAccessException, CloseConnectionException, RollBackException {

	    Connection conn = null;

	    try {
	        // 1. Open connection and start transaction
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // 2. Perform delete via DAO and capture row count
	        int rowsAffected = productDAO.deleteProduct(conn, product);

	        // 3. Commit transaction
	        conn.commit();

	        // 4. Return true if at least one row was deleted
	        return rowsAffected > 0;

	    } catch (SQLException e) {
	        // 5. Rollback if delete fails
	        if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException rollbackEx) {
	                throw new RollBackException("Failed to rollback transaction", rollbackEx);
	            }
	        }
	        throw new DataAccessException("Failed to delete product with ID: " + product.getProduct_id(), e);

	    } finally {
	        // 6.cleanup DB resources
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true); // restore default mode
	                conn.close();
	            } catch (SQLException closeEx) {
	                throw new CloseConnectionException("Failed to close connection", closeEx);
	            }
	        }
	    }
	}
	
	// Fetch all Categories from database 
	public List<Category> getCategories() throws DataAccessException{
		try (Connection conn = DBConnection.getConnection()){
			return productDAO.getCategories(conn);
		}catch(SQLException e) {
			throw new DataAccessException("failed to retrieve Categories");
		}
	}
	
	// Fetch a category from database which matches the category id
	public Category getCategory(String category_id) throws DataAccessException{
		try(Connection conn = DBConnection.getConnection()){
			return productDAO.getCategory(conn, category_id);
		}catch(SQLException e) {
			throw new DataAccessException("failed to retrive Category with id: "+category_id);
		}
	}
	
	public PaginatedResult<Product> getProductsPage(int page, int pageSize) throws DataAccessException{
		if (page<1) page=1;
		
		if (pageSize<=0) pageSize=5;
		
		try(Connection conn = DBConnection.getConnection()){
			return productDAO.getProductsPage(conn, page, pageSize);
		}catch(SQLException e) {
			throw new DataAccessException("failed to get products", e);
		}
		
	}
	
	public PaginatedResult<Product> searchProductsPage(String search_var,int page, int pageSize) throws DataAccessException{
		if (page<1) page=1;
		if (pageSize<0) pageSize=5;
		
		try(Connection conn = DBConnection.getConnection()){
			search_var = search_var.replaceAll("\"", "");
			search_var = search_var.replaceAll(" ", "|");
			return productDAO.searchProductPage(conn, search_var, page, pageSize);
		}catch(SQLException e) {
			throw new DataAccessException("failed to get products", e);
		}
	}
	
	public PaginatedResult<Product> getProductsByCategoryPage(String categoryId, int page, int pageSize) throws DataAccessException {
		if (page<1) page=1;
		if (pageSize<0) pageSize=5;
		
		try(Connection conn = DBConnection.getConnection()){
			return productDAO.getProductsByCategory(conn, categoryId, page, pageSize);
		}catch(SQLException e) {
			throw new DataAccessException("failed to get products with category: "+categoryId);
		}
	}

}
