<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
    // Fetch the order and its items from the session or request
    Order order = (Order) request.getAttribute("order");
    List<OrderItemDTO> orderItems = (List<OrderItemDTO>) request.getAttribute("order-items");
    User user  = (User) session.getAttribute("user");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("errorMessage");
    if (user == null){
        response.sendRedirect("signin.jsp");
    }
    if (orderItems == null) {
        orderItems = new ArrayList<>();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
        h2 {
            font-size: 2rem;
            margin-bottom: 1rem;
            color: #232f3e;
        }
        .order-details-header {
            margin-bottom: 2rem;
            background: #f8f9fa;
            border-radius: 8px;
            padding: 1rem 1.5rem;
            box-shadow: 0 2px 8px 0 rgba(0,0,0,0.06);
            color: #232f3e;
        }
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            margin-bottom: 2rem;
        }
        .order-items-table th, .order-items-table td {
            padding: 0.75rem 1rem;
            border-bottom: 1px solid #eee;
            text-align: left;
        }
        .order-items-table th {
            background: #f2f2f5;
            color: #232f3e;
        }
        .empty-state {
            text-align: center;
            padding: 3rem 0;
        }
        
        .button {
		  padding: 8px 12px;
		  border: none;
		  border-radius: 6px;
		  font-weight: 600;
		  cursor: pointer;
		  transition: all 0.3s ease;
		  flex: 1;
		  max-width: 100px;
		  font-size: 0.8rem;
		 }
        
        .button:first-child {
  			background-color: #2c5aa0;
  			color: white;
		}

		.button:first-child:hover {
  			background-color: #1e3f73;
  			transform: translateY(-2px);
		}

		.button:last-child {
		  	background-color: #f8f9fa;
		  	color: #2c5aa0;
		  	border: 2px solid #2c5aa0;
		}

		.button:last-child:hover {
		  	background-color: #2c5aa0;
		  	color: white;
		  	transform: translateY(-2px);
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

    <div class="main">
        <a href="<%= request.getContextPath() %>/orders.jsp" class="button">&larr; Back to Orders</a>
        <div class="order-details-header">
            <h2>Order Details</h2>
            <% if (order != null) { %>
                <div><strong>Order ID:</strong> <%= order.getOrder_id() %></div>
                <div><strong>Date:</strong> <%= order.getOrder_date() %></div>
                <div><strong>Total Amount:</strong> ₹<%= String.format("%.2f", order.getTotal_amount()) %></div>
            <% } else { %>
                <div class="empty-state">Order not found.</div>
            <% } %>
        </div>

        <% if (orderItems == null || orderItems.isEmpty()) { %>
            <div class="empty-state">
                <p>No items found for this order.</p>
            </div>
        <% } else { %>
            <table class="order-items-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Product</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Subtotal</th>
                    </tr>
                </thead>
                <tbody>
                    <% int i = 1; for (OrderItemDTO item : orderItems) { %>
                        <tr>
                            <td><%= i++ %></td>
                            <td>
                              <%= item.getProduct().getProduct_name() %>
                            </td>
                            <td><%= item.getOrderItem().getQuantity()%></td>
                            <td>₹<%= String.format("%.2f", item.getProduct().getPrice()) %></td>
                            <td>₹<%= String.format("%.2f", item.getOrderItem().getQuantity() * item.getProduct().getPrice()) %></td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        <% } %>
    </div>

    <script>
    document.addEventListener('DOMContentLoaded', function() {
        <% if (user != null) { %>
        const profileTrigger = document.querySelector('.profile-trigger');
        const profileDropdown = document.querySelector('.profile-dropdown');
        const accountContainer = document.querySelector('.account-container');
        
        if (profileTrigger && profileDropdown && accountContainer) {
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
          document.addEventListener('click', function(e) {
            if (!accountContainer.contains(e.target)) {
              profileDropdown.style.opacity = '0';
              profileDropdown.style.visibility = 'hidden';
              profileDropdown.style.transform = 'translateY(-10px)';
            }
          });
          const dropdownItems = document.querySelectorAll('.dropdown-item');
          dropdownItems.forEach(item => {
            item.addEventListener('click', function() {
              const text = this.querySelector('span:last-child').textContent;
              if (text === 'Your Orders') {
                window.location.href = '<%= request.getContextPath() %>/orders.jsp';
              } else if (text === 'Manage Account') {
                window.location.href = '<%= request.getContextPath() %>/profile.jsp';
              } else if (text === 'Logout') {
                if (confirm('Are you sure you want to logout?')) {
                  window.location.href = '<%= request.getContextPath() %>/user/logout';
                }
              }
              profileDropdown.style.opacity = '0';
              profileDropdown.style.visibility = 'hidden';
              profileDropdown.style.transform = 'translateY(-10px)';
            });
          });
        }
        <% } %>
    });
    </script>
</body>
</html>