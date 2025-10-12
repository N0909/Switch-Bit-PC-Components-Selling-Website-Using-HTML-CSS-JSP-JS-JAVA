package com.switchbit.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.DataAccessException;
import com.switchbit.model.*;
import com.switchbit.service.*;

@WebServlet("/admin/orders/orderdetails")
public class AdminOrderDetails extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	
	public void init() throws ServletException {
		super.init();
		orderService = new OrderService();
	}
	
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_id = request.getParameter("order-id");

		try {
			request.setAttribute("order-details", orderService.getOrderDetails(order_id));
			request.getRequestDispatcher("/admin/admin-order-details.jsp").forward(request, response);
		} catch (DataAccessException e) {
			String referer = request.getHeader("referer");
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(referer);
		}	
		
	}

	

}
