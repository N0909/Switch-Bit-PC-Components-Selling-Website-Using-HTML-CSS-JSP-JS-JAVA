package com.switchbit.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.exceptions.*;
import com.switchbit.model.Admin;
import com.switchbit.service.AdminService;


public class AdminSignIn extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private AdminService adminService;
	
	public void init() throws ServletException {
		super.init();
		adminService = new AdminService();
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String admin_identifier = request.getParameter("admin_identifier");
		String password = request.getParameter("password");
		Admin admin = null;
		

		try {
			admin = adminService.verifyAdmin(admin_identifier, password);
			request.getSession().setAttribute("admin", admin);
			response.sendRedirect(request.getContextPath()+"/admin/home");
		} catch (InvalidUserException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		} catch (AuthenticationException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		}
		
		
	}

}
