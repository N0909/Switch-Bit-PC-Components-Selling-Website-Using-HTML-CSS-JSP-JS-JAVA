package com.switchbit.model;
import java.sql.Timestamp;

public class Order {
	private String order_id;
	private String user_id;
	private Timestamp order_date;
	private double total_amount;
	
	public Order() {}
	
	public Order(String order_id, String user_id, Timestamp order_date, double total_amount) {
		this.order_id = order_id;
		this.user_id = user_id;
		this.order_date = order_date;
		this.total_amount = total_amount;
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

	@Override
	public String toString() {
		return "Order [order_id=" + order_id + ", user_id=" + user_id + ", order_date=" + order_date + ", total_amount="
				+ total_amount + "]";
	}
	
	
	
}
