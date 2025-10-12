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


@WebServlet("/product/searchproduct")
public class SearchProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService service;
	
	// initializing required objects 
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// initializing page and pageSize
		int page = 1;
		int pageSize = 5;
		
		// collecting search-query from client
		String search_query = request.getParameter("search_query");
		
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
			// Fetching Products from database for current page  and mentioned search_query
			PaginatedResult<Product> result = service.searchProductsPage(search_query,page, pageSize);
			request.setAttribute("productsPage", result);
			request.setAttribute("query", search_query);
			requestdispatcher = request.getRequestDispatcher("/search-products.jsp");
			requestdispatcher.forward(request, response);
		}catch(DataAccessException e) {
			request.setAttribute("errorMessage", "failed to get products" + e.getMessage());
			requestdispatcher = request.getRequestDispatcher("/search-products.jsp");
			requestdispatcher.forward(request, response);
		}
	}

}
