package com.switchbit.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.*;
import com.switchbit.dao.*;
import com.switchbit.model.*;
import com.switchbit.service.*;

/**
 * Servlet implementation class AdminHomeController
 */
@WebServlet("/admin/home")
public class AdminHomeController extends HttpServlet {
	private static final long serialVersionUID = 1L;
	ProductService productService;
	PaymentService paymentService;
	
	public void init() throws ServletException{
		super.init();
		productService = new ProductService();
		paymentService = new PaymentService();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		Admin admin = (Admin) request.getSession().getAttribute("admin");
		
		if (admin==null) {
			response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
			return;
		}
		
		try {
			
			request.setAttribute("low-stock-product",productService.getLowStockProduct());
			request.setAttribute("categories", productService.getCategories());
			request.setAttribute("totalItemSold",paymentService.getTotalItemSoldToday());
			request.setAttribute("totalSales",paymentService.getTotalSalesToday());
			request.getRequestDispatcher("/admin/admin-dashboard.jsp").forward(request, response);
	
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/admin-dashboard.jsp");
		}
	}
	

}
