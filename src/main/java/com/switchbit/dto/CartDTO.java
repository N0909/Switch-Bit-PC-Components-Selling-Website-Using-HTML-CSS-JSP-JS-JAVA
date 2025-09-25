package com.switchbit.dto;
import java.sql.Timestamp;
import com.switchbit.model.*;
import com.switchbit.dto.*;
import java.util.List;

public class CartDTO {
	private Cart cart;
	private List<CartItemDTO> items;
	
	public CartDTO() {}
	
	public CartDTO (Cart cart, List<CartItemDTO> items) {
		this.cart = cart;
		this.items = items;
	}

	public Cart getCart() {
		return cart;
	}

	public List<CartItemDTO> getItems() {
		return items;
	}

	public void setCart(Cart cart) {
		this.cart = cart;
	}

	public void setItems(List<CartItemDTO> items) {
		this.items = items;
	}
	
	
}
