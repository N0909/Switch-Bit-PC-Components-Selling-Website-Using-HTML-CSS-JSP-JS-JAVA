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

public class OrderController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService service;

	@Override
	public void init() throws ServletException{
		super.init();
		this.service = new OrderService();
	}
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		User user = null;
		if (session!=null)		
			user = (User) request.getSession().getAttribute("user");
		if (user==null)
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
		try {
			List<Order> orders = service.getOrders(user);
			session.setAttribute("orders", orders);
			response.sendRedirect(request.getContextPath()+"/orders.jsp");
		}catch(DataAccessException e) {
			session.setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/orders.jsp");
		}
	}

}
