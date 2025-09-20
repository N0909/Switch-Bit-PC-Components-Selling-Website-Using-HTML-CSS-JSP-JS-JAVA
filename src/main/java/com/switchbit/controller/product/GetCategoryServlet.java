package com.switchbit.controller.product;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.model.Category;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;
import com.switchbit.service.ProductService;

/**
 * Servlet implementation class GetCategoryServlet
 */
//@WebServlet("/product/category")
public class GetCategoryServlet extends HttpServlet {
	private ProductService service;
	
	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			List<Category> category = service.getCategories();
			request.setAttribute("category", category);
			request.getRequestDispatcher("/categories.jsp").forward(request, response);
		}catch(DataAccessException e){
			request.setAttribute("errorMessage", "Failed to get categories");
			request.getRequestDispatcher("/error.jsp").forward(request, response);
		}
	}

}
