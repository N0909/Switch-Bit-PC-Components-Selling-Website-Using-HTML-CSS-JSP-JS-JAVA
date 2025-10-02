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


public class CheckoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private OrderService orderService;
	private CartService cartService;

	@Override
	public void init() throws ServletException{
		super.init();
		this.orderService = new OrderService();
		this.cartService = new CartService();
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) request.getSession().getAttribute("user");
		
		if (user==null) {
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
		}
		
		try {
			
			CartDTO cart = cartService.getCart(user);
			String order_id = orderService.placeCartOrder(cart);
			Order order = orderService.getOrder(order_id);
			List<OrderItemDTO> items = orderService.getOrderItems(order);
			int totalcartitems = cartService.getTotalItems(cart.getCart());
			
			request.getSession().setAttribute("order", order);
			request.getSession().setAttribute("items", items);
			
			request.getSession().setAttribute("total-item", totalcartitems);
			response.sendRedirect(request.getContextPath()+"/checkout.jsp");
			
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", "Request failed try again later");
		} catch (RollBackException e) {
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoCartFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		
	}
}
