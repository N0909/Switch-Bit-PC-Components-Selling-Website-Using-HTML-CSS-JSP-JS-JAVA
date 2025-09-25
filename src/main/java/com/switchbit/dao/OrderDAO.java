package com.switchbit.dao;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.switchbit.model.*;
import com.switchbit.dto.OrderDTO;

public class OrderDAO {
	
	/*
	 * Method for fetching orders from database based on user id
	 * @param conn - Active DbConnection
	 * @param user - User object with user_id
	 * @return List<Order> - List of orders belonging to the given user
	 * @throws SQLException if database access fails
	 */
	public List<Order> getOrders(Connection conn, User user) throws SQLException {
	    // List to hold all orders for the user
	    List<Order> orders = new ArrayList<Order>();

	    // Prepare a stored procedure call: getOrders(user_id)
	    try (CallableStatement cs = conn.prepareCall("{call getOrders(?)}");) {
	        cs.setString(1, user.getUserId()); // set the user_id parameter

	        // Execute query to fetch orders
	        try (ResultSet rs = cs.executeQuery();) {
	            while (rs.next()) {
	                // Create a new Order object from the result set
	                Order order = new Order(
	                        rs.getString("order_id"),
	                        rs.getString("user_id"),
	                        rs.getTimestamp("order_date"),
	                        rs.getDouble("total_amount")
	                );

	                // Add the order to the list
	                orders.add(order);
	            }
	        }
	    }

	    // Return all fetched orders
	    return orders;
	}
	
	/*
	 * Fetch all order items for a given order
	 * @param conn  - active DB connection
	 * @param order - the Order object (we use order_id from it)
	 * @return List<OrderItem> - list of items belonging to that order
	 * @throws SQLException if a DB error occurs
	 */
	public List<OrderItem> getOrderItems(Connection conn, Order order) throws SQLException {
	    // List to hold all order items
	    List<OrderItem> orderItems = new ArrayList<OrderItem>();

	    // Call stored procedure getOrderItems(order_id)
	    try (CallableStatement cs = conn.prepareCall("{call getOrderItems(?)}");) {
	        cs.setString(1, order.getOrder_id()); // set order_id parameter

	        // Execute the query and iterate results
	        try (ResultSet rs = cs.executeQuery();) {
	            while (rs.next()) {
	                // Map each row into an OrderItem object
	                OrderItem orderItem = new OrderItem(
	                        rs.getString("order_item_id"),
	                        rs.getString("order_id"),
	                        rs.getString("product_id"),
	                        rs.getInt("quantity")
	                );

	                // Add the item to the list
	                orderItems.add(orderItem);
	            }
	        }
	    }

	    // Return all items found
	    return orderItems;
	}
	
	
	/*
	 * Add a order in db with it's orderitems coming from cart
	 * @param conn  - active DB connection
	 * @param order - the Order object (we use order_id from it)
	 * @param List<OrderItem> - list of items belonging to that order
	 * @throws SQLException if a DB error occurs
	 */
	public void placeCartOrder(Connection conn, Order order, List<OrderItem> orderitems) throws SQLException{
		// Insert into order
		try (CallableStatement cs = conn.prepareCall("{call addOrder(?, ?, ?, ?)}");){
			cs.setString(1,order.getOrder_id());
			cs.setString(2, order.getUser_id());
			cs.setTimestamp(3, order.getOrder_date());
			cs.setDouble(4,order.getTotal_amount());
			
			cs.executeUpdate();
		}
		
		// Insert into OrderItems
		for (OrderItem item : orderitems) {
			try (CallableStatement cs = conn.prepareCall("{call addOrderItem(?, ?, ?, ?)}");){
				cs.setString(1, item.getOrder_item_id());
				cs.setString(2, item.getOrder_id());
				cs.setString(3, item.getProduct_id());
				cs.setInt(4, item.getQuantity());
				
				cs.executeUpdate();
			}
		}
	}
	
	
	/*
	 * Add a order in db with it's orderitems 
	 * @param conn  - active DB connection
	 * @param order - the Order object (we use order_id from it)
	 * @param List<OrderItem> - list of items belonging to that order
	 * @throws SQLException if a DB error occurs
	 */
	public void placeOrder(Connection conn, Order order, OrderItem orderitem) throws SQLException {
		// Insert into order
		try (CallableStatement cs = conn.prepareCall("{call addOrder(?, ?, ?, ?)}");){
			cs.setString(1,order.getOrder_id());
			cs.setString(2, order.getUser_id());
			cs.setTimestamp(3, order.getOrder_date());
			cs.setDouble(4,order.getTotal_amount());
					
			cs.executeUpdate();
		}
		
		// Insert into OrderItems
		try (CallableStatement cs = conn.prepareCall("{call addOrderItem(?, ?, ?, ?)}");){
			cs.setString(1, orderitem.getOrder_item_id());
			cs.setString(2, orderitem.getOrder_id());
			cs.setString(3, orderitem.getProduct_id());
			cs.setInt(4, orderitem.getQuantity());
			
			cs.executeUpdate();
		}
		
	}
	

}
