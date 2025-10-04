<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.util.*" %>
<%
	Payment payment = (Payment) session.getAttribute("payment");
	List<OrderItemDTO> dto = (List<OrderItemDTO>) session.getAttribute("orderitems");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Payment Success - SwitchBit</title>
  <style>
    body {
      font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
      margin: 0;
      background: #f9f9f9;
      color: #333;
    }

    .container {
      max-width: 1000px;
      margin: 40px auto;
      padding: 20px;
    }

    .success-message {
      text-align: center;
      background: #d4edda;
      color: #155724;
      border: 1px solid #c3e6cb;
      border-radius: 8px;
      padding: 20px;
      font-size: 1.2rem;
      font-weight: 600;
      margin-bottom: 30px;
    }

    .payment-summary,
    .order-items {
      background: #fff;
      border-radius: 10px;
      box-shadow: 0 2px 6px rgba(0,0,0,0.1);
      padding: 20px;
      margin-bottom: 30px;
    }

    .section-title {
      font-size: 1.4rem;
      font-weight: bold;
      margin-bottom: 15px;
      color: #444;
      border-bottom: 2px solid #eee;
      padding-bottom: 10px;
    }

    .summary-grid {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 15px;
      font-size: 0.95rem;
    }

    .summary-item span {
      font-weight: bold;
      color: #555;
    }

    .order-item {
      display: flex;
      align-items: center;
      gap: 15px;
      border-bottom: 1px solid #eee;
      padding: 15px 0;
    }

    .order-item:last-child {
      border-bottom: none;
    }

    .product-img img {
      width: 80px;
      height: 80px;
      object-fit: cover;
      border-radius: 8px;
      border: 1px solid #ddd;
    }

    .product-details {
      flex-grow: 1;
    }

    .product-name {
      font-size: 1.1rem;
      font-weight: bold;
      margin-bottom: 5px;
    }

    .product-meta {
      font-size: 0.9rem;
      color: #666;
    }

    .product-price {
      font-weight: bold;
      color: #222;
      font-size: 1rem;
      margin-top: 5px;
    }

    .total-amount {
      text-align: right;
      font-size: 1.3rem;
      font-weight: bold;
      color: #222;
      margin-top: 20px;
    }

    .btn-container {
      text-align: center;
      margin-top: 30px;
    }

    .btn {
      display: inline-block;
      background: #4caf50;
      color: white;
      padding: 12px 20px;
      border-radius: 6px;
      text-decoration: none;
      font-weight: bold;
      transition: background 0.3s ease;
    }

    .btn:hover {
      background: #45a049;
    }
    
    @media (max-width: 600px) {
      .summary-grid {
        grid-template-columns: 1fr;
      }

      .order-item {
        flex-direction: column;
        align-items: flex-start;
      }

      .product-img img {
        width: 100%;
        height: auto;
      }

      .total-amount {
        text-align: left;
      }
    }
    
  </style>
</head>
<body>
  <div class="container">
    <!-- Success Message -->
    <div class="success-message">
      Payment Successful! Thank you for your purchase.
    </div>

    <!-- Payment Summary -->
    <div class="payment-summary">
      <div class="section-title">Payment Summary</div>
      <div class="summary-grid">
        <div class="summary-item"><span>Payment ID:</span> <%=payment.getPaymentId() %></div>
        <div class="summary-item"><span>Order ID:</span> <%=payment.getOrderId() %></div>
        <div class="summary-item"><span>User ID:</span> <%=payment.getUserId() %>1</div>
        <div class="summary-item"><span>Payment Method:</span> <%=payment.getPaymentMethod() %></div>
        <div class="summary-item"><span>Payment Date:</span> <%=payment.getPaymentDate() %></div>
        <div class="summary-item"><span>Amount Paid:</span> ₹<%=payment.getAmount() %></div>
      </div>
    </div>

    <!-- Order Items -->
    <div class="order-items">
      <div class="section-title">Order Items</div>

	<%
		for (OrderItemDTO item : dto) {
	%>
      <div class="order-item">
        <div class="product-img">
          <img src="<%=item.getProduct().getProduct_img() %>" alt="<%= item.getProduct().getProduct_name() %>">
        </div>
        <div class="product-details">
          <div class="product-name"><%= item.getProduct().getProduct_name() %></div>
          <div class="product-meta">Qty: <%=item.getOrderItem().getQuantity() %> × <%=item.getProduct().getPrice() %></div>
          <div class="product-price"> Subtotal: ₹<%=item.getOrderItem().getQuantity()*item.getProduct().getPrice() %></div>
        </div>
      </div>
      <%
		}
      %>

      <!-- Total -->
      <div class="total-amount">Total: ₹<%=payment.getAmount() %></div>
    </div>

    <div class="btn-container">
      <a href="<%=request.getContextPath() %>/home" class="btn">Continue Shopping</a>
    </div>
  </div>
</body>
</html>

