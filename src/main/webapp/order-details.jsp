<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
    // Fetch the order and its items from the request
    User user = (User) session.getAttribute("user");

	if (user==null){
		response.sendRedirect(request.getContextPath()+"/signin.jsp");
	}
	
    OrderDetailsDTO order_details = (OrderDetailsDTO) request.getAttribute("order-details");

    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
    
    boolean orderConfirmed = "CANCELLED".equalsIgnoreCase(order_details.getOrder().getOrder_status());
    boolean paymentAvailable = order_details.getPayment() != null && order_details.getPayment().getPaymentId() != null && !order_details.getPayment().getPaymentId().trim().isEmpty();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Details - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
  
        .order-details-container {
            max-width: 980px;
            margin: 32px auto;
            background: #fff;
            box-shadow: 0 8px 32px rgba(44, 90, 160, 0.06);
            border-radius: 14px;
            padding: 28px;
            border: 1px solid #e0e0e0;
        }

        .section-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: #2c5aa0;
            margin-bottom: 16px;
            text-align: left;
        }

        .info-grid {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 22px;
        }

        .info-card {
            flex: 1;
            min-width: 240px;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 18px 20px;
            border: 1px solid #e0e0e0;
        }

        .info-card h3 {
            font-size: 1.02rem;
            font-weight: 600;
            color: #2c5aa0;
            margin-bottom: 10px;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            font-size: 0.98rem;
        }

        .label { color: #666; font-weight: 500; }
        .value { color: #333; font-weight: 600; text-align: right; }

        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            margin: 12px 0 22px 0;
        }
        .order-items-table th, .order-items-table td {
            border: 1px solid #e0e0e0;
            padding: 10px 12px;
            text-align: center;
        }
        .order-items-table th {
            background: #f8f9fa;
            color: #2c5aa0;
            font-weight: 600;
        }

        .payment-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 18px 20px;
            border: 1px solid #e0e0e0;
            margin-top: 12px;
        }

        .muted {
            color: #666;
            font-weight: 500;
        }

        .back-link {
            display: inline-block;
            margin-bottom: 12px;
            padding: 8px 12px;
            border-radius: 8px;
            background: #2c5aa0;
            color: #fff;
            text-decoration: none;
            font-weight: 600;
        }

        .empty-state { text-align: center; padding: 1.5rem 0; color: #666; }

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
          <li><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
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
        <% } %>
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
    
    <div class="order-details-container">
        <a href="<%= request.getContextPath() %>/orders" class="back-link">&larr; Back to Orders</a>

        <div class="section-title">Order Details</div>

        <!-- Customer & Order Info -->
        <div class="info-grid">
            <div class="info-card">
                <h3>Customer Information</h3>
                <div class="info-row"><span class="label">Name</span><span class="value"><%= order_details.getUser().getUserName() %></span></div>
                <div class="info-row"><span class="label">Email</span><span class="value"><%= order_details.getUser().getUserEmail() %></span></div>
                <div class="info-row"><span class="label">Phone</span><span class="value"><%= order_details.getUser().getUserPhone() %></span></div>
                <div class="info-row"><span class="label">Address</span><span class="value"><%= order_details.getUser().getUserAddress() %></span></div>
                <div class="info-row"><span class="label">Registered</span><span class="value"><%= order_details.getUser().getReg_date() %></span></div>
            </div>

            <div class="info-card">
                <h3>Order Information</h3>
                <% if (order_details.getOrder() != null) { %>
                    <div class="info-row"><span class="label">Order ID</span><span class="value"><%= order_details.getOrder().getOrder_id() %></span></div>
                    <div class="info-row"><span class="label">Order Date</span><span class="value"><%= order_details.getOrder().getOrder_date() %></span></div>
                    <div class="info-row"><span class="label">Status</span><span class="value"><%= order_details.getOrder().getOrder_status() %></span></div>
                <% } else { %>
                    <div class="empty-state">Order information not available.</div>
                <% } %>
            </div>
        </div>

        <!-- Order Items -->
        <div>
            <div class="section-title" style="font-size:1.2rem; margin-bottom:8px;">Items in this Order</div>

            <% if (order_details.getOrderItemDTO() == null || order_details.getOrderItemDTO().isEmpty()) { %>
                <div class="empty-state">No items found for this order.</div>
            <% } else { %>
                <table class="order-items-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Product</th>
                            <th>Product ID</th>
                            <th>Unit Price</th>
                            <th>Quantity</th>
                            <th>Subtotal</th>
                            <th>Stock</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int idx = 1;
                            for (OrderItemDTO item : order_details.getOrderItemDTO()) {
                                Product p = item.getProduct();
                                OrderItem oi = item.getOrderItem();
                                double price = p != null ? p.getPrice() : 0.0;
                                int qty = oi != null ? oi.getQuantity() : 0;
                                double subtotal = price * qty;
                        %>
                        <tr>
                            <td><%= idx++ %></td>
                            <td><%= p != null ? p.getProduct_name() : "—" %></td>
                            <td><%= p != null ? p.getProduct_id() : "—" %></td>
                            <td>₹ <%= String.format("%.2f", price) %></td>
                            <td><%= qty %></td>
                            <td>₹ <%= String.format("%.2f", subtotal) %></td>
                            <td><%= (p != null && p.getStock_quantity() > 0) ? "Available" : "Out of Stock" %></td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            <% } %>
        </div>

        <!-- Payment Information:
             - If order status is CONFIRMED (or COMPLETED) DO NOT SHOW payment box.
             - Otherwise:
               - if payment exists and has id -> show payment details
               - else -> show "Payment yet to be confirmed"
        -->
        <% if (!orderConfirmed) { %>
            <div class="payment-box">
                <h3 style="margin-top:0;">Payment Information</h3>
                <% if (paymentAvailable) { %>
                    <div class="info-row"><span class="label">Payment ID</span><span class="value"><%= order_details.getPayment().getPaymentId() %></span></div>
                    <div class="info-row"><span class="label">Amount</span><span class="value">₹ <%= String.format("%.2f", order_details.getPayment().getAmount()) %></span></div>
                    <div class="info-row"><span class="label">Payment Date</span><span class="value"><%= order_details.getPayment().getPaymentDate() %></span></div>
                    <div class="info-row"><span class="label">Method</span><span class="value"><%= order_details.getPayment().getPaymentMethod() != null ? order_details.getPayment().getPaymentMethod().getValue() : "—" %></span></div>
                <% } else { %>
                    <div class="muted">Payment yet to be confirmed.</div>
                <% } %>
            </div>
        <% } else { %>
            <!-- If order confirmed, hide payment box entirely -->
        <% } %>

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
	</script>
	
</body>
</html>