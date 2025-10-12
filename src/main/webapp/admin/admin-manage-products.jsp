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
	String successMessage = (String) session.getAttribute("successMessage");
	session.removeAttribute("errorMessage");
	session.removeAttribute("successMessage");
	
	
	List<Product> products = (List<Product>) request.getAttribute("products");
	List<Category> categories = (List<Category>) request.getAttribute("categories");

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Products - SwitchBit</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            background: #f4f6f8;
        }
        .container {
            max-width: 1100px;
            margin: 60px auto 0 auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 2px 16px rgba(0,0,0,0.07);
            padding: 40px 30px;
        }
        h2 {
            color: #23272b;
            margin-bottom: 30px;
            text-align: center;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            font-size: 17px;
        }
        th, td {
            padding: 14px 12px;
            text-align: left;
        }
        th {
            background: #f5f5f5;
            color: #374151;
        }
        tr:nth-child(even) {
            background: #f9f9f9;
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
            .container { max-width: 98%; padding: 15px 4px; }
            table { font-size: 15px; }
            th, td { padding: 7px 5px; }
            .modal-content { max-width: 99%; padding: 12px 8px 18px 8px;}
            .modal-form label, .modal-form input, .modal-form textarea, .modal-form select {
                font-size: 15px;
            }
        }
    </style>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-style.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/cart.css" />
</head>
<body>

	<%
		if (successMessage != null) {
	%>
		<div id="toast-success"><%= successMessage %></div>
	<%
		}
	%>
	
	<%
		if (errorMessage != null) {
			
	%>
    	<div id="toast-error"><%=errorMessage %></div>
	<%
		}
	%>
	<div class="sidebar">
        <h2>Welcome, <%= admin.getAdmin_username() %></h2>
        <a href="<%=request.getContextPath()%>/admin/home">Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/products">Manage Products</a>
        <a href="<%=request.getContextPath()%>/admin/orders">Manage Orders</a>
        <a href="<%=request.getContextPath()%>/admin/reports">Manage Reports</a>
    </div>
    <div class="container">
        <h2>All Products</h2>
        <button class="browse-all-btn" onclick="openModal(this)" form-type="add">Add Product</button>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Product Name</th>
                    <th>Category</th>
                    <th>Price</th>
                    <th>Stock</th>
                    <th>Image</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                 <% for (Product product : products) { %>
                	<tr>
                		<td><%= product.getProduct_id() %></td>
                		<td><%= product.getProduct_name() %></td>
                		<td><%= product.getCategory().getCategory_name() %></td>
                		<td>₹ <%= product.getPrice() %></td>
                		<td><%= product.getStock_quantity() %></td>
                		<td><img width="80px" height="80px" src="<%=request.getContextPath()%>/<%=product.getProduct_img()%>" alt=<%=product.getProduct_name() %>></td>
                		<td style="display:flex; gap:10px; flex-direction:column; align-item:center;">
                			<button class="browse-all-btn" 
                					product-id="<%= product.getProduct_id() %>"
                					product-name="<%= product.getProduct_name() %>"
                					product-description="<%= product.getDescription() %>"
                					product-price = "<%= product.getPrice() %>"
                					product-stock="<%= product.getStock_quantity() %>"
                					product-category="<%= product.getCategory().getCategory_id() %>"
                					product-img="<%=request.getContextPath() %>/<%=product.getProduct_img() %>"
                					form-type="update"
                					onclick="openModal(this)">
                					Edit
                			</button>
	                		 <form class="remove-cart-form" action="<%=request.getContextPath() %>/admin/product/delete" method="post">
	                    		<input type="hidden" name="product-id" value="<%= product.getProduct_id()%>">
	                       		<button type="submit" class="btn-remove-cart">Delete</button>
	                   		 </form>
                		</td>
                	</tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Popup Modal -->
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

                <button type="submit" class="browse-all-btn" id="modal-submit">Save Product</button>
            </form>
        </div>
       </div>	
       
    <script>
        // Modal controls
       function openModal(button) {
    	const imgPath = button.getAttribute("product-img");
    	const form = document.getElementById("productForm");
    	
    	if (button.getAttribute("form-type")==="add") {
    		form.setAttribute("action","<%=request.getContextPath()%>/admin/product/add");
    	}else{
    		form.setAttribute("action","<%=request.getContextPath()%>/admin/product/update");
    		
    		document.getElementById('product-id').value = button.getAttribute('product-id');
            document.getElementById('product-name').value = button.getAttribute('product-name');
            document.getElementById('product-description').value = button.getAttribute('product-description');
            document.getElementById('product-price').value = button.getAttribute('product-price');
            document.getElementById('stock-quantity').value = button.getAttribute('product-stock');
            document.getElementById('category-id').value = button.getAttribute('product-category');
            
    	}
    	
        document.getElementById('modal').style.display = "block";
        document.getElementById('imgPreview').style.display = 'none';
        
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
    
    
    <% if (successMessage != null) { %>
		var successtoast = document.getElementById("toast-success");
		successtoast.className = "show";
		successtoast.style.visibility = "visible";
		setTimeout(function(){
			successtoast.className = successtoast.className.replace("show", "");
			successtoast.style.visibility = "hidden"
		}, 6000);
	<% } %>
	
	<% if (errorMessage != null) { %>
		var errortoast = document.getElementById("toast-error");
		errortoast.className = "show";
		errortoast.style.visibility = "visible";
		setTimeout(function(){
			errortoast.className = errortoast.className.replace("show", ""); 
			errortoast.style.visibility = "hidden";
		}, 6000);
	<% } %>
    </script>
</body>
</html>