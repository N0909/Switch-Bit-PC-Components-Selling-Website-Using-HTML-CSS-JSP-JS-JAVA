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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin-style.css" />
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
</head>
<body>
    <div class="sidebar">
        <h2>Welcome, <%= admin.getAdmin_username() %></h2>
        <a href="<%=request.getContextPath()%>/admin/home">Dashboard</a>
        <a href="<%=request.getContextPath()%>/admin/products">Manage Products</a>
        <a href="<%=request.getContextPath()%>/admin/orders">Manage Orders</a>
        <a href="<%=request.getContextPath()%>/admin/reports">Manage Reports</a>
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