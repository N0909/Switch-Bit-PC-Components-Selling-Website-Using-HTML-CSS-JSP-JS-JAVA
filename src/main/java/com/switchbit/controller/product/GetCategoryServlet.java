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
 * Handles request for fetching categories from db
 */
public class GetCategoryServlet extends HttpServlet {
	private ProductService service;
	
	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			// fetch category from db
			List<Category> category = service.getCategories();
			// set on request attribute
			request.setAttribute("category", category);
			// forward it to categories
			request.getRequestDispatcher("/categories.jsp").forward(request, response);
		}catch(DataAccessException e){
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/error.jsp");
		}
	}

}
