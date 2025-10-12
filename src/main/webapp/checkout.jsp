<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %> 
<%@ page import="com.switchbit.dto.*" %>
<%@ page import="java.sql.Timestamp" %>
<%
   	Order order = (Order) session.getAttribute("order");
	List<OrderItemDTO> items = (List<OrderItemDTO>) session.getAttribute("items");
	User user  = (User) session.getAttribute("user");
	if (user == null){
    	response.sendRedirect("signin.jsp");
    }
	String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Checkout - SwitchBit</title>
  <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
  <style>
    body { font-family: Arial, sans-serif; margin: 0; background: #fafafa; color: #222; }
    .checkout-container { max-width: 1200px; margin: 0 auto; display: grid; grid-template-columns: 1fr 420px; gap: 40px; }
    .card { background: white; border-radius: 12px; padding: 24px; border: 1px solid #e0e0e0; box-shadow: 0 6px 18px rgba(0,0,0,0.04); }
    .small-card { margin-bottom: 16px; }
    .small-card .label { color: #666; font-size: 0.9rem; margin-bottom: 4px; }
    .small-card .value { font-weight: 600; }
    .address-line { font-size: 0.95rem; }
    .items-list { display: flex; flex-direction: column; gap: 12px; margin-top: 12px; }
    .item-row { display: flex; gap: 12px; align-items: center; }
    .item-thumb { width: 64px; height: 64px; background: #f8f9fa; border-radius: 8px; display: flex; align-items: center; justify-content: center; border: 1px solid #eaeaea; }
    .item-thumb img{ max-width: 100%; max-height: 100%; object-fit: contain; }
    .item-meta { flex: 1; }
    .amount { font-weight: 700; color: #2c5aa0; }
    .payment-methods { display: flex; gap: 12px; margin-top: 12px; }
    .method-pill { padding: 10px 14px; border-radius: 10px; border: 2px solid #e0e0e0; background: #fafafa; cursor: pointer; display: flex; gap: 8px; align-items: center; }
    .method-pill.active { border-color: #2c5aa0; background: #eef3fc; }
    .place-order-btn { width: 100%; padding: 14px 18px; border-radius: 10px; border: none; background: linear-gradient(135deg,#2c5aa0 0%,#1e3f73 100%); color: white; font-weight: 700; cursor: pointer; font-size: 1.05rem; margin-top: 20px; }
    .muted { color: #666; font-size: 0.9rem; }
    @media (max-width: 980px) { .checkout-container { grid-template-columns: 1fr; } }
    #toast-form { position: fixed; left: 50%; transform: translateX(-50%); bottom: 30px; z-index: 9999; display: none; background: #333; color: #fff; padding: 10px 14px; border-radius: 6px; }
  </style>
  
</head>
<body>
  <div class="page-container">
    <div class="header">
      <div class="company-logo">
        <div class="logo">
          <img width="30px" src="<%= request.getContextPath() %>/icons/mouse.png" alt="" />
        </div>
        <div class="title">SwitchBit</div>
      </div>

      <div class="nav">
        <ul>
          <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
          <li><a href="">About</a></li>
          <% if (user == null) { %>
            <li><a href="<%= request.getContextPath() %>/signup.jsp">Sign Up</a></li>
            <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
          <% } %>
          <li><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
        </ul>
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
    
    
    <main class="main">
    
   	 <%
   	 	if (order==null) { 
   	 		
   	 %>
   	 	<div class="page-container"> 
    		The payment cannot be processed because this order is either already paid or does not exist.
		</div>
	
   	 <%
   	 	} else {
   	 %>
      <div class="checkout-container">
        <!-- Billing / Shipping summary -->
        <section class="card">
          <h2>Billing & Shipping</h2>

          <div class="small-card">
            <div class="label">Name</div>
            <div class="value"><%=user.getUserName() %></div>
          </div>

          <div class="small-card">
            <div class="label">Shipping Address</div>
            <div class="address-line">
              <%=user.getUserAddress() %>
            </div>
          </div>

          <div class="small-card">
            <div class="label">Contact</div>
            <div class="value"><%=user.getUserPhone() %> & <%=user.getUserEmail() %></div>
          </div>
          <div class="payment-methods">
          
            <label class="method-pill active" data-method="debit" onclick="showPaymentInterface('debit')">
    			<input type="radio" name="paymentMethod" value="debit" checked hidden>
    			<img src="https://cdn-icons-png.flaticon.com/128/9334/9334539.png" alt="" width="28"/>
   		  		<div>
      				<div><b>Debit Card</b></div>
      				<div class="muted">Pay with your debit card</div>
    			</div>
  			</label>
  			
            <label class="method-pill" data-method="credit" onclick="showPaymentInterface('credit')">
    			<input type="radio" name="paymentMethod" value="credit" hidden>
    			<img src="https://cdn-icons-png.flaticon.com/128/8983/8983163.png" alt="" width="28"/>
	    		<div>
	      			<div><b>Credit Card</b></div>
	      			<div class="muted">Pay with your credit card</div>
	    		</div>
  			</label>
  			
            <label class="method-pill" data-method="upi" onclick="showPaymentInterface('upi')">
    			<input type="radio" name="paymentMethod" value="upi" hidden>
    			<img src="https://upload.wikimedia.org/wikipedia/commons/e/e1/UPI-Logo-vector.svg" alt="" width="28"/>
	    		<div>
	      			<div><b>UPI</b></div>
	      			<div class="muted">Fast & Secure</div>
	    		</div>
  			</label>
        </div>
        
        <form id="debitCardForm" class="payment-form" action="payment/processpayment" method="post" style="display:block;" onsubmit="return validateDebitCardForm()">
            <input type="hidden" name="paymentType" value="debit card">
            <div class="form-group">
                <label for="debitCardNumber">Card Number</label>
                <input type="text" id="debitCardNumber" name="cardNumber" maxlength="16" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="debitCardName">Name on Card</label>
                <input type="text" id="debitCardName" name="cardName" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="debitCardExpiry">Expiry (MM/YY)</label>
                <input type="text" id="debitCardExpiry" name="expiry" maxlength="5" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="debitCardCVV">CVV</label>
                <input type="password" id="debitCardCVV" name="cvv" maxlength="3" class="form-input" required>
            </div>
            <button type="submit" id="placeOrderBtn" class="place-order-btn">Place Order</button>
        </form>
        
         <form id="creditCardForm" class="payment-form" action="payment/processpayment" method="post" style="display:none;" onsubmit="return validateCreditCardForm()">
            <input type="hidden" name="paymentType" value="credit card">
            <div class="form-group">
                <label for="creditCardNumber">Card Number</label>
                <input type="text" id="creditCardNumber" name="cardNumber" maxlength="16" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="creditCardName">Name on Card</label>
                <input type="text" id="creditCardName" name="cardName" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="creditCardExpiry">Expiry (MM/YY)</label>
                <input type="text" id="creditCardExpiry" name="expiry" maxlength="5" class="form-input" required>
            </div>
            <div class="form-group">
                <label for="creditCardCVV">CVV</label>
                <input type="password" id="creditCardCVV" name="cvv" maxlength="3" class="form-input" required>
            </div>
            <button type="submit" id="placeOrderBtn" class="place-order-btn">Place Order</button>
        </form>
        
        
        <form id="upiForm" class="payment-form" action="payment/processpayment" method="post" style="display:none;" onsubmit="return validateUpiForm()">
            <input type="hidden" name="paymentType" value="upi">
            <div class="form-group">
                <label for="upiId">UPI ID</label>
                <input type="text" id="upiId" name="upiId" class="form-input" required>
            </div>
            <button type="submit" id="placeOrderBtn" class="place-order-btn">Place Order</button>
        </form>
        </section>
        
        
        

        <!-- Order summary -->
        <aside class="card">
          <h3>Your Order</h3>
          <%
          	for (OrderItemDTO item : items){
          %>
          <div class="items-list">
            <div class="item-row">
              <div class="item-thumb"><img src="<%=request.getContextPath() %>/<%=item.getProduct().getProduct_img() %>" alt="<%=item.getProduct().getProduct_name()%>"/></div>
              <div class="item-meta"><div><b><%=item.getProduct().getProduct_name() %></b></div><div class="muted">Qty: <%=item.getOrderItem().getQuantity() %></div></div>
              <div class="amount"><%=item.getProduct().getPrice() %></div>
            </div>
          </div>
          <%
          	}
          %>

          <hr/>

          <div style="display:flex; justify-content:space-between; margin: 6px 0;">
            <div class="muted">Subtotal</div>
            <div><%=order.getTotal_amount() %></div>
          </div>
          <div style="display:flex; justify-content:space-between; margin: 6px 0;">
            <div class="muted">Shipping</div>
            <div>Free</div>
          </div>
          <div style="display:flex; justify-content:space-between; margin-top: 10px; font-weight: bold; font-size: 1.05rem;">
            <div>Total</div>
            <div><%=order.getTotal_amount() %></div>
          </div>
        </aside>
      </div>
      
      <%
   	 	}
      %>
    </main>
    
  <script>
  
	const contextPath = "<%= request.getContextPath() %>" ;
  
    document.getElementById('placeOrderBtn').addEventListener('click', function() {
      const toast = document.getElementById('toast');
      toast.style.display = 'block';
      setTimeout(()=> toast.style.display='none', 3000);
      alert("Order created with status: PENDING. Redirecting to UPI payment...");
    });
    
    document.querySelectorAll(".method-pill").forEach(pill => {
    	  pill.addEventListener("click", () => {
    	    document.querySelectorAll(".method-pill").forEach(p => p.classList.remove("active"));
    	    pill.classList.add("active");
    	    pill.querySelector("input").checked = true; // update the hidden radio
    	  });
    	});
    
    function showPaymentInterface(method) {
        document.getElementById('debitCardForm').style.display = (method === 'debit') ? 'block' : 'none';
        document.getElementById('creditCardForm').style.display = (method === 'credit') ? 'block' : 'none';
        document.getElementById('upiForm').style.display = (method === 'upi') ? 'block' : 'none';

        // Highlight selected payment method
        let labels = document.querySelectorAll('.payment-methods label');
        labels.forEach(l => l.classList.remove('selected'));
        if (method === 'debit') labels[0].classList.add('selected');
        if (method === 'credit') labels[1].classList.add('selected');
        if (method === 'upi') labels[2].classList.add('selected');
    }

    function validateDebitCardForm() {
        var cardNumber = document.getElementById('debitCardNumber').value;
        var name = document.getElementById('debitCardName').value;
        var expiry = document.getElementById('debitCardExpiry').value;
        var cvv = document.getElementById('debitCardCVV').value;
        if(!/^\d{13,19}$/.test(cardNumber) || isNaN(cardNumber)) {
            showToast('Please enter a valid 16-digit Debit Card Number');
            return false;
        }
        if(name.trim() === '') {
            showToast('Please enter the Name on Card');
            return false;
        }
        if(!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
            showToast('Please enter valid Expiry (MM/YY)');
            return false;
        }
        if(cvv.length !== 3 || isNaN(cvv)) {
            showToast('Please enter valid 3-digit CVV');
            return false;
        }
        return true;
    }

    function validateCreditCardForm() {
        var cardNumber = document.getElementById('creditCardNumber').value;
        var name = document.getElementById('creditCardName').value;
        var expiry = document.getElementById('creditCardExpiry').value;
        var cvv = document.getElementById('creditCardCVV').value;
        if(!/^\d{13,19}$/.test(cardNumber) || isNaN(cardNumber)) {
            showToast('Please enter a valid Credit Card Number');
            return false;
        }
        if(name.trim() === '') {
            showToast('Please enter the Name on Card');
            return false;
        }
        if(!/^(0[1-9]|1[0-2])\/\d{2}$/.test(expiry)) {
            showToast('Please enter valid Expiry (MM/YY)');
            return false;
        }
        if(cvv.length !== 3 || isNaN(cvv)) {
            showToast('Please enter valid 3-digit CVV');
            return false;
        }
        return true;
    }

    function validateUpiForm() {
        var upiId = document.getElementById('upiId').value;
        if(!/^[\w.-]+@[\w.-]+$/.test(upiId)) {
            showToast('Please enter a valid UPI ID');
            return false;
        }
        return true;
    }

    function showToast(msg) {
        var toast_form = document.getElementById("toast-form");
        toast_form.innerText = msg;
        toast_form.className = "show";
        setTimeout(function(){ toast_form.className = toast_form.className.replace("show", ""); }, 3000);
    }
    window.onload = function() { showPaymentInterface('debit'); }
    
	// Handline Popup Messages
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
