package com.switchbit.controller.cart;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.switchbit.model.*;
import com.switchbit.service.CartService;
import com.switchbit.exceptions.*;

/**
 * Servlet implementation class CartController
 */
//@WebServlet("/cart")
public class CartController extends HttpServlet {
	private CartService service;

	@Override
	public void init() throws ServletException{
		super.init();
		this.service = new CartService();
	}
	
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		HttpSession session = request.getSession(false);
		User user = null;
		if (session!=null) {
			user = (User) session.getAttribute("user");
		}
		
		if (user==null) {
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
		}
		
		try {
			Cart cart = service.getCart(user);
			session.setAttribute("cart", cart);
			
			response.sendRedirect(request.getContextPath()+"/cart.jsp");
		}catch (NoCartFoundException nc) {
			session.setAttribute("errorMessage", nc.getCause());
			response.sendRedirect(request.getContextPath()+"/cart.jsp");
		}catch (DataAccessException da) {
			session.setAttribute("errorMessage", da.getCause());
			response.sendRedirect(request.getContextPath()+"/cart.jsp");
		}
	}
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
