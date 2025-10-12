package com.switchbit.controller.product;

import java.io.IOException;


import com.switchbit.service.ProductService;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.model.Product;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;
/**
 * Fetch ProductByProductId from database
 */

@WebServlet("/product/getProduct")
public class GetProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService service;

	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// collecting input from form
		String product_id = request.getParameter("product-id");
		
		
		try {
			// fetching product from db
			Product product = service.getProduct(product_id);
			// forwarding product object to product-details.jsp
			request.setAttribute("product", product);
			request.getRequestDispatcher("/product-details.jsp").forward(request, response);
		}catch(DataAccessException e) {
			// error message
			request.setAttribute("errorMessage", e.getMessage());
			request.getRequestDispatcher("/product-details.jsp").forward(request, response);
		}
		
	}


}
