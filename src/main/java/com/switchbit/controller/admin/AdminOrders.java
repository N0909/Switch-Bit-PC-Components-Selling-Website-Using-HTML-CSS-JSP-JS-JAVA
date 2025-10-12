package com.switchbit.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.sql.Date;

import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.model.*;
import com.switchbit.service.*;

@WebServlet("/admin/orders")
public class AdminOrders extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
    
    public void init() throws ServletException {
    	super.init();
    	orderService = new OrderService();
    	
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_status = request.getParameter("order-status");
		try {
			if (order_status==null) {
				request.setAttribute("orders", orderService.getOrders());
				request.getRequestDispatcher("admin-manage-orders.jsp").forward(request, response);
			}else {
				request.setAttribute("order-stat", order_status);
				request.setAttribute("orders", orderService.getOrders(order_status));
				request.getRequestDispatcher("admin-manage-orders.jsp").forward(request, response);
			}
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_id = request.getParameter("order-id");
		String order_status = request.getParameter("order-status");
		Date date = Date.valueOf(request.getParameter("delivery-date"));
		
		try {
			orderService.updateOrder(order_id, date, order_status);
			
			request.getSession().setAttribute("successMessage", "order details with order-id: "+order_id+" updated successfully");
			response.sendRedirect(request.getContextPath()+"/admin/orders");
		} catch (RollBackException e) {
			e.printStackTrace();
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e);
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		}
		
	}

}
