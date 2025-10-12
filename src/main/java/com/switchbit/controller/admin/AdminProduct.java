package com.switchbit.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.DataAccessException;
import com.switchbit.service.ProductService;


@WebServlet("/admin/products")
public class AdminProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService productService;
	
	public void init() throws ServletException {
		super.init();
		productService = new ProductService();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			
			request.setAttribute("products", productService.getProducts(0));
			request.setAttribute("categories", productService.getCategories());
			request.getRequestDispatcher("admin-manage-products.jsp").forward(request, response);
		} catch (DataAccessException e) {
			e.printStackTrace();
		}
	}

	

}
