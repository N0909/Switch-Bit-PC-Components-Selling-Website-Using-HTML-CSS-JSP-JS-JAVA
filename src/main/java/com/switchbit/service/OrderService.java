package com.switchbit.service;

import com.switchbit.model.*;
import com.switchbit.util.*;
import com.switchbit.dao.*;
import com.switchbit.dto.*;
import com.switchbit.exceptions.*;

import java.util.List;
import java.util.ArrayList;
import java.sql.*;

public class OrderService {
	private OrderDAO order_dao;
	private CartDAO cart_dao;
	
	public OrderService() {
		this.order_dao = new OrderDAO();
		this.cart_dao = new CartDAO();
	}
	
	public List<Order> getOrders(User user) throws DataAccessException{ 
		List<Order> orders = new ArrayList<Order>();
		try(Connection conn = DBConnection.getConnection()){
			orders = order_dao.getOrders(conn, user);
		}catch(SQLException e) {
			throw new DataAccessException("failed to fetch orders");
		}
		return orders;
	}
	
	public List<OrderItem> getOrderItems(Order order) throws DataAccessException{
		List<OrderItem> orderitems = new ArrayList<OrderItem> ();
		try (Connection conn = DBConnection.getConnection()){
			orderitems = order_dao.getOrderItems(conn, order);
		}catch (SQLException e) {
			throw new DataAccessException("failed to get items for order id:"+order.getOrder_id());
		}
		return orderitems;
	}
	
	/**
	 * Places an order based on the items in the user's cart.
	 * This method handles both the creation of the Order and its associated OrderItems.
	 * It also clears the cart after the order is successfully placed.
	 *
	 * @param dto - CartDTO containing Cart and list of CartItemDTO
	 * @throws RollBackException - if transaction rollback fails
	 * @throws DataAccessException - if any SQL operation fails
	 * @throws CloseConnectionException - if closing the connection fails
	 */
	public void placeCartOrder(CartDTO dto) throws RollBackException, DataAccessException, CloseConnectionException {
	    Connection conn = null;

	    try {
	        // Create order object and list to hold order items
	        Order order = new Order();
	        List<OrderItem> orderItems = new ArrayList<>();

	        // Get DB connection and start transaction
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // Generate a new order ID
	        int current_order_val = IdGeneratorDAO.getCurrentIdVal(conn, "orders");
	        String order_id = MiscUtil.idGenerator("OD0000", current_order_val);

	        // Set order properties
	        order.setOrder_id(order_id);
	        order.setUser_id(dto.getCart().getUser_id());
	        order.setOrder_date(new Timestamp(System.currentTimeMillis()));
	        order.setTotal_amount(MiscUtil.CalcuateTotal(dto)); 

	        // Create OrderItem objects from CartItemDTOs
	        for (CartItemDTO item : dto.getItems()) {
	            int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "order_item");
	            String order_item_id = MiscUtil.idGenerator("OI0000", current_val);

	            orderItems.add(new OrderItem(
	                    order_item_id,
	                    order.getOrder_id(),
	                    item.getProduct().getProduct_id(),
	                    item.getCartItem().getQuantity()
	            ));

	            // Update the next ID value for order_item table
	            IdGeneratorDAO.setNextIdVal(conn, "order_item", current_val);
	        }

	        // Update the next ID value for order table
	        IdGeneratorDAO.setNextIdVal(conn, "orders", current_order_val);

	        // Persist order and order items in the database
	        order_dao.placeCartOrder(conn, order, orderItems);

	        // Clear all items from the cart
	        cart_dao.deleteAllCartItems(conn, dto.getCart());

	        // Commit transaction
	        conn.commit();

	    } catch (SQLException e) {
	        // Rollback transaction if anything fails
	        if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException e1) {
	                throw new RollBackException("Failed to rollback transaction");
	            }
	        }
	        throw new DataAccessException("Failed to place order", e);

	    } finally {
	        // Ensure connection is closed and auto-commit restored
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true);
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to close connection");
	            }
	        }
	    }
	}
	
	/**
	 * Places an order for a single product when a user clicks "Buy Now".
	 * This method creates an Order and a single OrderItem in the database.
	 *
	 * @param user - User object who is placing the order
	 * @param product - Product object to be purchased
	 * @throws RollBackException - if transaction rollback fails
	 * @throws DataAccessException - if any SQL operation fails
	 * @throws CloseConnectionException - if closing the connection fails
	 */
	public void placeOrder(User user, Product product, int quantity) throws RollBackException, DataAccessException, CloseConnectionException {
	    Connection conn = null;

	    try {
	        // Get DB connection and disable auto-commit for transaction
	        conn = DBConnection.getConnection();
	        conn.setAutoCommit(false);

	        // Create order object
	        Order order = new Order();
	        order.setUser_id(user.getUserId());
	        order.setOrder_date(new Timestamp(System.currentTimeMillis()));
	        order.setTotal_amount(product.getPrice()*quantity);

	        // Generate a new order ID
	        int current_order_val = IdGeneratorDAO.getCurrentIdVal(conn, "orders");
	        String order_id = MiscUtil.idGenerator("O0000", current_order_val);
	        order.setOrder_id(order_id);

	        // Create order item object
	        OrderItem order_item = new OrderItem();
	        order_item.setOrder_id(order.getOrder_id());
	        order_item.setProduct_id(product.getProduct_id());
	        order_item.setQuantity(quantity); 
	        // Generate order item ID
	        int current_val = IdGeneratorDAO.getCurrentIdVal(conn, "order_item");
	        String order_item_id = MiscUtil.idGenerator("OI0000", current_val);
	        order_item.setOrder_item_id(order_item_id);

	        // Persist order and order item in DB
	        order_dao.placeOrder(conn, order, order_item);

	        // Update next ID values
	        IdGeneratorDAO.setNextIdVal(conn, "orders", current_order_val);
	        IdGeneratorDAO.setNextIdVal(conn, "order_item", current_val);

	        // Commit transaction
	        conn.commit();

	    } catch (SQLException e) {
	        // Rollback transaction if anything fails
	        if (conn != null) {
	            try {
	                conn.rollback();
	            } catch (SQLException e1) {
	                throw new RollBackException("Failed to rollback transaction");
	            }
	        }
	        throw new DataAccessException("Failed to place order"+e);

	    } finally {
	        // Ensure connection is closed and auto-commit restored
	        if (conn != null) {
	            try {
	                conn.setAutoCommit(true);
	                conn.close();
	            } catch (SQLException e) {
	                throw new CloseConnectionException("Failed to close connection");
	            }
	        }
	    }
	}

}
