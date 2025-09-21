package com.switchbit.controller.user;

import java.io.IOException;

import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.InvalidUserException;
import com.switchbit.service.UserService;
import com.switchbit.model.User;

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
//@WebServlet("/user/login")  // you can map in web.xml instead
public class UserLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userService = new UserService(); // initialize service
    }

  
	@Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Collect login form data
        String identifier = request.getParameter("user-identifier");
        String password = request.getParameter("user-password");
        String referer = request.getParameter("page-referer");        
        HttpSession session = request.getSession(false);
 
        try {
        	
        	// 2. Verify user using service
            User user = userService.verifyUser(identifier, password);
            
            

            // 3. If verified, create session and store user
            if (session!=null)
            	session.setAttribute("user", user);

            if (referer.split("/")[referer.split("/").length-1].equals("signin.jsp")) {
            	response.sendRedirect(request.getContextPath()+"/home");
            }
            else if (referer!=null && !"null".equals(referer)) {
            	response.sendRedirect(referer);
            }
            else {
            	response.sendRedirect(request.getContextPath()+"/home");
            }
            // 4. Redirect to success/dashboard page

        } catch (InvalidUserException e) {
            // User not found
        	if (session!=null)
        		session.setAttribute("errorMessage", "No user found with: " + identifier);
            response.sendRedirect(request.getContextPath()+"/signin.jsp");
        } catch (AuthenticationException e) {
            // Password invalid
        	if (session!=null)
        		session.setAttribute("errorMessage", "Invalid Password, try again");
            response.sendRedirect(request.getContextPath()+"/signin.jsp");

        } catch (DataAccessException e) {
            // DB/connection error
        	if (session!=null)
        		session.setAttribute("errorMessage", "Internal error. Please try again later.");
        	response.sendRedirect(request.getContextPath()+"/signin.jsp");
        }
    }
}
