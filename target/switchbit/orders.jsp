<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %> 
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
    List<Order> orders = (List<Order>) session.getAttribute("orders");
	User user  = (User) session.getAttribute("user");
	String errorMessage = (String) session.getAttribute("errorMessage");
	session.removeAttribute("errorMessage");
	if (user == null){
    	response.sendRedirect("signin.jsp");
    }
    if (orders == null) {
        orders = new ArrayList<>();
    }
    
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order History - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
        h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #232f3e;
        }
        .order-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 1.5rem;
        }
        .order-table th, .order-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #eee;
            text-align: left;
        }
        .order-table th {
            background: #f2f2f5;
            color: #232f3e;
        }
        .empty-state {
            text-align: center;
            padding: 3rem 0;
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
          <div class="side-icon">
            <a href="<%=request.getContextPath()%>/cart"><img width="20px" src="<%= request.getContextPath() %>/icons/shopping-cart.png" alt="c" /></a>
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
    
    <%
    	if (errorMessage!=null){
    %>
    	<div class="error-message">><%=errorMessage %></div>
    <%
    	}
    %>
    <div class="main">
        <h2>Your Order History</h2>

        <%
            if (orders.isEmpty()) {
        %>
            <div class="empty-state">
                <p style="font-size:1.1rem; color:#232f3e; margin-bottom:1.5rem;">
                    You haven't placed any orders yet.
                </p>
                <a href="<%= request.getContextPath() %>/product/products" class="browse-all-btn">Go to Shop</a>
            </div>
        <%
            } else {
        %>
            <table class="order-table">
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    for (Order order : orders) {
                        String orderId = order.getOrder_id();
                        Timestamp date = order.getOrder_date();
                        Double total = order.getTotal_amount();
                %>
                    <tr>
                        <td><a href="<%=request.getContextPath() %>/orders/orderdetail?order-id=<%= orderId%>"><%= orderId %></a></td>
                        <td><%= date %></td>
                        <td>₹<%= String.format("%.2f", total) %></td>
                        <td><%= order.getOrder_status() %></td>
                    </tr>
                <%
                    }
                %>
                </tbody>
            </table>
        <%
            }
        %>
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
        <% if (errorMessage != null) { %>
			var toast = document.getElementById("toast");
			toast.className = "show";
			setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
		<% } %>
      });
    </script>
    
</body>
</html>