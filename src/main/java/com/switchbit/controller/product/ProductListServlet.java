package com.switchbit.controller.product;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.*;

import com.switchbit.model.Product;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.model.Category;
import com.switchbit.service.ProductService;
import com.switchbit.util.PaginatedResult;

/**
 * Fetching all the page from database
 */
@WebServlet("/product/products")
public class ProductListServlet extends HttpServlet {
	private ProductService productService;
	
	// initializing required objects 
	@Override
	public void init() throws ServletException {
		super.init();
		this.productService = new ProductService();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// initializing page and pageSize
		int page = 1;
		int pageSize = 5;
		
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
			// Fetching Products from database for current page 
			PaginatedResult<Product> result = productService.getProductsPage(page, pageSize);
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
