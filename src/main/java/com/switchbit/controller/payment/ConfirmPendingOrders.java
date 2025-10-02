package com.switchbit.controller.payment;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.model.*;
import com.switchbit.dao.*;
import com.switchbit.exceptions.*;
import com.switchbit.service.*;
import com.switchbit.dto.*;


public class ConfirmPendingOrders extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	private PaymentService paymentService;
	
	public void init() throws ServletException{
		this.orderService = new OrderService();
		this.paymentService = new PaymentService();
	}
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_id = request.getParameter("order-id");
		
		Order order = new Order();
		order.setOrder_id(order_id);
		
		try {
			List<OrderItemDTO> items = orderService.getOrderItems(order);
			for (OrderItemDTO item : items) {
				if (item.getProduct().getStock_quantity()<=0) {
					request.getSession().setAttribute("errorMessage", item.getProduct().getProduct_name()+" is currently not available in stock. Sorry");
					response.sendRedirect(request.getContextPath()+"/orders.jsp");
					return;
				}
			}
			
			request.getSession().setAttribute("order",orderService.getOrder(order_id));
			request.getSession().setAttribute("items",items);
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
		
	}

}
