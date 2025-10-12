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
	String order_stat = (String) request.getAttribute("order-stat");
	
	if (errorMessage!=null)
		session.removeAttribute("errorMessage");
	if (successMessage!=null)
		session.removeAttribute("successMessage");
	
	List<Order> orders = (List<Order>)request.getAttribute("orders");
	
	
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Orders - SwitchBit</title>
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
        .section-title {
            font-size: 20px;
            margin: 40px 0 16px 0;
            color: #23272b;
            font-weight: bold;
            text-align: left;
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
        .modal-form input, .modal-form select {
            padding: 9px;
            border-radius: 6px;
            border: 1px solid #d1d5db;
            font-size: 16px;
            width: 100%;
            box-sizing: border-box;
        }
        @media (max-width: 900px) {
            .container { max-width: 98%; padding: 15px 4px; }
            table { font-size: 15px; }
            th, td { padding: 7px 5px; }
            .modal-content { max-width: 99%; padding: 12px 8px 18px 8px;}
            .modal-form label, .modal-form input, .modal-form select {
                font-size: 15px;
            }
        }
    </style>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />	
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
    <div class="container">
        <h2>All Orders</h2>
        <form action="<%=request.getContextPath() %>/admin/orders" method="get">
    		<label for="statusFilter">Filter by Status:</label>
	    	<select name="order-status" id="statusFilter" onchange="this.form.submit()">
	        	<option value="">-- All --</option>
	        	<option value="PENDING">Pending</option>
	        	<option value="SHIPPED">Shipped</option>
	        	<option value="DELIVERED">Delivered</option>
	        	<option value="PAID">Paid</option>
	        	<option value="CANCELLED">Cancelled</option>
	    	</select>
		</form>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>CustomerId</th>
                    <th>Date</th>
                    <th>Delivery Date</th>
                    <th>Status</th>
                    <th>Total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <% for (Order order: orders){ %>
                <tr>
                    <td><a href="<%= request.getContextPath()%>/admin/orders/orderdetails?order-id=<%= order.getOrder_id()%>"><%=order.getOrder_id() %></a></td>
                    <td><%=order.getUser_id() %></td>
                    <td><%=order.getOrder_date() %></td>
                    <td><%=order.getDelivery_date() %></td>
                    <td><%=order.getOrder_status() %></td>
                    <td>₹ <%=order.getTotal_amount() %></td>
                    <td>
                        <button class="browse-all-btn" 
	                        order-id = <%=order.getOrder_id() %>
	                        order-status = <%=order.getOrder_status() %>
	                        delivery-date = <%=order.getDelivery_date() %>
	                        onclick="openModal(this)">
	                        Edit
                        </button>
                    </td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>

    <!-- Popup Modal -->
    <div id="modal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h3 id="modal-title" style="margin-bottom:22px;">Edit Order</h3>
            <form class="modal-form" id="orderForm" action="<%=request.getContextPath()%>/admin/orders" method="post">
               	<input type="hidden" id="order-id" name="order-id">
                <label for="delivery_date">Delivery Date</label>
                <input type="date" id="delivery_date" name="delivery-date">

                <label for="status">Order Status</label>
                <select id="status" name="order-status">
                    <option value="PENDING">Pending</option>
                    <option value="SHIPPED">Shipped</option>
                    <option value="DELIVERED">Delivered</option>
                    <option value="CANCELLED">Canceled</option>
                </select>

                <button type="submit" class="browse-all-btn" id="modal-submit">Update Order</button>
            </form>
        </div>
    </div>
    <script>
    document.addEventListener('DOMContentLoaded', function() {
    	  	if ("<%=order_stat%>"!=""){
    	  		document.getElementById("statusFilter").value = "<%=order_stat%>";
    	  	}
    	});
        // Modal controls
        function openModal(button) {
        	
            document.getElementById('modal').style.display = "block";
            document.getElementById('modal-title').textContent = "Edit Order";
            document.getElementById('modal-submit').textContent = "Update Order";
            
            document.getElementById('order-id').value = button.getAttribute("order-id");
            document.getElementById('delivery_date').value = button.getAttribute("delivery-date");
            document.getElementById('status').value = button.getAttribute("order-status");
            
        }
        function closeModal() {
            document.getElementById('modal').style.display = "none";
            
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