package com.switchbit.controller.payment;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

import com.switchbit.service.*;
import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.dto.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
/**
 * Servlet implementation class ProcessPaymentServlet
 */

public class ProcessPaymentServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	private PaymentService paymentService;

	@Override
	public void init() throws ServletException{
		super.init();
		this.orderService = new OrderService();
		this.paymentService = new PaymentService();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) request.getSession().getAttribute("user");
		Order order = (Order) request.getSession().getAttribute("order");
		Payment.PaymentMethod method =  Payment.PaymentMethod.fromString(request.getParameter("paymentType"));
		
		Payment payment = new Payment();
		payment.setUserId(user.getUserId());
		payment.setOrderId(order.getOrder_id());
		payment.setPaymentMethod(method);
		payment.setAmount(order.getTotal_amount());
		
		try {
			
			paymentService.processPayment(payment);
			List<OrderItemDTO> dto = orderService.getOrderItems(order);	
			
			request.getSession().setAttribute("payment", payment);
			request.getSession().setAttribute("orderitems", dto);
			response.sendRedirect(request.getContextPath()+"/payment-success.jsp");
		} catch (RollBackException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		} catch (DuplicateResourceException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
		}

	}

}
