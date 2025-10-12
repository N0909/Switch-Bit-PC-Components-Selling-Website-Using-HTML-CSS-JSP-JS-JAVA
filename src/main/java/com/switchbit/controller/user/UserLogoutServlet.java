package com.switchbit.controller.user;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import jakarta.servlet.Servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.*;
/**
 * Handles Logout request
 */

@WebServlet("/user/logout")
public class UserLogoutServlet extends HttpServlet implements Servlet {
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session!=null) {
			// invalidate session
			session.invalidate();
		}
		
		// redirect to homepage
		response.sendRedirect(request.getContextPath()+ "/home");
	}

}
