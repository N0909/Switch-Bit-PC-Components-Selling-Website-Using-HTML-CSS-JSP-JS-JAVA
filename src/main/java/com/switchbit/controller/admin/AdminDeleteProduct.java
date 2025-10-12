package com.switchbit.controller.admin;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.service.*;

@WebServlet("/admin/product/delete")
public class AdminDeleteProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService productService;

	public void init() throws ServletException {
		productService = new ProductService();
	}
	
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String product_id = request.getParameter("product-id");
		
		Product product = new Product();
		product.setProduct_id(product_id);
		
		try {
			productService.deleteProduct(product);
			
			request.getSession().setAttribute("successMessage", "product with " + product_id+ " deleted successfully");
			response.sendRedirect(request.getContextPath()+"/admin/products");
			
		} catch (DataAccessException e) {
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/products");
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		} catch (RollBackException e) {
			e.printStackTrace();
		}
		
	}

}
