package com.switchbit.model;

public class OrderItem {
	private String order_item_id;
	private String order_id;
	private String product_id;
	private int quantity;
	
	public OrderItem() {}

	public OrderItem(String order_item_id, String order_id, String product_id, int quantity) {
		this.order_item_id = order_item_id;
		this.order_id = order_id;
		this.product_id = product_id;
		this.quantity = quantity;
	}

	public String getOrder_item_id() {
		return order_item_id;
	}

	public String getOrder_id() {
		return order_id;
	}

	public String getProduct_id() {
		return product_id;
	}

	public int getQuantity() {
		return quantity;
	}

	public void setOrder_item_id(String order_item_id) {
		this.order_item_id = order_item_id;
	}

	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}

	public void setProduct_id(String product_id) {
		this.product_id = product_id;
	}

	public void setQuantity(int quantity) {
		this.quantity = quantity;
	}

	@Override
	public String toString() {
		return "OrderItem [order_item_id=" + order_item_id + ", order_id=" + order_id + ", product_id=" + product_id
				+ ", quantity=" + quantity + "]";
	}
	
}
