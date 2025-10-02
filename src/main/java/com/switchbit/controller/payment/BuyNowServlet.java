package com.switchbit.controller.payment;

import java.io.IOException;
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
 * Servlet implementation class BuyNowServlet
 */
public class BuyNowServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	private ProductService productService;

	@Override
	public void init() throws ServletException{
		super.init();
		this.orderService = new OrderService();
		this.productService = new ProductService();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String product_id = request.getParameter("product-id");
		int quantity = Integer.parseInt(request.getParameter("product-quan"));
		User user = (User) request.getSession().getAttribute("user");
		
		if (user==null) {
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
		}
		
		Product product = null;
		
		try {
			product = productService.getProduct(product_id);
			String order_id = orderService.placeOrder(user, product, quantity);
			Order order = orderService.getOrder(order_id);
			List<OrderItemDTO> items = orderService.getOrderItems(order);
			
			request.getSession().setAttribute("order", order);
			request.getSession().setAttribute("items", items);
			
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
			
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", "Request failed try again later");
		} catch (RollBackException e) {
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		
	}

}
