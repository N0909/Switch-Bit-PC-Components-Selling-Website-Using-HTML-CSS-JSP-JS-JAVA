package com.switchbit.controller.user;

import jakarta.servlet.http.HttpServlet;
import java.io.IOException;
import jakarta.servlet.Servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
/**
 * Servlet implementation class UserLogoutServlet
 */
//@WebServlet("/user/logout")
public class UserLogoutServlet extends HttpServlet implements Servlet {
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession(false);
		if (session!=null) {
			session.invalidate();
		}
		
		response.sendRedirect(request.getContextPath()+ "/home");
	}

}
