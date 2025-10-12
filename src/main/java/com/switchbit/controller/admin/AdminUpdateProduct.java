package com.switchbit.controller.admin;

import java.io.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.model.*;
import com.switchbit.service.*;



@MultipartConfig
@WebServlet("/admin/product/update")
public class AdminUpdateProduct extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ProductService productService;
	
	public void init() throws ServletException {
		super.init();
		productService = new ProductService();
	}
   
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String product_id = request.getParameter("product-id");
		String product_name = request.getParameter("product-name");
		String product_description = request.getParameter("product-description");
		double product_price = Double.parseDouble(request.getParameter("product-price"));
		int product_stock = Integer.parseInt(request.getParameter("stock-quantity"));
		String category_id = request.getParameter("category-id");
		
		String referer = request.getHeader("referer");
		
		
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
			
			product.setProduct_id(product_id);
			product.setProduct_name(product_name);
			product.setDescription(product_description);
			product.setPrice(product_price);
			product.setStock_quantity(product_stock);
			product.setCategory(category);
			
			if (dbPath!=null) {				
				product.setProduct_img(dbPath);
			}
			
			productService.updateProduct(product);
			request.getSession().setAttribute("successMessage", product_name+" updated successfully");
			
			response.sendRedirect(referer);
			
			} catch (DataAccessException e) {
				request.getSession().setAttribute("errorMessage", e.getMessage());
				response.sendRedirect(referer);
			} catch (CloseConnectionException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (RollBackException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		
		
		
		
		
	}

}
