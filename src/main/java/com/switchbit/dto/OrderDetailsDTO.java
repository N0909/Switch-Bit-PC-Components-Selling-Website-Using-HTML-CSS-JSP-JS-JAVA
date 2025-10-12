package com.switchbit.dto;

import com.switchbit.model.*;
import com.switchbit.dto.*;
import java.util.List;

public class OrderDetailsDTO {
	private Order order;
	private User user;
	private Payment payment;
	private List<OrderItemDTO> orderItems;
	
	public OrderDetailsDTO() {}
	
	public OrderDetailsDTO(Order order, User user, Payment payment, List<OrderItemDTO> orderItems) {
		this.order = order;
		this.user = user;
		this.payment = payment;
		this.orderItems = orderItems;
	}

	public Order getOrder() {
		return order;
	}
	
	public User getUser() {
		return user;
	}
	
	public Payment getPayment() {
		return payment;
	}

	public List<OrderItemDTO> getOrderItemDTO() {
		return orderItems;
	}
	

	public void setOrder(Order order) {
		this.order = order;
	}
	
	public void setUser(User user) {
		this.user = user;
	}
	
	public void setPayment(Payment payment) {
		this.payment = payment;
	}

	public void setOrderItemDTO(List<OrderItemDTO> orderItem) {
		this.orderItems = orderItem;
	}
	
	
	
}
