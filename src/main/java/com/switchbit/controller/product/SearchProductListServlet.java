package com.switchbit.controller.product;

import java.io.IOException;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.model.Product;
import com.switchbit.service.ProductService;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;

/**
 * Servlet implementation class SearchProductListServlet
 */
//@WebServlet("/product/searchproduct")
public class SearchProductListServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService service;
	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int page = 1;
		int pageSize = 5;
		
		String search_query = request.getParameter("search_query");
		
		String pageParam = request.getParameter("page");
	    if (pageParam != null) {
	        try {
	            page = Integer.parseInt(pageParam);
	        } catch (NumberFormatException nfe) {
	            System.out.println("Invalid page parameter: " + pageParam);
	        }
	    }
	    
	    
	    // need to modify this part
	    RequestDispatcher requestdispatcher;
		
		try {
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
