<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%
	String error = (String) session.getAttribute("errorMessage");
	String flash = (String) session.getAttribute("flashMessage");
    User user = (User) session.getAttribute("user");
    if (user != null) {
        response.sendRedirect("signin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>SwitchBit - Payment</title>
    <link rel="stylesheet" type="text/css" href="<%=request.getContextPath() %>/css/style.css">
    
    <style>
        .payment-container {
            background: white;
            border-radius: 16px;
            box-shadow: 0 10px 40px rgba(0,0,0,0.10);
            padding: 40px;
            max-width: 500px;
            margin: 40px auto;
            border: 1px solid #e0e0e0;
        }
        .payment-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .payment-header h2 {
            color: #333;
            font-size: 2rem;
            font-weight: 700;
        }
        .payment-methods {
            display: flex;
            justify-content: center;
            gap: 35px;
            margin-bottom: 30px;
        }
        .payment-methods label {
            font-weight: 600;
            color: #2c5aa0;
            background: #f8f9fa;
            padding: 12px 20px;
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 2px solid #e0e0e0;
        }
        .payment-methods input[type="radio"] {
            margin-right: 10px;
        }
        .payment-methods label:hover, .payment-methods label.selected {
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3f73 100%);
            color: white;
            border-color: #2c5aa0;
        }
        .payment-form {
            display: flex;
            flex-direction: column;
            gap: 20px;
            margin-bottom: 10px;
        }
        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-group label {
            font-weight: 600;
            color: #333;
            font-size: 0.95rem;
        }
        .form-input {
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fafafa;
        }
        .form-input:focus {
            outline: none;
            border-color: #2c5aa0;
            background: white;
            box-shadow: 0 0 0 3px rgba(44,90,160,0.1);
        }
        .pay-btn {
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3f73 100%);
            color: white;
            margin: 10px 0px;
            border: none;
            border-radius: 8px;
            padding: 14px 24px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .pay-btn:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px rgba(44,90,160,0.4);
        }
        .pay-btn:disabled {
            opacity: 0.7;
            cursor: not-allowed;
        }
        @media only screen and (max-width: 600px) {
            .payment-container {
                padding: 20px 10px;
                margin: 15px;
            }
            .payment-header h2 {
                font-size: 1.3rem;
            }
            .payment-methods {
                gap: 10px;
                flex-direction: column;
            }
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
  
    </div>

    <div class="payment-container">
    
        <div class="payment-header">
            <h2>Payment</h2>
        </div>
        <div class="payment-methods">
            <label class="selected">
                <input type="radio" name="paymentMethod" value="debit" onclick="showPaymentInterface('debit')" checked>
                Debit Card
            </label>
            <label>
                <input type="radio" name="paymentMethod" value="credit" onclick="showPaymentInterface('credit')">
                Credit Card
            </label>
            <label>
                <input type="radio" name="paymentMethod" value="upi" onclick="showPaymentInterface('upi')">
                UPI
            </label>
        </div>

        <!-- Debit Card Form -->
        <form id="debitCardForm" class="payment-form" action="ProcessPaymentServlet" method="post" style="display:block;" onsubmit="return validateDebitCardForm()">
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
            <button type="submit" class="pay-btn">Pay Now</button>
        </form>

        <!-- Credit Card Form -->
        <form id="creditCardForm" class="payment-form" action="ProcessPaymentServlet" method="post" style="display:none;" onsubmit="return validateCreditCardForm()">
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
            <button type="submit" class="pay-btn">Pay Now</button>
        </form>

        <!-- UPI Form -->
        <form id="upiForm" class="payment-form" action="ProcessPaymentServlet" method="post" style="display:none;" onsubmit="return validateUpiForm()">
            <input type="hidden" name="paymentType" value="upi">
            <div class="form-group">
                <label for="upiId">UPI ID</label>
                <input type="text" id="upiId" name="upiId" class="form-input" required>
            </div>
            <button type="submit" class="pay-btn">Pay Now</button>
        </form>
        
    </div>
    <div id="toast"></div>
    
    <script>
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
            if(cardNumber.length !== 16 || isNaN(cardNumber)) {
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
            if(cardNumber.length !== 16 || isNaN(cardNumber)) {
                showToast('Please enter a valid 16-digit Credit Card Number');
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
            var toast = document.getElementById("toast");
            toast.innerText = msg;
            toast.className = "show";
            setTimeout(function(){ toast.className = toast.className.replace("show", ""); }, 3000);
        }
        window.onload = function() { showPaymentInterface('debit'); }
    </script>
    
</body>
</html>