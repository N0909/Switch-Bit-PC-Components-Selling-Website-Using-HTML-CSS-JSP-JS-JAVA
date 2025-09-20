package com.switchbit.controller.product;

import java.io.IOException;

import com.switchbit.service.ProductService;

import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import com.switchbit.model.Product;
import com.switchbit.util.*;
import com.switchbit.exceptions.*;
/**
 * Servlet implementation class GetProductServlet
 */
//@WebServlet("/product/getProduct")
public class GetProductServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService service;

	public void init(ServletConfig config) throws ServletException {
		super.init();
		this.service = new ProductService();
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String product_id = request.getParameter("product-id");
		
		
		try {
			Product product = service.getProduct(product_id);
			request.setAttribute("product", product);
			request.getRequestDispatcher("/productDetails.jsp").forward(request, response);
		}catch(DataAccessException e) {
			request.setAttribute("errorMessage", "failed to retreive product");
			request.getRequestDispatcher("/productDetails.jsp").forward(request, response);
		}
		
	}


}
