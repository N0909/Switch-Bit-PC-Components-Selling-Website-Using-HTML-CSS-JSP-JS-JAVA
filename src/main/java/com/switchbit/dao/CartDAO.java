package com.switchbit.dao;

import java.sql.*;
import java.util.ArrayList;
import com.switchbit.model.*;

public class CartDAO {
	
	public Cart getCart(Connection conn, User user) throws SQLException {
	    Cart cart = null;

	    try (CallableStatement stmt = conn.prepareCall("{call getCartItems(?)}")) {
	        stmt.setString(1, user.getUserId());

	        try (ResultSet rs = stmt.executeQuery()) {
	            while (rs.next()) {
	                if (cart == null) {
	                    cart = new Cart();
	                    cart.setCart_id(rs.getString("cart_id"));
	                    cart.setUser(user);
	                    cart.setCreated_at(rs.getTimestamp("created_at"));
	                    cart.setCart_items(new ArrayList<>());
	                }

	                CartItem item = new CartItem();
	                item.setCart_item_id(rs.getString("cart_item_id"));
	                item.setCart(cart);
	                item.setQuantity(rs.getInt("quantity"));

	                Product product = new Product();
	                product.setProduct_id(rs.getString("product_id"));
	                product.setProduct_name(rs.getString("product_name"));
	                product.setPrice(rs.getDouble("price"));
	                product.setProduct_img(rs.getString("product_img"));

	                item.setProduct(product);

	                cart.getCart_items().add(item);
	            }
	        }
	    }

	    return cart;
	}
	
	public void addCart(Connection conn, Cart cart) throws SQLException {
		System.out.println(cart);
		try (CallableStatement cs = conn.prepareCall("{call addCart(?,?,?)}");){
			cs.setString(1, cart.getCart_id());
			cs.setString(2, cart.getUser().getUserId());
			cs.setTimestamp(3, cart.getCreated_at());
			
			cs.executeUpdate();
			
		}
	}
	
	public void addCartItem(Connection conn, CartItem cartItem) throws SQLException {
		 if (cartItem == null || cartItem.getCart() == null || cartItem.getProduct() == null) {
		        throw new SQLException("CartItem, Cart, or Product cannot be null");
		    }

		    // Use try-with-resources to auto-close CallableStatement
		    try (CallableStatement cs = conn.prepareCall("{call addCartItem(?, ?, ?, ?)}")) {
		        cs.setString(1, cartItem.getCart_item_id());           // unique ID for cart item
		        cs.setString(2, cartItem.getCart().getCart_id());      // FK: cart ID
		        cs.setString(3, cartItem.getProduct().getProduct_id());// FK: product ID
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
	
	
}
