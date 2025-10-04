<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="java.util.List" %>

<%
	Admin admin = (Admin) session.getAttribute("admin");

	if (admin==null){
		response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		return;
	}
	
	String errorMessage = (String) session.getAttribute("errorMessage");
	session.removeAttribute("errorMessage");
	
	
	List<Product> lowStockProduct = (List<Product>) request.getAttribute("low-stock-product");
	List<Category> categories = (List<Category>) request.getAttribute("categories");
	Integer totalItemSold = (Integer) request.getAttribute("totalItemSold");
	Double totalSales = (Double) request.getAttribute("totalSales");
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - SwitchBit</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
        }
        .sidebar {
            height: 100vh;
            width: 220px;
            position: fixed;
            left: 0;
            top: 0;
            background: #23272b;
            color: #fff;
            padding-top: 30px;
        }
        .sidebar h2 {
            text-align: center;
            margin-bottom: 40px;
        }
        .sidebar a {
            display: block;
            color: #fff;
            padding: 15px 30px;
            text-decoration: none;
            font-size: 17px;
        }
        .sidebar a:hover {
            background: #374151;
        }
        .main-content {
            margin-left: 240px;
            padding: 30px;
        }
        .card-container {
            display: flex;
            gap: 30px;
        }
        .card {
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            flex: 1;
            text-align: center;
            padding: 35px 0;
            font-size: 22px;
        }
        .card-title {
            font-size: 18px;
            color: #888;
            margin-bottom: 10px;
        }
        .low-stock-table {
            width: 60%;
            margin-top: 40px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.04);
            padding: 20px;
            font-size: 17px;
            text-align: center;
        }
        .low-stock-table th, .low-stock-table td {
            padding: 10px 14px;
        }
        .low-stock-table th {
            background: #f5f5f5;
        }
        .low-stock-table tr:nth-child(even) {
            background: #f9f9f9;
        }
        .action-btn {
            border: none;
            border-radius: 6px;
            padding: 9px 18px;
            cursor: pointer;
            font-size: 15px;
            font-weight: 500;
            margin-right: 8px;
            box-shadow: 0 1px 4px rgba(0,0,0,0.08);
            transition: background 0.2s;
        }
        .edit-btn {
            background: #2563eb;
            color: #fff;
        }
        .edit-btn:hover {
            background: #1e40af;
        }
        /* Popup modal styles */
        .modal {
            display: none; 
            position: fixed; 
            z-index: 999; 
            left: 0; top: 0; width: 100%; height: 100%; 
            overflow: auto; 
            background-color: rgba(0,0,0,0.35); 
        }
        .modal-content {
            background-color: #fff;
            margin: 90px auto;
            padding: 35px 30px 30px 30px;
            border-radius: 12px;
            width: 100%;
            max-width: 470px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.16);
            position: relative;
        }
        .close {
            color: #aaa;
            position: absolute;
            right: 18px;
            top: 18px;
            font-size: 28px;
            font-weight: bold;
            cursor: pointer;
        }
        .close:hover { color: #e11d48; }
        .modal-form {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .modal-form label {
            font-size: 16px;
            margin-bottom: 4px;
            color: #23272b;
        }
        .modal-form input, .modal-form textarea, .modal-form select {
            padding: 9px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        .modal-form textarea {
            min-height: 60px;
            resize: vertical;
        }
        .modal-form input[type="file"] {
            padding: 4px;
        }
        .modal-form .img-preview {
            margin-top: 6px;
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 7px;
            border: 1px solid #cbd5e1;
            display: none;
        }
        .modal-form .submit-btn {
            background: #2563eb;
            color: #fff;
            border: none;
            border-radius: 8px;
            padding: 12px 0;
            font-size: 18px;
            font-weight: 500;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 8px;
        }
        .modal-form .submit-btn:hover {
            background: #1e40af;
        }
        @media (max-width: 900px) {
            .main-content { margin-left: 0; }
            .card-container { flex-direction: column; }
            .low-stock-table { width: 100%; }
            .sidebar { width: 100%; height: auto; position: static; }
        }
    </style>
</head>
<body>
    <div class="sidebar">
        <h2>Welcome, <%= admin.getAdmin_username() %></h2>
        <a href="#">Manage Products</a>
        <a href="#">Manage Orders</a>
    </div>
    <div class="main-content">
        <div class="card-container">
            <div class="card">
                <div class="card-title">Total Sales Today</div>
                <div class="card-value">₹ <%= totalSales %></div>
            </div>
            <div class="card">
                <div class="card-title">Total Items Sold Today</div>
                <div class="card-value"><%= totalItemSold %></div>
            </div>
        </div>
        <table class="low-stock-table">
            <caption style="caption-side: top; font-size:20px; margin-bottom:10px; color:#23272b; font-weight:bold;">
                Items with Low Stock
            </caption>
            <thead>
                <tr>
                	<th>ProductId</th>
                    <th>Product Name</th>
                    <th>Stock</th>
                </tr>
            </thead>
            <tbody>
                <% for (Product product : lowStockProduct) { %>
                	<tr>
                		<td><%= product.getProduct_id() %></td>
                		<td><%= product.getProduct_name() %></td>
                		<td><%= product.getStock_quantity() %></td>
                		<td>
                			<button class="action-btn edit-btn" 
                					product-id="<%= product.getProduct_id() %>"
                					product-name="<%= product.getProduct_name() %>"
                					product-description="<%= product.getDescription() %>"
                					product-price = "<%= product.getPrice() %>"
                					product-stock="<%= product.getStock_quantity() %>"
                					product-category="<%= product.getCategory().getCategory_id() %>"
                					product-img="<%=request.getContextPath() %>/<%=product.getProduct_img() %>"
                					onclick="openModal(this)">
                					Edit
                			</button>
                		</td>
                	</tr>
                <% } %>
            </tbody>
        </table>
        <div id="modal" class="modal" style="display:none;" >
        	<div class="modal-content">
        	<span class="close" onclick="closeModal()">&times;</span>
        	<h3 id="modal-title" style="margin-bottom:22px;">Edit Product</h3>
        	<form class="modal-form" id="productForm" action="<%=request.getContextPath() %>/admin/product/update" method="post" enctype="multipart/form-data">
        		<input id="product-id" name="product-id" type="hidden">
        		
                <label for="product-name">Product Name *</label>
                <input type="text" id="product-name" name="product-name" maxlength="150" required>

                <label for="product-description">Description</label>
                <textarea id="product-description" name="product-description"></textarea>

                <label for="product-price">Price *</label>
                <input type="number" id="product-price" name="product-price" min="0" step="0.01" required>

                <label for="stock-quantity">Stock Quantity *</label>
                <input type="number" id="stock-quantity" name="stock-quantity" min="0" required>

                <label for="category-id">Category</label>
                <select id="category-id" name="category-id">
                    <option value="">Select Category</option>
                	<% for (Category category: categories) { %>
                    	<option value="<%=category.getCategory_id()%>"><%=category.getCategory_name() %></option>
                    <% } %>
                </select>

                <label for="product-img">Product Image</label>
                <input type="file" id="product-img" name="product-img" accept="image/*" onchange="previewImage(event)">
                <img id="imgPreview" class="img-preview" src="#" alt="Image Preview">

                <button type="submit" class="submit-btn" id="modal-submit">Save Product</button>
            </form>
        </div>
       </div>	
    </div>
    
    
    <script>
    function openModal(button) {
    	const imgPath = button.getAttribute("product-img");
    	
        document.getElementById('modal').style.display = "block";
        document.getElementById('productForm').style;	
        document.getElementById('imgPreview').style.display = 'none';
        
        document.getElementById('product-id').value = button.getAttribute('product-id');
        document.getElementById('product-name').value = button.getAttribute('product-name');
        document.getElementById('product-description').value = button.getAttribute('product-description');
        document.getElementById('product-price').value = button.getAttribute('product-price');
        document.getElementById('stock-quantity').value = button.getAttribute('product-stock');
        document.getElementById('category-id').value = button.getAttribute('product-category');
        
        
        
        const imgPreview = document.getElementById("imgPreview");
        if (imgPath && imgPath.trim() !== "") {
            imgPreview.src = imgPath;
            imgPreview.style.display = "block";
        } else {
            imgPreview.src = "#";
            imgPreview.style.display = "none";
        }
        
    }
    function closeModal() {
        document.getElementById('modal').style.display = "none";
    }
    // Image preview
    function previewImage(event) {
        const input = event.target;
        const preview = document.getElementById('imgPreview');
        if (input.files && input.files[0]) {
            const reader = new FileReader();
            reader.onload = function(e) {
                preview.src = e.target.result;
                preview.style.display = 'block';
            }
            reader.readAsDataURL(input.files[0]);
        } else {
            preview.src = "#";
            preview.style.display = 'none';
        }
    }
    // Close modal when clicking outside
    window.onclick = function(event) {
        const modal = document.getElementById('modal');
        if (event.target == modal) closeModal();
    }
    </script>
</body>
</html>