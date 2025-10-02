package com.switchbit.controller.cart;

import java.io.IOException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.switchbit.model.*;
import com.switchbit.service.CartService;
import com.switchbit.exceptions.*;
import com.switchbit.dto.*;

/**
 * Servlet implementation class CartController
 */
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
			CartDTO cart = service.getCart(user);
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
		HttpSession session = request.getSession(false);
		String referer = request.getHeader("referer");
		User user = null;
		Cart cart = null;
		if (session!=null) {
			user = (User) session.getAttribute("user");
			cart = (Cart) session.getAttribute("userCart");
		}
		
		if (user==null) {
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
		}
				
		try {
			String product_id = request.getParameter("product_id");
			int quantity = Integer.parseInt(request.getParameter("product_quan"));
			CartItem item = new CartItem();
			item.setProduct_id(product_id);
			item.setQuantity(quantity);
			service.addCartitem(cart, item);
			
			session.setAttribute("successMessage", "Product added to cart");
			session.setAttribute("total-item",service.getTotalItems(cart));
			response.sendRedirect(referer);
		}catch(DataAccessException e) {
			session.setAttribute("errorMessage", "failed to access cart");
			response.sendRedirect(referer);
		}catch(RollBackException e) {
			e.printStackTrace();
		}catch(CloseConnectionException e) {
			e.printStackTrace();
		} catch (DuplicateResourceException e) {
			// TODO Auto-generated catch block
			session.setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(referer);
		}
	}
}
