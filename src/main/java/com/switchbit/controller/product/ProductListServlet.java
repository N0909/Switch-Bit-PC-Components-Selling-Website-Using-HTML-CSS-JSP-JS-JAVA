package com.switchbit.controller.product;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.RequestDispatcher;

import com.switchbit.model.Product;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.model.Category;
import com.switchbit.service.ProductService;
import com.switchbit.util.PaginatedResult;

/**
 * Servlet implementation class ProductListServlet
 */
//@WebServlet("/product/products")
public class ProductListServlet extends HttpServlet {
	private ProductService productService;
	
	@Override
	public void init() throws ServletException {
		super.init();
		this.productService = new ProductService();
	}
	
	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		int page = 1;
		int pageSize = 5;
		
		
		String pageParam = request.getParameter("page");
	    if (pageParam != null) {
	        try {
	            page = Integer.parseInt(pageParam);
	        } catch (NumberFormatException nfe) {
	            System.out.println("Invalid page parameter: " + pageParam);
	        }
	    }

	    
	    // need  to modify this part
		RequestDispatcher requestdispatcher;
		
		try {
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
