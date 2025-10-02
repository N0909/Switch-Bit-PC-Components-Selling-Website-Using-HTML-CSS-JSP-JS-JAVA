package com.switchbit.controller.order;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.switchbit.model.*;
import com.switchbit.service.OrderService;
import com.switchbit.exceptions.*;
import com.switchbit.dto.*;

public class OrderDetailsController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService service;

	@Override
	public void init() throws ServletException{
		super.init();
		this.service = new OrderService();
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_id = request.getParameter("order-id");
		
		try {
			List<OrderItemDTO> items =null;
			Order order = service.getOrder(order_id);
			if (order!=null) {				
				items = service.getOrderItems(order);
				request.setAttribute("order", order);
			}
			
			request.setAttribute("order-items", items);
			request.getRequestDispatcher("/order-details.jsp").forward(request, response);
		} catch (DataAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
