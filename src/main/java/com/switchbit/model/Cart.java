package com.switchbit.model;

import java.sql.Timestamp;
import java.util.List;

public class Cart {
	private String cart_id;
	private User user;
	private Timestamp created_at;
	private List<CartItem> cart_items;
	
	public Cart() {}
	
	public Cart(String cart_id, User user, Timestamp created_at, List<CartItem> cart_items) {
		this.cart_id = cart_id;
		this.user = user;
		this.created_at = created_at;
		this.cart_items = cart_items;
	}

	public String getCart_id() {
		return cart_id;
	}

	public User getUser() {
		return user;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}
	
	
	public List<CartItem> getCart_items() {
		return cart_items;
	}

	public void setCart_id(String cart_id) {
		this.cart_id = cart_id;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	
	public void setCart_items(List<CartItem> cart_items) {
		this.cart_items = cart_items;
	}

	@Override
	public String toString() {
		return "Cart [cart_id=" + cart_id + ", user=" + user + ", created_at=" + created_at + ", cart_items="
				+ cart_items + "]";
	}
	
	
}
