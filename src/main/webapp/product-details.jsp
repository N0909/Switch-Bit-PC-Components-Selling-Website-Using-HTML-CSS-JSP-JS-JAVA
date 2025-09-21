<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.model.*" %>
<%
    // Get session user
    User user = (User) session.getAttribute("user");
	Product product = (Product) request.getAttribute("product");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Product Details - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css" />
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
          <li><a href="<%=request.getContextPath()%>/contact.jsp">Contact</a></li>
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
            <img width="20px" src="<%=request.getContextPath() %>/icons/shopping-cart.png" alt="c" />
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
              <div class="product-category"><%=product.getCategory().getCategory_name() %></div>
            </div>

            <div class="product-price">
              <span class="current-price">₹<%=product.getPrice() %></span>
            </div>

            <div class="product-description">
              <h3>Description</h3>
              <p><%=product.getDescription() %></p>
            </div>


            <div class="product-actions">
              <div class="quantity-selector">
                <label for="quantity">Quantity:</label>
                <div class="quantity-controls">
                  <button class="quantity-btn minus" type="button">-</button>
                  <input type="number" id="quantity" name="quantity" value="1" min="1" max="10" class="quantity-input">
                  <button class="quantity-btn plus" type="button">+</button>
                </div>
              </div>

              <div class="action-buttons">
                <button class="btn-buy-now-large">Buy Now</button>
                <button class="btn-add-cart-large">Add to Cart</button>
              </div>
            </div>

            <div class="product-shipping">
              <div class="shipping-info">
                <div class="shipping-item">
                  <span class="shipping-icon">🚚</span>
                  <div class="shipping-text">
                    <strong>Free Shipping</strong>
                    <p>On orders over ₹5,000</p>
                  </div>
                </div>
                <div class="shipping-item">
                  <span class="shipping-icon">🔄</span>
                  <div class="shipping-text">
                    <strong>Easy Returns</strong>
                    <p>30-day return policy</p>
                  </div>
                </div>
                <div class="shipping-item">
                  <span class="shipping-icon">🛡️</span>
                  <div class="shipping-text">
                    <strong>Warranty</strong>
                    <p>3-year manufacturer warranty</p>
                  </div>
                </div>
              </div>
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
    </div>
    
    <script>
      
   
      // Profile dropdown functionality
      document.addEventListener('DOMContentLoaded', function() {
    	  
    	<%
      		if (user!=null){
      	%>
        const profileTrigger = document.querySelector('.profile-trigger');
        const profileDropdown = document.querySelector('.profile-dropdown');
        const accountContainer = document.querySelector('.account-container');
        
        // Toggle dropdown on click
        profileTrigger.addEventListener('click', function(e) {
          e.stopPropagation();
          const isVisible = profileDropdown.style.opacity === '1';
          
          if (isVisible) {
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          } else {
            profileDropdown.style.opacity = '1';
            profileDropdown.style.visibility = 'visible';
            profileDropdown.style.transform = 'translateY(0)';
          }
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
          if (!accountContainer.contains(e.target)) {
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          }
        });
        
        // Handle dropdown item clicks
        const dropdownItems = document.querySelectorAll('.dropdown-item');
        dropdownItems.forEach(item => {
          item.addEventListener('click', function() {
            const text = this.querySelector('span:last-child').textContent;
            
            // Handle different actions
            if (text === 'Your Orders') {
              alert('Redirecting to Your Orders page...');
              // Add your navigation logic here
            } else if (text === 'Manage Account') {
              alert('Redirecting to Account Management...');
              // Add your navigation logic here
            } else if (text === 'Logout') {
              if (confirm('Are you sure you want to logout?')) {
            	  window.location.href = '<%= request.getContextPath() %>/user/logout';
              }
            }
            
            // Close dropdown after action
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          });
        });
       	<%
      		}
       	%>

        // Product details functionality
        const quantityInput = document.getElementById('quantity');
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
          }
        });

        plusBtn.addEventListener('click', function() {
          const currentValue = parseInt(quantityInput.value);
          const maxValue = parseInt(quantityInput.getAttribute('max'));
          if (currentValue < maxValue) {
            quantityInput.value = currentValue + 1;
          }
        });
        
      });

    </script>
  </body>
</html>
