package com.switchbit.controller.order;

import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.*;

import com.switchbit.model.*;
import com.switchbit.service.OrderService;
import com.switchbit.exceptions.*;
import com.switchbit.dto.*;

@WebServlet("/orders/orderdetail")
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
			request.setAttribute("order-details", service.getOrderDetails(order_id));;
			request.getRequestDispatcher("/order-details.jsp").forward(request, response);
		} catch (DataAccessException e) {
			e.printStackTrace();
			String referer = request.getHeader("referer");
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(referer);
		}
	}

}
