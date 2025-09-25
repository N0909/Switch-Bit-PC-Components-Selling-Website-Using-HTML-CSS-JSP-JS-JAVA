<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %> 
<%@ page import="com.switchbit.dto.*" %>
<%

	String error = (String) session.getAttribute("errorMessage");
	String message = (String) session.getAttribute("successMessage");
	
	if (message!=null)
		session.removeAttribute("successMessage");
	
	if (error!=null)
		session.removeAttribute("errorMessage");
	
	Integer totalItemObj = (Integer) session.getAttribute("total-item");
	int total_item = (totalItemObj != null) ? totalItemObj : 0;
	//Get session user
	User user = (User) session.getAttribute("user");
	if (user == null) {
		response.sendRedirect("signin.jsp");
		return;
	}
	
	CartDTO cart = (CartDTO) session.getAttribute("cart");
	List<CartItemDTO> items = null;
	double total=0;
	if (cart!=null){	
		items = cart.getItems();
	}
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Cart</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/css/cart.css">
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
	
  </style>
</head>
<body>

	<div class="header">
      <div class="company-logo">
        <div class="logo">
          <img width="30px" src="<%= request.getContextPath() %>/icons/mouse.png" alt="" />
        </div>
        <div class="title">SwitchBit</div>
      </div>

      <div class="nav">
        <ul>
          <li class=""><a href="<%= request.getContextPath() %>/home">Home</a></li>
          <li><a href="">About</a></li>
          <% if (user == null) { %>
            <li><a href="<%= request.getContextPath() %>/signup.jsp">Sign Up</a></li>
            <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
          <% } %>
          <li><a href="">Contact</a></li>
        </ul>
      </div>

      <div class="side-container">
       <div class="search-container">
          <form action="<%=request.getContextPath() %>/product/searchproduct" method="GET">
            <div class="search-input">
              <input
                type="text"
                placeholder="Search products..."
                name="search_query"
                class="search-field"
                value="<%= request.getParameter("search_query") != null ? request.getParameter("search_query") : "" %>"
              />
              <button class="search-btn" type="submit">
                <img width="16px" src="<%=request.getContextPath() %>/icons/search-interface-symbol.png" alt="Search" />
              </button>
            </div>
          </form>
        </div>
        
        <% if (user != null) { %>
        <div class="cart-container">
          <div class="side-icon" style="background: #2c5aa0">
            <a href="<%=request.getContextPath()%>/cart"><img style="filter: brightness(0) invert(1)" width="20px" src="<%= request.getContextPath() %>/icons/shopping-cart.png" alt="c" /></a>
          </div>
        </div>
        <div class="account-container">
          <div class="side-icon profile-trigger">
            <img width="20px" src="<%= request.getContextPath() %>/icons/profile-icon.png" alt="Profile" />
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
        <% } %>
      </div>
    </div>



    <div class="main">
        <div class="products-page">
            <div class="page-header">
                <h1>Your Shopping Cart</h1>
                <p>Review your selected items before checkout.</p>
            </div>

			<%
				if (items==null || items.isEmpty()){
			%>
            <div class="no-products">
                <h3>Your cart is empty</h3>
                <p><a href="<%=request.getContextPath() %>/product/products" class="browse-all-btn">Return to Shop</a></p>
            </div>
            <%
				}
            %>

			<div id="toast"><%= (message != null) ? message : "" %></div>
            <!-- If there are items in the cart, show this -->
            <div class="products-container">
            	<%
            		if (items!=null){
            			for (CartItemDTO item : items){
            				total += item.getCartItem().getQuantity()*item.getProduct().getPrice();
            	%>
                <div class="product-card-horizontal">
                    <div class="product-image">
                        <img src="<%=request.getContextPath() %>/<%=item.getProduct().getProduct_img() %>" alt="Product Name">
                    </div>
                    <div class="product-details">
                        <div class="product-info">
                            <h3 class="product-title"><%=item.getProduct().getProduct_name() %></h3>
                        </div>
                        <div class="product-actions">
                            <div class="price-section">
                                <span class="current-price">₹ <%=Math.floor(item.getProduct().getPrice()) %></span>
                            </div>
                            <div class="action-buttons" style="gap: 8px;">
                                <form class="cart-quantity-selector" action="cart/updateCartItemQuantity" method="post">
                                    <label for="quantity1" class="quantity-label">Qty</label>
                                    <button type="button" class="quantity-btn" onclick="changeQuantity(this, -1)">-</button>
                                    <input id="quantity1" class="quantity-input" name="cart-item-quantity" type="number" min="1" value="<%=item.getCartItem().getQuantity() %>">
                                    <button type="button" class="quantity-btn" onclick="changeQuantity(this, 1)">+</button>
                                    <input type="hidden" name="cart-item-id" value="<%=item.getCartItem().getCart_item_id()%>">
                                    <button type="submit" style="display:none"></button>
                                </form>
                                <span class="cart-subtotal">Subtotal: ₹ <%=Math.floor(item.getCartItem().getQuantity()*item.getProduct().getPrice()) %></span>
                            </div>
                        </div>
                    </div>
                    <form class="remove-cart-form" action="<%=request.getContextPath() %>/cart/deleteCartItem" method="post">
                    	<input type="hidden" name="cart-item-id" value="<%= item.getCartItem().getCart_item_id()%>">
                        <button type="submit" class="btn-remove-cart">Remove</button>
                    </form>
                </div>
                <%
            			}
            		}
                %>

            </div>

			<%
				if (total!=0){
			%>
            <div class="cart-total-container" style="margin-top:40px;display:flex;flex-direction:column;align-items:center;">
                <div class="cart-total-box">
                    <div class="cart-total-header">
                        <h2 style="margin-bottom:0;font-size:1.4rem;color:#2c5aa0;">Total</h2>
                        <span class="cart-grand-total">₹ <%=Math.ceil(total) %></span>
                    </div>
                    <form action="checkout.html" method="get" style="margin-bottom:8px;">
                        <button type="submit" class="btn-buy-now-large" style="width:100%;margin-bottom:12px;">Proceed to Checkout</button>
                    </form>
                </div>
            </div>
            <%
				}
            %>
        </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        <% if (user != null) { %>
        const profileTrigger = document.querySelector('.profile-trigger');
        const profileDropdown = document.querySelector('.profile-dropdown');
        const accountContainer = document.querySelector('.account-container');
        
        if (profileTrigger && profileDropdown && accountContainer) {
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
                window.location.href = '<%= request.getContextPath() %>/orders.jsp';
              } else if (text === 'Manage Account') {
                window.location.href = '<%= request.getContextPath() %>/profile.jsp';
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
        }
        <% } %>
        
        	// Handline Popup Messages
        <% if (message != null) { %>
			var toast = document.getElementById("toast");
			toast.className = "show";
			setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
		<% } %>
      });
    	
    	 // Handling Quantity Form
    	 	function changeQuantity(button, delta){
    		 	const input = document.getElementById("quantity1");
    		 	let value = parseInt(input.value) || 1
    		 	if (value<1){
    		 		return;
    		 	}
    		 	value = Math.max(value+delta, 1)
    		 	input.value = value;
    		 	
    		 	button.closest("form").submit();
    	 	}
    </script>
</body>
</html>