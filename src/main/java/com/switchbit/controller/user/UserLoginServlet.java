package com.switchbit.controller.user;

import java.io.IOException;

import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.InvalidUserException;
import com.switchbit.exceptions.NoCartFoundException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.service.*;
import com.switchbit.model.*;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Handles login requests for users.
 * Responsibilities:
 * 1. Accept identifier (email/phone/userId) and password from login form.
 * 2. Call UserService to verify credentials.
 * 3. On success → create session and redirect.
 * 4. On failure → return error message to login.jsp.
 */
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private CartService cartService;

    @Override
    public void init() throws ServletException {
    	// initialize service
        super.init();
        this.userService = new UserService();
        this.cartService = new CartService();
    }

  
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Collect login form data
        String identifier = request.getParameter("user-identifier");
        String password = request.getParameter("user-password");
        // referer to identify from where request come from
        String referer = request.getParameter("page-referer");        
        HttpSession session = request.getSession(false);
 
        try {
        	
        	//  Verify user using service
            User user = userService.verifyUser(identifier, password);
            // Get user cart
			Cart cart = cartService.getUserCart(user);
			
			// if cart is null then create a new cart
			if (cart.getCart_id()==null || cart==null) {
				try {
					cartService.addCart(user);
					cart =  cartService.getUserCart(user);
				} catch (RollBackException e) {
					e.printStackTrace();
				} catch (CloseConnectionException e) {
					e.printStackTrace();
				}
			}
			if (cart.getCart_id()!=null)
				System.out.println(cartService.getTotalItems(cart));
				session.setAttribute("total-item", cartService.getTotalItems(cart));
				

            // If verified, create session and store user and cart
            if (session!=null)
            	session.setAttribute("user", user);
            	session.setAttribute("userCart", cart);

            // Check request comes from signup.jsp or signin.jsp (if yes redirect to homepage)
            if (referer.split("/")[referer.split("/").length-1].equals("signin.jsp") || referer.split("/")[referer.split("/").length-1].equals("signup.jsp")) {
            	response.sendRedirect(request.getContextPath()+"/home");
            }
            // check if referer is not null if not then redirect to refering page
            else if (referer!=null && !"null".equals(referer)) {
            	response.sendRedirect(referer);
            }
            // default page 
            else {
            	response.sendRedirect(request.getContextPath()+"/home");
            }

        } catch (InvalidUserException e) {
            // User not found
        	if (session!=null)
        		session.setAttribute("errorMessage", "No user found with: " + identifier);
            response.sendRedirect(request.getContextPath()+"/signin.jsp");
        } catch (AuthenticationException e) {
            // Password invalid
        	if (session!=null)
        		session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath()+"/signin.jsp");

        } catch (DataAccessException e) {
        	e.printStackTrace();
            // DB/connection error
        	if (session!=null)
        		session.setAttribute("errorMessage", e.getMessage());
        	response.sendRedirect(request.getContextPath()+"/signin.jsp");
        }
    }
}
