<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.util.List" %>
<%
	
	Admin admin = (Admin) session.getAttribute("admin");

	if (admin==null){
		response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		return;
	}
	
	OrderDetailsDTO order_details = (OrderDetailsDTO) request.getAttribute("order-details");
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Order Details (Admin View)</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
        .order-details-admin-container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            box-shadow: 0 8px 32px rgba(44, 90, 160, 0.08);
            border-radius: 14px;
            padding: 40px;
            border: 1px solid #e0e0e0;
        }
        .admin-section-title {
            font-size: 2rem;
            font-weight: 700;
            color: #2c5aa0;
            margin-bottom: 30px;
            text-align: center;
        }
        .order-info-group {
            display: flex;
            flex-wrap: wrap;
            gap: 40px;
            margin-bottom: 35px;
        }
        .info-card {
            flex: 1;
            min-width: 260px;
            background: #f8f9fa;
            border-radius: 10px;
            padding: 25px 30px;
            border: 1px solid #e0e0e0;
            margin-bottom: 10px;
        }
        .info-card h3 {
            font-size: 1.15rem;
            font-weight: 600;
            margin-bottom: 15px;
            color: #2c5aa0;
        }
        .info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
            font-size: 0.97rem;
        }
        .info-label {
            color: #666;
            font-weight: 500;
        }
        .info-value {
            color: #333;
            font-weight: 600;
        }
        /* Order Items Table */
        .order-items-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c5aa0;
            margin-bottom: 12px;
        }
        .order-items-table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 40px;
        }
        .order-items-table th, .order-items-table td {
            border: 1px solid #e0e0e0;
            padding: 10px 16px;
            text-align: center;
        }
        .order-items-table th {
            background: #f8f9fa;
            color: #2c5aa0;
            font-weight: 600;
            font-size: 1rem;
        }
        .order-items-table td {
            font-size: 0.97rem;
        }
        /* Payment details box */
        .payment-details-box {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 30px;
            border: 1px solid #e0e0e0;
            margin-top: 20px;
        }
        .payment-details-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c5aa0;
            margin-bottom: 10px;
        }
        .payment-info-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 12px;
        }
        .payment-label {
            color: #666;
            font-weight: 500;
        }
        .payment-value {
            color: #333;
            font-weight: 600;
        }
        /* Responsive */
        @media only screen and (max-width: 1000px) {
            .order-details-admin-container {
                padding: 25px;
            }
            .order-info-group {
                flex-direction: column;
                gap: 20px;
            }
        }
        @media only screen and (max-width: 600px) {
            .order-details-admin-container {
                padding: 10px;
            }
            .info-card, .payment-details-box {
                padding: 12px;
            }
            .order-items-table th, .order-items-table td {
                padding: 8px 5px;
            }
        }
    </style>
</head>
<body>
    <div class="order-details-admin-container">
        <div class="admin-section-title">Order Details (Admin View)</div>

        <div class="order-info-group">
            <!-- Customer Info -->
            <div class="info-card">
                <h3>Customer Information</h3>
                <div class="info-row">
                    <span class="info-label">Name:</span>
                    <span class="info-value" id="customerName"><%=order_details.getUser().getUserName() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Email:</span>
                    <span class="info-value" id="customerEmail"><%=order_details.getUser().getUserEmail() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Phone:</span>
                    <span class="info-value" id="customerPhone"><%=order_details.getUser().getUserPhone() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Address:</span>
                    <span class="info-value" id="customerAddress">
                        <%=order_details.getUser().getUserAddress() %>
                    </span>
                </div>
                <div class="info-row">
                    <span class="info-label">Registration Date:</span>
                    <span class="info-value" id="customerRegDate"><%=order_details.getUser().getReg_date() %></span>
                </div>
            </div>
            <!-- Order Info -->
            <div class="info-card">
                <h3>Order Information</h3>
                <div class="info-row">
                    <span class="info-label">Order ID:</span>
                    <span class="info-value" id="orderId"><%=order_details.getOrder().getOrder_id() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Order Date:</span>
                    <span class="info-value" id="orderDate"><%=order_details.getOrder().getOrder_date() %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Status:</span>
                    <span class="info-value" id="orderStatus"><%=order_details.getOrder().getOrder_status() %></span>
                </div>
            </div>
        </div>

        <!-- Order Items List -->
        <div>
            <div class="order-items-title">Order Items</div>
            <table class="order-items-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Product Name</th>
                        <th>Product ID</th>
                        <th>Price</th>
                        <th>Quantity</th>
                    </tr>
                </thead>
                <tbody>
                  <% for (OrderItemDTO item: order_details.getOrderItemDTO()) { %>
                    <tr>
                        <td>item.getOrderItem().getOrder_item_id()</td>
                        <td>item.getProduct().getProduct_name()</td>
                        <td>item.getProduct().getProduct_id()</td>
                        <td>item.getProduct().getPrice()</td>
                        <td>item.getOrderItem().getQuantity()</td>
                    </tr>
                   <% } %>
                </tbody>
            </table>
        </div>

        <!-- Payment Details -->
        <div class="payment-details-box">
            <div class="payment-details-title">Payment Information</div>
            <div class="payment-info-row">
                <span class="payment-label">Payment ID:</span>
                <span class="payment-value" id="paymentId"><%=order_details.getPayment().getPaymentId() %></span>
            </div>
            <div class="payment-info-row">
                <span class="payment-label">Amount:</span>
                <span class="payment-value" id="paymentAmount">₹ <%=order_details.getPayment().getAmount() %></span>
            </div>
            <div class="payment-info-row">
                <span class="payment-label">Payment Date:</span>
                <span class="payment-value" id="paymentDate"><%=order_details.getPayment().getPaymentDate() %></span>
            </div>
            <div class="payment-info-row">
                <span class="payment-label">Payment Method:</span>
                <span class="payment-value" id="paymentMethod"><%=order_details.getPayment().getPaymentMethod() %></span>
            </div>
        </div>
    </div>
</body>
</html>