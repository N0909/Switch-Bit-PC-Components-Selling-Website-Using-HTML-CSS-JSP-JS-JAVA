package com.switchbit.controller;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


import com.switchbit.service.*;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.model.*;
/**
 * Servlet implementation class HomeController
 */
//@WebServlet("/home")
public class HomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService product_service;
	
	public void init() throws ServletException{
		super.init();
		product_service = new ProductService();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		try {
			List<Product> products = product_service.getProducts(5);
			List<Category> categories = product_service.getCategories();
			
			request.setAttribute("products", products);
			request.setAttribute("categories", categories);
			request.getRequestDispatcher("/index.jsp").forward(request, response);
			
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", "Failed to fetch HomePage");
			response.sendRedirect(request.getContextPath()+"/index.jsp");
		}
				
	}

}
