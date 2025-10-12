package com.switchbit.controller.product;

import java.io.IOException;


import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.model.Product;
import com.switchbit.service.ProductService;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;
/**
 * Fetches all the product by category
 */

@WebServlet("/product/productBycategory")
public class ProductByCategoryServlet extends HttpServlet {
	private ProductService service;

	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// initializing page and pageSize
		int page = 1;
		int pageSize = 5;
		
		// collecting input from client
		String category_id = request.getParameter("category-id");
		
		// collecting requested page from client
		String pageParam = request.getParameter("page");
	    if (pageParam != null) {
	        try {
	        	// parsing integer from string
	            page = Integer.parseInt(pageParam);
	        } catch (NumberFormatException nfe) {
	            System.out.println("Invalid page parameter: " + pageParam);
	        }
	    }
	    
	    RequestDispatcher requestdispatcher;
		
		try {
			// Fetching Products from database for current page by mentioned category_id
			PaginatedResult<Product> result = service.getProductsByCategoryPage(category_id,page, pageSize);
			// respond to product.jsp to display 
			request.setAttribute("productsPage", result);
			requestdispatcher = request.getRequestDispatcher("/product.jsp");
			requestdispatcher.forward(request, response);
		}catch(DataAccessException e) {
			request.setAttribute("errorMessage", "failed to get products" + e.getMessage());
			requestdispatcher = request.getRequestDispatcher("/product.jsp");
			requestdispatcher.forward(request, response);
		}
		
	}

}
