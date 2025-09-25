package com.switchbit.model;

import java.sql.Timestamp;
import java.util.List;

public class Cart {
	private String cart_id;
	private String user_id;
	private Timestamp created_at;
	
	public Cart() {}
	
	public Cart(String cart_id, String user_id, Timestamp created_at) {
		this.cart_id = cart_id;
		this.user_id = user_id;
		this.created_at = created_at;
	}

	public String getCart_id() {
		return cart_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public Timestamp getCreated_at() {
		return created_at;
	}
	
	public void setCart_id(String cart_id) {
		this.cart_id = cart_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public void setCreated_at(Timestamp created_at) {
		this.created_at = created_at;
	}
	
	@Override
	public String toString() {
		return "Cart [cart_id=" + cart_id + ", user_id=" + user_id + ", created_at=" + created_at + "]";
	}
	
	
}
