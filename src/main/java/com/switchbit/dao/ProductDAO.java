package com.switchbit.dao;

import java.sql.*;

import com.switchbit.model.Category;
import com.switchbit.model.Product;
import java.util.List;
import java.util.ArrayList;
import com.switchbit.util.PaginatedResult;

public class ProductDAO {
	/**
	 * Fetches all products from the database using the stored procedure `getProducts()`.
	 *
	 * @param conn Active database connection (must not be null).
	 * @return A list of Product objects representing all products in the system.
	 * @throws SQLException If a database error occurs while executing the query.
	 */
	public List<Product> getProducts(Connection conn, int limit) throws SQLException {
		List<Product> products = new ArrayList<Product>();
		
		try(CallableStatement callgetProducts = conn.prepareCall("{call getProducts(?)}");){
			
			callgetProducts.setInt(1, limit);
			ResultSet rs = callgetProducts.executeQuery();
			// Iterate through result set and map each row into a Product object
			while (rs.next()) {
				Category category = new Category (
						rs.getString("category_id"),
						rs.getString("category_name"),
						rs.getString("category_image")
				);
	            Product product = new Product(
	                rs.getString("product_id"),
	                rs.getString("product_name"),
	                rs.getString("description"),
	                rs.getDouble("price"),
	                rs.getInt("stock_quantity"),
	                category,
	                rs.getString("product_img"),
	                rs.getTimestamp("last_updated")
	            );
	            products.add(product);
	        }
		
			// Return the list
			return products;
		}

	}
	
	/**
	 * Fetches a single Product by its ID from the database.
	 * 
	 * - Calls a stored procedure: getProductById(?)
	 * - Maps the ResultSet to a Product object.
	 * - Also maps the associated Category (instead of just category_id).
	 *
	 * @param conn Active database connection (transaction-aware if needed).
	 * @param id   The product ID to look up.
	 * @return     Product object with full details (including Category), or null if not found.
	 * @throws SQLException If any database error occurs.
	 */
	public Product getProduct(Connection conn, String id) throws SQLException {
	    Product product = null;

	    // Use try-with-resources to ensure CallableStatement is closed automatically
	    try (CallableStatement csmt = conn.prepareCall("{call getProductById(?)}")) {
	        
	        // Set input parameter for stored procedure
	        csmt.setString(1, id);

	        // Execute stored procedure
	        ResultSet rs = csmt.executeQuery();

	        // If product exists, map result set to Product & Category objects
	        if (rs.next()) {
	            Category category = new Category(
	                rs.getString("category_id"),
	                rs.getString("category_name"),
	                rs.getString("category_image")
	            );

	            product = new Product(
	                rs.getString("product_id"),
	                rs.getString("product_name"),
	                rs.getString("description"),
	                rs.getDouble("price"),
	                rs.getInt("stock_quantity"),
	                category, // passing Category object instead of just category_id
	                rs.getString("product_img"),
	                rs.getTimestamp("last_updated")
	            );
	        }
	    }

	    // Return the mapped Product, or null if not found
	    return product;
	}
	
	public List<Product> searchProducts(Connection conn, String search_var) throws SQLException{
		List<Product> products = new ArrayList<Product>();
		try(CallableStatement searchProducts = conn.prepareCall("{call searchProducts(?)}")){
			searchProducts.setString(1,search_var);
			ResultSet rs = searchProducts.executeQuery();
			while(rs.next()) {
				Category category = new Category (
						rs.getString("category_id"),
						rs.getString("category_name"),
						rs.getString("category_image")
				);
	            Product product = new Product(
	                rs.getString("product_id"),
	                rs.getString("product_name"),
	                rs.getString("description"),
	                rs.getDouble("price"),
	                rs.getInt("stock_quantity"),
	                category,
	                rs.getString("product_img"),
	                rs.getTimestamp("last_updated")
	            );
	            products.add(product);
			}
			return products;
		}
	}
	
	public List<Product> getProductsByCategory(Connection conn, String search_var) throws SQLException{
		List<Product> products = new ArrayList<Product>();
		try(CallableStatement searchProducts = conn.prepareCall("{call getProductsByCategory(?)}")){
			searchProducts.setString(1,search_var);
			ResultSet rs = searchProducts.executeQuery();
			while(rs.next()) {
				Category category = new Category (
						rs.getString("category_id"),
						rs.getString("category_name"),
						rs.getString("category_image")
				);
	            Product product = new Product(
	                rs.getString("product_id"),
	                rs.getString("product_name"),
	                rs.getString("description"),
	                rs.getDouble("price"),
	                rs.getInt("stock_quantity"),
	                category,
	                rs.getString("product_img"),
	                rs.getTimestamp("last_updated")
	            );
	            products.add(product);
			}
			return products;
		}
	}
	
	
	/**
	 * Adds a new product into the database using a stored procedure.
	 * 
	 * @param conn    The active database connection (transaction control is handled outside).
	 * @param product The Product object containing all necessary details.
	 * @throws SQLException If any database error occurs during the insert.
	 */
	public void addProduct(Connection conn, Product product) throws SQLException {
	    // Use try-with-resources to automatically close the CallableStatement
	    try (CallableStatement addProduct = conn.prepareCall("{call addProduct(?, ?, ?, ?, ?, ?, ?, ?)}")) {
	        // Set procedure parameters in order
	        addProduct.setString(1, product.getProduct_id());
	        addProduct.setString(2, product.getProduct_name());
	        addProduct.setString(3, product.getDescription());
	        addProduct.setDouble(4, product.getPrice());
	        addProduct.setInt(5, product.getStock_quantity());
	        addProduct.setString(6, product.getCategory().getCategory_id());
	        addProduct.setString(7, product.getProduct_img());
	        addProduct.setTimestamp(8, product.getLast_updated());

	        // Execute the stored procedure
	        addProduct.executeUpdate();
	    }
	}

	/**
	 * Updates an existing product in the database using a stored procedure.
	 * 
	 * @param conn    The active database connection (transaction control is handled outside).
	 * @param product The Product object containing updated details.
	 * @throws SQLException If any database error occurs during the update.
	 */
	public void updateProduct(Connection conn, Product product) throws SQLException {
	    try (CallableStatement updateProduct = conn.prepareCall("{call updateProduct(?, ?, ?, ?, ?, ?, ?, ?)}")) {
	        updateProduct.setString(1, product.getProduct_id());
	        updateProduct.setString(2, product.getProduct_name());
	        updateProduct.setString(3, product.getDescription());
	        updateProduct.setDouble(4, product.getPrice());
	        updateProduct.setInt(5, product.getStock_quantity());
	        updateProduct.setString(6, product.getCategory().getCategory_id());
	        updateProduct.setString(7, product.getProduct_img());
	        updateProduct.setTimestamp(8, product.getLast_updated());

	        updateProduct.executeUpdate();
	    }
	}

	/**
	 * Deletes a product from the database using a stored procedure.
	 * 
	 * @param conn    The active database connection (transaction control is handled outside).
	 * @param product The Product object representing the product to delete (only ID is required).
	 * @throws SQLException If any database error occurs during deletion.
	 */
	public int deleteProduct(Connection conn, Product product) throws SQLException {
	    try (CallableStatement deleteProduct = conn.prepareCall("{call deleteProduct(?)}")) {
	        // Only the product ID is needed for deletion
	        deleteProduct.setString(1, product.getProduct_id());

	        return deleteProduct.executeUpdate();
	    }
	}
	
	public List<Category> getCategories(Connection conn) throws SQLException{
		List<Category> categories = new ArrayList<Category>();
		try(CallableStatement getCategories = conn.prepareCall("{call getCategories()}");
			ResultSet rs = getCategories.executeQuery()){
			while(rs.next()) {
				categories.add(new Category(rs.getString("category_id"), rs.getString("category_name"), rs.getString("category_image")));
			}
		}
		return categories;
	}
	
	public Category getCategory(Connection conn, String category_id) throws SQLException {
		Category category = null;
		try (CallableStatement getCategory = conn.prepareCall("{call getCategory(?)}")){
			getCategory.setString(1,category_id);
			try(ResultSet rs = getCategory.executeQuery()){
				if (rs.next()) {					
				category = new Category(
							rs.getString("category_id"),
							rs.getString("category_name"),
							rs.getString("category_image")
						);	
				}
			}
		}
		return category;
	}
	
	
	public PaginatedResult<Product> getProductsPage(Connection conn, int page, int pageSize) throws SQLException{
		try(CallableStatement getProductsPage = conn.prepareCall("{call getProductsPage(?,?,?)}");){
			
			List<Product> products = new ArrayList<Product>();
			getProductsPage.setInt(1, page);
			getProductsPage.setInt(2, pageSize);
			getProductsPage.registerOutParameter(3, Types.INTEGER);
			
			boolean hasResult = getProductsPage.execute();
			
			if (hasResult) {
				try (ResultSet rs = getProductsPage.getResultSet()) {
	                while (rs.next()) {
	                    Category category = new Category(
	                        rs.getString("category_id"),
	                        rs.getString("category_name"),
	                        rs.getString("category_image")
	                    );
	                    Product p = new Product(
	                        rs.getString("product_id"),
	                        rs.getString("product_name"),
	                        rs.getString("description"),
	                        rs.getDouble("price"),
	                        rs.getInt("stock_quantity"),
	                        category,
	                        rs.getString("product_img"),
	                        rs.getTimestamp("last_updated")
	                    );
	                    products.add(p);
	                }
	            }
	        }
			int total = getProductsPage.getInt(3);
			
			return new PaginatedResult<>(products, page, pageSize, total);
		}
	}
	
	public PaginatedResult<Product> searchProductPage(Connection conn, String searchVar,int page, int pageSize) throws SQLException{
		List<Product> products = new ArrayList<Product>();
		
		try (CallableStatement cs = conn.prepareCall("{call searchProductsPage(?,?,?,?)}");){
				cs.setString(1, searchVar);
				cs.setInt(2, page);
				cs.setInt(3, pageSize);
				cs.registerOutParameter(4, Types.INTEGER);
				
				boolean hasResult = cs.execute();
				
				if (hasResult) {
					try(ResultSet rs = cs.getResultSet()){
						while (rs.next()) {
		                    Category category = new Category(
		                        rs.getString("category_id"),
		                        rs.getString("category_name"),
		                        rs.getString("category_image")
		                    );
		                    Product p = new Product(
		                        rs.getString("product_id"),
		                        rs.getString("product_name"),
		                        rs.getString("description"),
		                        rs.getDouble("price"),
		                        rs.getInt("stock_quantity"),
		                        category,
		                        rs.getString("product_img"),
		                        rs.getTimestamp("last_updated")
		                    );
		                    products.add(p);
		                }
					}
				}
				int total = cs.getInt(4);
				return new PaginatedResult<>(products, page, pageSize, total);
			}
		}
	
	public PaginatedResult<Product> getProductsByCategory(Connection conn,String category_id, int page, int pageSize) throws SQLException{
		List<Product> products = new ArrayList<Product>();
		try (CallableStatement cs = conn.prepareCall("{call getProductsByCategoryPage(?,?,?,?)}");){
			cs.setString(1, category_id);
			cs.setInt(2, page);
			cs.setInt(3, pageSize);
			cs.registerOutParameter(4, Types.INTEGER);
			
			boolean hasResult = cs.execute();
			
			if (hasResult) {
				try(ResultSet rs = cs.getResultSet()){
					while (rs.next()) {
	                    Category category = new Category(
	                        rs.getString("category_id"),
	                        rs.getString("category_name"),
	                        rs.getString("category_image")
	                    );
	                    Product p = new Product(
	                        rs.getString("product_id"),
	                        rs.getString("product_name"),
	                        rs.getString("description"),
	                        rs.getDouble("price"),
	                        rs.getInt("stock_quantity"),
	                        category,
	                        rs.getString("product_img"),
	                        rs.getTimestamp("last_updated")
	                    );
	                    products.add(p);
	                }
				}
			}
			int total = cs.getInt(4);
			return new PaginatedResult<>(products, page, pageSize, total);
		}
	}
	
	public List<Product> getLowStockProduct(Connection conn) throws SQLException{
		List<Product> products = new ArrayList<Product>();
		String sql = "SELECT "
		           + "product_id, "
		           + "product_name, "
		           + "description, "
		           + "price, "
		           + "stock_quantity, "
		           + "category.category_id, "
		           + "product_img, "
		           + "last_updated, "
		           + "category_name, "
		           + "category_image "
		           + "FROM product "
		           + "JOIN category ON category.category_id = product.category_id "
		           + "WHERE stock_quantity < 10";

		try (Statement stmt = conn.createStatement();
			  ResultSet rs = stmt.executeQuery(sql)){
			while(rs.next()) {
				Category category = new Category (
						rs.getString("category_id"),
						rs.getString("category_name"),
						rs.getString("category_image")
				);
	            Product product = new Product(
	                rs.getString("product_id"),
	                rs.getString("product_name"),
	                rs.getString("description"),
	                rs.getDouble("price"),
	                rs.getInt("stock_quantity"),
	                category,
	                rs.getString("product_img"),
	                rs.getTimestamp("last_updated")
	            );
	            products.add(product);
			}
		}
		return products;
	}
	
	
	
}
