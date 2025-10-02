package com.switchbit.dto;
import com.switchbit.model.*;

public class OrderItemDTO {
	private OrderItem orderItem;
	private Product product;
	
	public OrderItemDTO() {}
	
	public OrderItemDTO(OrderItem orderItem, Product product) {
		this.orderItem = orderItem;
		this.product = product;
	}

	public OrderItem getOrderItem() {
		return orderItem;
	}

	public Product getProduct() {
		return product;
	}

	public void setOrderItem(OrderItem orderItem) {
		this.orderItem = orderItem;
	}

	public void setProduct(Product product) {
		this.product = product;
	}
	
}
