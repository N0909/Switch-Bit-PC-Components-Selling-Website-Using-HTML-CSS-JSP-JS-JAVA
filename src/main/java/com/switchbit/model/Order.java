package com.switchbit.model;
import java.sql.Date;
import java.sql.Timestamp;

import com.switchbit.model.Payment.PaymentMethod;

public class Order {
	private String order_id;
	private String user_id;
	private Timestamp order_date;
	private double total_amount;
	private String order_status;
	private Date delivery_date;
	public Order() {}
	
	public Order(String order_id, String user_id, Timestamp order_date, double total_amount, String order_status, Date delivery_date) {
		this.order_id = order_id;
		this.user_id = user_id;
		this.order_date = order_date;
		this.total_amount = total_amount;
		this.order_status = order_status;
		this.delivery_date = delivery_date;
	}

	public String getOrder_id() {
		return order_id;
	}

	public String getUser_id() {
		return user_id;
	}

	public Timestamp getOrder_date() {
		return order_date;
	}

	public double getTotal_amount() {
		return total_amount;
	}
	
	public String getOrder_status() {
		return order_status;
	}
	
	public Date getDelivery_date() {
		return delivery_date;
	}
	
	public void setOrder_id(String order_id) {
		this.order_id = order_id;
	}

	public void setUser_id(String user_id) {
		this.user_id = user_id;
	}

	public void setOrder_date(Timestamp order_date) {
		this.order_date = order_date;
	}

	public void setTotal_amount(double total_amount) {
		this.total_amount = total_amount;
	}
	
	public void setOrder_status(String order_status) {
		this.order_status = order_status;
	}
	
	public void setDelivery_date(Date delivery_date) {
		this.delivery_date = delivery_date;
	}

	@Override
	public String toString() {
		return "Order [order_id=" + order_id + ", user_id=" + user_id + ", order_date=" + order_date + ", total_amount="
				+ total_amount + ", order_status=" + order_status + ", delivery_date=" + delivery_date + "]";
	}

	
}
