package com.switchbit.controller.cart;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.*;

import com.switchbit.model.*;
import com.switchbit.service.CartService;
import com.switchbit.exceptions.*;
import com.switchbit.dto.*;
/**
 * Servlet implementation class UpdateCartItemServlet
 */
@WebServlet("/cart/updateCartItemQuantity")
public class UpdateCartItemQuantityServlet extends HttpServlet {
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
		int quantity = Integer.parseInt(request.getParameter("cart-item-quantity"));
		CartItem cart_item = new CartItem();
		cart_item.setCart_item_id(cart_item_id);
		cart_item.setQuantity(quantity);
		
		try {
			boolean updated = service.updateCartItemQuantity(cart_item);
		
			if (updated) {
				response.sendRedirect(request.getContextPath()+"/cart");
			}
		}catch(DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/cart");
		} catch (RollBackException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
