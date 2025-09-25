package com.switchbit.dto;

import com.switchbit.model.*;
import java.util.List;

public class OrderDTO {
	private Order order;
	private List<OrderItem> orderItem;
	
	public OrderDTO() {}
	
	public OrderDTO(Order order, List<OrderItem> orderItem) {
		this.order = order;
		this.orderItem = orderItem;
	}

	public Order getOrder() {
		return order;
	}

	public List<OrderItem> getOrderItem() {
		return orderItem;
	}

	public void setOrder(Order order) {
		this.order = order;
	}

	public void setOrderItem(List<OrderItem> orderItem) {
		this.orderItem = orderItem;
	}
	
}
