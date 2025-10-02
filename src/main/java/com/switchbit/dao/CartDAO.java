package com.switchbit.dao;

import java.sql.*;
import com.switchbit.dto.*;
import java.util.ArrayList;
import java.util.List;
import com.switchbit.model.*;

public class CartDAO {
	
	public Cart getUserCart(Connection conn, User user) throws SQLException {
		Cart cart = new Cart();
		try(CallableStatement cs = conn.prepareCall("{call getCart(?)}")){
			cs.setString(1, user.getUserId());
			
			try(ResultSet rs = cs.executeQuery()){
				if (rs.next()) {
					cart.setCart_id(rs.getString("cart_id"));
					cart.setUser_id(rs.getString("user_id"));
					cart.setCreated_at(rs.getTimestamp("created_at"));
				}
			}
		}
		return cart;
	}
	
	public int getTotalItems(Connection conn, Cart cart) throws SQLException {
		int total_items = -1;
		try(CallableStatement cs = conn.prepareCall("{call getTotalItems(?)}");){
			cs.setString(1,cart.getCart_id());
			try (ResultSet rs = cs.executeQuery()){
				if (rs.next()) {
					total_items =  rs.getInt("total_items");
				}
			}
		}
		return total_items;
	}
	
	
	public boolean addCart(Connection conn, Cart cart) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call addCart(?, ?, ?)}");){
			cs.setString(1,cart.getCart_id());
			cs.setString(2,cart.getUser_id());
			cs.setTimestamp(3,cart.getCreated_at());
			
			return cs.executeUpdate()>0;
		}
	}
	
	
	public CartDTO getCart(Connection conn, User user) throws SQLException {
	    CartDTO cartdto = new CartDTO();
	    Cart cart = null;
	    List<CartItemDTO> items = new ArrayList<>();
	    try (CallableStatement stmt = conn.prepareCall("{call getCartItems(?)}")) {
	        stmt.setString(1, user.getUserId());
	        
	        try(ResultSet rs = stmt.executeQuery()){
	        	while (rs.next()) {
	        		if (cart==null) {
	        			cart = new Cart();
	        			cart.setCart_id(rs.getString("cart_id"));
	        			cart.setUser_id(rs.getString("user_id"));
	        			cart.setCreated_at(rs.getTimestamp("created_at"));
	        			cartdto.setCart(cart);
	        		}
	        		CartItemDTO item_dto = new CartItemDTO();
	        		
	        		item_dto.setCartItem(
	        				new CartItem(
	        					rs.getString("cart_item_id"),
	        					rs.getString("cart_id"),
	        					rs.getString("product_id"),
	        					rs.getInt("quantity")
	        					)
	        				);
	        		
	        		Product product = new Product();
	        		product.setProduct_id(rs.getString("product_id"));
	        		product.setProduct_name(rs.getString("product_name"));
	        		product.setPrice(rs.getDouble("price"));
	        		product.setProduct_img(rs.getString("product_img"));
	        		product.setStock_quantity(rs.getInt("stock_quantity"));
	        		
	        		item_dto.setProduct(product);
	        		
	        		items.add(item_dto);
	        	}
	        	cartdto.setItems(items);
	        }
	    }
	    return cartdto;
	}
	
	public void addCartItem(Connection conn, CartItem cartItem) throws SQLException {
		 if (cartItem == null || cartItem.getCart_id() == null || cartItem.getProduct_id() == null) {
		        throw new SQLException("CartItem, Cart, or Product cannot be null");
		    }

		    // Use try-with-resources to auto-close CallableStatement
		    try (CallableStatement cs = conn.prepareCall("{call addCartItem(?, ?, ?, ?)}")) {
		        cs.setString(1, cartItem.getCart_item_id());           // unique ID for cart item
		        cs.setString(2, cartItem.getCart_id());      // FK: cart ID
		        cs.setString(3, cartItem.getProduct_id());// FK: product ID
		        cs.setInt(4, cartItem.getQuantity());                  // product quantity

		        cs.executeUpdate(); // Execute the stored procedure
		    }
	}
	
	public int  deleteCartItem(Connection conn, CartItem cartitem) throws SQLException {
		try(CallableStatement cs = conn.prepareCall("{call deleteCartItem(?)}");){
			cs.setString(1, cartitem.getCart_item_id());
			return cs.executeUpdate();
		}
	}
	
	public int updateCartItemQuantity(Connection conn, CartItem cartitem) throws SQLException {
		try(CallableStatement cs = conn.prepareCall("{call updateCartItemQuantity(?, ?)}");){
			cs.setString(1, cartitem.getCart_item_id());
			cs.setInt(2, cartitem.getQuantity());
			return cs.executeUpdate();
		}
	}
	
	public int deleteAllCartItems(Connection conn, Cart cart) throws SQLException{
		try (CallableStatement cs = conn.prepareCall("{call deleteAllCartItems(?)}");){
			cs.setString(1, cart.getCart_id());
			return cs.executeUpdate();
		}
	}
}
