package com.switchbit.controller.admin;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.service.*;

@MultipartConfig
@WebServlet("/admin/product/add")
public class AdminAddProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService productService;
	
	public void init() throws ServletException{
		super.init();
		productService = new ProductService();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		String product_name = request.getParameter("product-name");
		String product_description = request.getParameter("product-description");
		double product_price = Double.parseDouble(request.getParameter("product-price"));
		int product_stock = Integer.parseInt(request.getParameter("stock-quantity"));
		String category_id = request.getParameter("category-id");
		
		Part filePart = request.getPart("product-img");
		String filename = filePart.getSubmittedFileName();
		String dbPath = null;
		
		Category category;
		try {
			category = productService.getCategory(category_id);
			
			if (filename!=null && !filename.isEmpty()) {
				
			
			
				String uploadPath = getServletContext().getRealPath("images/Products/"+category.getCategory_name());
			
				System.out.println(uploadPath);
			
				File uploadDir = new File(uploadPath);
				if (!uploadDir.exists()) uploadDir.mkdirs();
			
				String filePath = uploadPath + File.separator + filename;
				filePart.write(filePath);
				
				dbPath = "images/Products/" + category.getCategory_name() + "/" + filename;
				
			}
			
			Product product = new Product();
			
			product.setProduct_name(product_name);
			product.setDescription(product_description);
			product.setPrice(product_price);
			product.setStock_quantity(product_stock);
			product.setCategory(category);
			
			if (dbPath!=null) {				
				product.setProduct_img(dbPath);
			}
			
			productService.addProduct(product);
			request.getSession().setAttribute("successMessage", product_name+" added successfully");
			response.sendRedirect(request.getContextPath()+"/admin/products");
			
			} catch (DataAccessException e) {
				request.getSession().setAttribute("errorMessage", e.getMessage());
				response.sendRedirect(request.getContextPath()+"/admin/products");
			} catch (CloseConnectionException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (RollBackException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
	}

}
