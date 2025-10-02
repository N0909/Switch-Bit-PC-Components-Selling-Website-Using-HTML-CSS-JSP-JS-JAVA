package com.switchbit.dao;

import com.switchbit.model.*;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;

public class PaymentDAO {
	
	public void addPayment(Connection conn, Payment payment) throws SQLException {
		try(CallableStatement cs = conn.prepareCall("{call addPayment(?, ?, ?, ?, ?, ?)}");) {
			cs.setString(1, payment.getPaymentId());
			cs.setString(2, payment.getOrderId());
			cs.setString(3, payment.getUserId());
			cs.setDouble(4, payment.getAmount());
			cs.setTimestamp(5, payment.getPaymentDate());
			cs.setString(6, payment.getPaymentMethod().getValue());
			
			cs.executeUpdate();
		}
	}
	
	public List<Payment> getPaymentsByUser(Connection conn, User user) throws SQLException {
		List<Payment> payments = new ArrayList<Payment>();
		try (CallableStatement cs = conn.prepareCall("{call getPaymentsByUser(?)}");){
			cs.setString(1,user.getUserId());
			try (ResultSet rs = cs.executeQuery();){
				while(rs.next()) {
					Payment payment = new Payment(
								rs.getString("payment_id"),
								rs.getString("order_id"),
								rs.getString("user_id"),
								rs.getDouble("amount"),
								rs.getTimestamp("payment_date"),
								Payment.PaymentMethod.fromString(rs.getString("payment_method"))
							);
					
					payments.add(payment);
				}
			}
		}
		return payments;
	}
	
	public List<Payment> getPayments(Connection conn) throws SQLException {
		List<Payment> payments = new ArrayList<Payment>();
		try (CallableStatement cs = conn.prepareCall("{call getPayments()}");){
			try (ResultSet rs = cs.executeQuery();){
				while(rs.next()) {
					Payment payment = new Payment(
								rs.getString("payment_id"),
								rs.getString("order_id"),
								rs.getString("user_id"),
								rs.getDouble("amount"),
								rs.getTimestamp("payment_date"),
								Payment.PaymentMethod.fromString(rs.getString("payment_method"))
							);
					
					payments.add(payment);
				}
			}
		}
		return payments;
	}
	
	
	public Payment getPayment(Connection conn, String payment_id) throws SQLException {
		Payment payment = null;
		try (CallableStatement cs = conn.prepareCall("{call getPayment(?)}");){
			cs.setString(1, payment_id);
			try (ResultSet rs = cs.executeQuery();){
				if (rs.next()) {
					payment = new Payment(
							rs.getString("payment_id"),
							rs.getString("order_id"),
							rs.getString("user_id"),
							rs.getDouble("amount"),
							rs.getTimestamp("payment_date"),
							Payment.PaymentMethod.fromString(rs.getString("payment_method"))
						);
				}
			}
		}
		return payment;
	}
	
	public boolean updateStockAfterPayment(Connection conn, String order_id) throws SQLException {
		try (CallableStatement cs = conn.prepareCall("{call updateStockAfterPayment(?)}");) {
			cs.setString(1, order_id);
			return cs.executeUpdate()>0;
		}
	}
}
