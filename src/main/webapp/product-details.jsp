<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.model.*" %>
<%
    // Get session user
    User user = (User) session.getAttribute("user");
	Integer totalItemObj = (Integer) session.getAttribute("total-item");
	int total_item = (totalItemObj != null) ? totalItemObj : 0;
	Product product = (Product) request.getAttribute("product");
	
	
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Product Details - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css" />
    <style>
  	.cart-container::after {
  		content: '<%=total_item%>';
  		position: absolute;
  		top: -5px;
  		right: -5px;
  		background: #ff4757;
  		color: white;
  		border-radius: 50%;
  		width: 20px;
  		height: 20px;
  		display: flex;
  		align-items: center;
  		justify-content: center;
  		font-size: 0.7rem;
  		font-weight: 600;
  		border: 2px solid white;
	}
	form {
		display:block;	
	}
	.product-actions {
		align-items: flex-start;
	}
  </style>
  </head>
  <body>
    <div class="page-container">
    <div class="header">
      <div class="company-logo">
        <div class="logo">
          <img width="30px" src="<%=request.getContextPath() %>/icons/mouse.png" alt="" />
        </div>
        <div class="title">SwitchBit</div>
      </div>

      <div class="nav">
        <ul>
          <li><a href="<%=request.getContextPath()%>/home">Home</a></li>
          <li><a href="<%=request.getContextPath()%>/about.jsp">About</a></li>
          <%
          	if (user==null){
          		
          %>
          <li><a href="<%=request.getContextPath()%>/signup.jsp">Sign Up</a></li>
          <li><a href="<%=request.getContextPath()%>/signin.jsp">Sign In</a></li>
          <%
          	}
          %>
          <li><a href="<%=request.getContextPath()%>/product/products">Products</a></li>
          <li><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
        </ul>
      </div>

      <div class="side-container">
        <div class="search-container">
          <div class="search-input">
            <input
              type="text"
              placeholder="Search products..."
              name="search-query"
              class="search-field"
            />
            <button class="search-btn" type="submit">
              <img width="16px" src="<%=request.getContextPath() %>/icons/search-interface-symbol.png" alt="Search" />
            </button>
          </div>
        </div>
        <%
        if (user!=null){
        %>
        <div class="cart-container">
          <div class="side-icon">
            <a href="<%=request.getContextPath()%>/cart"><img width="20px" src="<%= request.getContextPath() %>/icons/shopping-cart.png" alt="c" /></a>
          </div>
        </div>
        <div class="account-container">
          <div class="side-icon profile-trigger">
            <img width="20px" src="<%=request.getContextPath() %>/icons/profile-icon.png" alt="Profile" />
          </div>
          <div class="profile-dropdown">
            <div class="dropdown-item">
              <span class="dropdown-icon">📦</span>
              <span>Your Orders</span>
            </div>
            <div class="dropdown-item">
              <span class="dropdown-icon">💬</span>
              <span>Submitted Reports</span>
            </div>
            <div class="dropdown-item">
              <span class="dropdown-icon">⚙️</span>
              <span>Manage Account</span>
            </div>
            <div class="dropdown-divider"></div>
            <div class="dropdown-item logout">
              <span class="dropdown-icon">🚪</span>
              <span>Logout</span>
            </div>
          </div>
        </div>
        <%
        	}
        %>
      </div>
    </div>

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

    <div class="main">
      <div class="product-details-page">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
          <a href="<%=request.getContextPath() %>/home">Home</a>
          <span class="breadcrumb-separator">></span>
          <a href="<%=request.getContextPath() %>/product/products">Products</a>
          <span class="breadcrumb-separator">></span>
          <span class="breadcrumb-current"><%=product.getProduct_name() %></span>
        </div>
        
        <div class="product-details-container">
          <div class="product-image-section">
            <div class="main-image">
              <img src="<%=request.getContextPath() %>/<%=product.getProduct_img()%>" alt="<%=product.getProduct_name() %>>" />
            </div>
            </div>
          </div>

          <div class="product-info-section">
            <div class="product-header">
              <h1 class="product-title"><%=product.getProduct_name() %></h1>
              <div class="product-category"><%=product.getCategory().getCategory_name()%></div>
            </div>

            <div class="product-price">
              <span class="current-price">₹<%= Math.floor(product.getPrice()) %></span>
            </div>

            <div class="product-description">
              <h3>In stock: </h3>
              <p><%=product.getStock_quantity() %></p>
              <h3>Description</h3>
              <p><%=product.getDescription() %></p>
            </div>

			<% if (product.getStock_quantity()<=0) { %>
                    <div><h3>Out of Stock</h3></div>
            <% } else{ %>
            <div class="product-actions">
              <div class="quantity-selector">
                <label for="quantity">Quantity:</label>
                <div class="quantity-controls">
                  <button class="quantity-btn minus" type="button">-</button>
                  <input type="number" id="quantity" name="quantity" value="1" min="1" max=<%=product.getStock_quantity() %> class="quantity-input">
                  <button class="quantity-btn plus" type="button">+</button>
                </div>
              </div>      	
	          <div class="action-buttons">
	               <% if (user != null) { %>
	                  <form action="<%=request.getContextPath()%>/payment/buynow" method="post">
	                  	<input type="hidden" name="product-id" value=<%=product.getProduct_id() %>>
	                  	<input id="product_quan_buy_now" type="hidden" name="product-quan" value=1>
	                  	<button class="buy-now-btn" type="submit">Buy Now</button>
	                  </form>
	                  <% } else { %>
	                    <button class="buy-now-btn" onclick="window.location.href='<%=request.getContextPath()%>/signin.jsp';">Buy Now</button>
	                <% } %>
	                  	
	                <% if (user != null) { %>
	                  	<form action="<%=request.getContextPath() %>/cart" method="post">
	                  		<input type="hidden" name="product_id" value=<%=product.getProduct_id() %>>
	                  		<input id="product_quan" type="hidden" name="product_quan" value=1>
	                    	<button class="add-to-cart-btn" type="submit" >Add to Cart</button>
	                  	</form>
	                <% } else { %>
	                    <button class="add-to-cart-btn" onclick="window.location.href='<%=request.getContextPath()%>/signin.jsp';">Add to Cart</button>
	                <% } %>
               <%} %>

          </div>
        </div>
      </div>
    </div>

    
    </div>
    
    <div class="footer">
      <div class="footer-content">
        <div class="support">
          <h3>Support</h3>
          <ul>
            <li>111 XYZ New Delhi</li>
            <li>switchbit@email.com</li>
            <li>+91 9999999999</li>
          </ul>
        </div>

        <div class="support">
          <h3>Company</h3>
          <ul>
            <li>About Us</li>
            <li>Careers</li>
            <li>Privacy Policy</li>
          </ul>
        </div>

        <div class="support">
          <h3>Quick Links</h3>
          <ul>
            <li>Home</li>
            <li>Shop</li>
            <li>Contact</li>
          </ul>
        </div>
      </div>

      <div class="footer-bottom">
        <p>© 2025 SwitchBit. All Rights Reserved.</p>
      </div>
    </div>
    
    <% if (user!=null) {%>
	    <script src="<%=request.getContextPath()%>/js/profile-dropdown.js"></script> 
    <% } %>
    
    <% if (successMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/successMessage.js" ></script>
	<% } %>
	
	<% if (errorMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/errorMessage.js" ></script>
	<% } %>
    
    <script>
	   const contextPath = "<%= request.getContextPath() %>" ;
    
      document.addEventListener('DOMContentLoaded', function() {
    	  
        // Product details functionality
        const quantityInput = document.getElementById('quantity');
        const productQuan = document.getElementById('product_quan');
        const productQuanBuyNow = document.getElementById('product_quan_buy_now');
        const minusBtn = document.querySelector('.quantity-btn.minus');
        const plusBtn = document.querySelector('.quantity-btn.plus');
        const buyNowBtn = document.querySelector('.btn-buy-now-large');
        const addToCartBtn = document.querySelector('.btn-add-cart-large');
        const thumbnails = document.querySelectorAll('.thumbnail');
        const mainImage = document.querySelector('.main-image img');

        // Quantity controls
        minusBtn.addEventListener('click', function() {
          const currentValue = parseInt(quantityInput.value);
          if (currentValue > 1) {
            quantityInput.value = currentValue - 1;
            productQuan.value = currentValue-1;
            productQuanBuyNow.value = currentValue-1;
          }
        });

        plusBtn.addEventListener('click', function() {
          const currentValue = parseInt(quantityInput.value);
          const maxValue = parseInt(quantityInput.getAttribute('max'));
          if (currentValue < maxValue) {
            quantityInput.value = currentValue + 1;
            productQuan.value = currentValue+1;
            productQuanBuyNow.value = currentValue+1;
          }
        });
        
      });
      

    </script>
  </body>
</html>
