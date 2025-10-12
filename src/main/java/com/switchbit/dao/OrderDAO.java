package com.switchbit.dao;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.switchbit.model.*;
import com.switchbit.dto.*;

public class OrderDAO {
	
	/*
	 * Fetch a single order by order_id
	 */
	public Order getOrder(Connection conn, String order_id) throws SQLException{
		Order order = null;
		try (CallableStatement cs = conn.prepareCall("{call getOrder(?)}");){
			cs.setString(1, order_id);;
			try(ResultSet rs = cs.executeQuery()){
				if (rs.next()) {
					order = new Order(
								rs.getString("order_id"),
								rs.getString("user_id"),
								rs.getTimestamp("order_date"),
								rs.getDouble("total_amount"),
								rs.getString("order_status") ,
								rs.getDate("delivered_date")
							);
				}
			}
		}
		return order;
	}
	
	/*
	 * Fetch orders by user
	 */
	public List<Order> getOrders(Connection conn, User user) throws SQLException {
	    List<Order> orders = new ArrayList<Order>();

	    try (CallableStatement cs = conn.prepareCall("{call getOrdersByUser(?)}");) {
	        cs.setString(1, user.getUserId());
	        
	        try (ResultSet rs = cs.executeQuery();) {
	            while (rs.next()) {
	                Order order = new Order(
							rs.getString("order_id"),
							rs.getString("user_id"),
							rs.getTimestamp("order_date"),
							rs.getDouble("total_amount"),
							rs.getString("order_status"),
							rs.getDate("delivered_date")
						);
	                orders.add(order);
	            }
	        }
	    }
	    return orders;
	}	
	
	
	public List<Order> getOrders(Connection conn, String order_status) throws SQLException {
		List<Order> orders = new ArrayList<>();
		try (CallableStatement cs = conn.prepareCall("{call getOrders(?)}")){
			cs.setString(1, order_status);
			try (ResultSet rs = cs.executeQuery();){
				while (rs.next()) {
					orders.add(new Order(
								rs.getString("order_id"),
								rs.getString("user_id"),
								rs.getTimestamp("order_date"),
								rs.getDouble("total_amount"),
								rs.getString("order_status"),
								rs.getDate("delivered_date")
							));
				}
			}
		}
		return orders;
	}
	
	public List<Order> getOrders(Connection conn) throws SQLException {
		List<Order> orders = new ArrayList<>();
		try (CallableStatement cs = conn.prepareCall("{call getOrders(?)}")){
			cs.setString(1, "");
			try (ResultSet rs = cs.executeQuery();){
				while (rs.next()) {
					orders.add(new Order(
								rs.getString("order_id"),
								rs.getString("user_id"),
								rs.getTimestamp("order_date"),
								rs.getDouble("total_amount"),
								rs.getString("order_status"),
								rs.getDate("delivered_date")
							));
				}
			}
		}
		return orders;
	}
	
	/*
	 * Fetch order items for a given order
	 */
	public List<OrderItemDTO> getOrderItems(Connection conn, Order order) throws SQLException {
	    List<OrderItemDTO> orderItems = new ArrayList<OrderItemDTO>();

	    try (CallableStatement cs = conn.prepareCall("{call getOrderItems(?)}");) {
	        cs.setString(1, order.getOrder_id());

	        try (ResultSet rs = cs.executeQuery();) {
	            while (rs.next()) {
	                OrderItem orderItem = new OrderItem(
	                        rs.getString("order_item_id"),
	                        rs.getString("order_id"),
	                        rs.getString("product_id"),
	                        rs.getInt("quantity")
	                );
	                
	                Product product = new Product();
	                product.setProduct_id(rs.getString("product_id"));
	                product.setProduct_name(rs.getString("product_name"));
	                product.setProduct_img(rs.getString("product_img"));
	                product.setPrice(rs.getDouble("price"));
	                product.setStock_quantity(rs.getInt("stock_quantity"));

	                orderItems.add(new OrderItemDTO(orderItem, product));
	            }
	        }
	    }
	    return orderItems;
	}
	
	
	/*
	 * Place order from cart (multiple items)
	 */
	public void placeCartOrder(Connection conn, Order order, List<OrderItem> orderitems) throws SQLException{
		// Insert order with status
		try (CallableStatement cs = conn.prepareCall("{call addOrder(?, ?, ?, ?, ?)}");){
			cs.setString(1, order.getOrder_id());
			cs.setString(2, order.getUser_id());
			cs.setTimestamp(3, order.getOrder_date());
			cs.setDouble(4, order.getTotal_amount());
			cs.setString(5, order.getOrder_status());   
			cs.executeUpdate();
		}
		
		// Insert order items
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
	 * Place single-item order
	 */
	public void placeOrder(Connection conn, Order order, OrderItem orderitem) throws SQLException {
		// Insert order with status
		try (CallableStatement cs = conn.prepareCall("{call addOrder(?, ?, ?, ?, ?)}");){
			cs.setString(1, order.getOrder_id());
			cs.setString(2, order.getUser_id());
			cs.setTimestamp(3, order.getOrder_date());
			cs.setDouble(4, order.getTotal_amount());
			cs.setString(5, order.getOrder_status());   
			cs.executeUpdate();
		}
		
		// Insert order item
		try (CallableStatement cs = conn.prepareCall("{call addOrderItem(?, ?, ?, ?)}");){
			cs.setString(1, orderitem.getOrder_item_id());
			cs.setString(2, orderitem.getOrder_id());
			cs.setString(3, orderitem.getProduct_id());
			cs.setInt(4, orderitem.getQuantity());
			cs.executeUpdate();
		}
	}
	
	public void updateOrderStatus(Connection conn, String orderId, String status) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call updateOrderStatus(?, ?)}");){
			cs.setString(1, orderId);
			cs.setString(2, status);
			cs.executeUpdate();
		}
	}
	
	public void updateDeliveryDate(Connection conn, String orderId, Date date) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call updateDeliveryDate(?, ?)}");){
			cs.setString(1,orderId);
			cs.setDate(2, date);
			
			cs.executeUpdate();
		}
	}
	
	
	public OrderDetailsDTO getOrderDetails(Connection conn, String orderId) throws SQLException {
		OrderDetailsDTO dto = new OrderDetailsDTO();
		User user = null;
		Order order = null;
		Payment payment = null;
		List<OrderItemDTO> orderItems = new ArrayList();
		try (CallableStatement cs = conn.prepareCall("{call getOrderDetails(?)}");){
			cs.setString(1, orderId);
			boolean firstrow = true;
			try (ResultSet rs = cs.executeQuery()){
				while(rs.next()) {
					if (firstrow) {
						
						user = new User();
						user.setUserId(rs.getString("user_id"));
						user.setUserName(rs.getString("name"));
						user.setUserEmail(rs.getString("email"));
						user.setUserPhone(rs.getString("phone"));
						user.setUserAddress(rs.getString("address"));
						user.setRegDate(rs.getTimestamp("reg_date"));
						
						order = new Order();
						order.setOrder_id(rs.getString("order_id"));
						order.setOrder_date(rs.getTimestamp("order_date"));
						order.setOrder_status(rs.getString("order_status"));
						
						payment = new Payment();
						if (rs.getString("payment_id")!=null) {
							payment.setPaymentId(rs.getString("payment_id"));
							payment.setAmount(rs.getDouble("amount"));
							payment.setPaymentDate(rs.getTimestamp("payment_date"));
							payment.setPaymentMethod(Payment.PaymentMethod.fromString(rs.getString("payment_method")));
						}
						
						
						dto.setOrder(order);
						dto.setUser(user);
						dto.setPayment(payment);
						
						firstrow = false;
						
					}
					
					OrderItem item = new OrderItem();
					item.setOrder_item_id(rs.getString("order_item_id"));
					item.setOrder_id(rs.getString("order_id"));
					item.setProduct_id(rs.getString("product_id"));
					item.setQuantity(rs.getInt("quantity"));
					
					Product product = new Product();
					product.setProduct_id(rs.getString("product_id"));
					product.setProduct_name(rs.getString("product_name"));
					product.setPrice(rs.getDouble("price"));
					product.setStock_quantity(rs.getInt("stock_quantity"));
					
					orderItems.add(new OrderItemDTO(item, product));
				}
				dto.setOrderItemDTO(orderItems);			}
		}
		return dto;
	}

}
