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
 * Servlet implementation class ProductByCategoryServlet
 */
public class ProductByCategoryServlet extends HttpServlet {
	private ProductService service;

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
		
		String category_id = request.getParameter("category-id");
		
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
			PaginatedResult<Product> result = service.getProductsByCategoryPage(category_id,page, pageSize);
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
