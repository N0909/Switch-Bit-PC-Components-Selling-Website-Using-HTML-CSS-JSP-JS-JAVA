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
import com.switchbit.dto.*;

/**
 * Servlet implementation class DeleteCartItemServlet
 */
//@WebServlet("/deleteCartItem")
public class DeleteCartItemServlet extends HttpServlet {
	private CartService service;

	@Override
	public void init() throws ServletException{
		super.init();
		this.service = new CartService();
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String cart_item_id = request.getParameter("cart-item-id");
		CartItem cartItem = new CartItem();
		cartItem.setCart_item_id(cart_item_id);
		Cart cart = (Cart) request.getSession().getAttribute("userCart");
		try {
			boolean deleted = service.deleteCartItem(cartItem);
			
			if (deleted) {
				request.getSession().setAttribute("successMessage", "item removed from cart");
				if (cart!=null) {
					request.getSession().setAttribute("total-item",service.getTotalItems(cart));
				}
				response.sendRedirect(request.getContextPath()+"/cart");
			}else {
				request.getSession().setAttribute("successMessage", "no item to remove");
				if (cart!=null) {
					request.getSession().setAttribute("total-item",service.getTotalItems(cart));
				}
				response.sendRedirect(request.getContextPath()+"/cart");
			}
		}catch(DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/cart");
		}catch(RollBackException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/cart");
		}catch(CloseConnectionException e) {
			e.printStackTrace();
		}
	}

}
