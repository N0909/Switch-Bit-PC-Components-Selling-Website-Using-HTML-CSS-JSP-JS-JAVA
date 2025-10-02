package com.switchbit.controller.order;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.service.OrderService;


public class CancelOrderStatus extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	

    public void init() throws ServletException{
    	super.init();
    	this.orderService = new OrderService();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String order_id = request.getParameter("order-id");
		
		try {
			orderService.updateOrderStatus(order_id, "CANCELLED");
			request.getSession().setAttribute("successMessage", "Order With Id: "+order_id+" is cancelled");
			response.sendRedirect(request.getContextPath()+"/orders");
		} catch (RollBackException e) {
			e.printStackTrace();
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getCause());
			response.sendRedirect(request.getContextPath()+"/orders.jsp");
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		}
		
		
	}

}
