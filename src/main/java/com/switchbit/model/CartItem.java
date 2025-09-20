package com.switchbit.model;

public class CartItem {
	private String cart_item_id;
	private Cart cart;
	private Product product;
	private int quantity;
	
	public CartItem() {}
	
	public CartItem(String cart_item_id, Cart cart, Product product, int quantity) {
		this.cart_item_id = cart_item_id;
		this.cart = cart;
		this.product = product;
		this.quantity = quantity;
	}
	
	
	public String getCart_item_id() {
		return cart_item_id;
	}

	public Cart getCart() {
		return cart;
	}

	public Product getProduct() {
		return product;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setCart_item_id(String cart_item_id) {
		this.cart_item_id = cart_item_id;
	}

	public void setCart(Cart cart) {
		this.cart = cart;
	}

	public void setProduct(Product product) {
		this.product = product;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	@Override
	public String toString() {
		return "CartItems [cart_item_id=" + cart_item_id + ", cart=" + cart + ", product=" + product + ", quantity="
				+ quantity + "]";
	}
	
	
}
