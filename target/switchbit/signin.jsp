<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.util.PaginatedResult" %>
<%@ page import="com.switchbit.model.*" %>
<%
	String successMessage = (String) session.getAttribute("successMessage");
	String errorMessage = (String) session.getAttribute("errorMessage");
	session.removeAttribute("successMessage");
	session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In - SwitchBit</title>
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
          <li><a href="<%=request.getContextPath()%>/signup.jsp">Sign Up</a></li>
          <li class="active"><a href="<%=request.getContextPath()%>/signin.jsp">Sign In</a></li>
          <li><a href="<%=request.getContextPath()%>/contact.jsp">Contact</a></li>
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
	
    <div class="main">
      <div class="signin-container">
        <div class="signin-form-wrapper">
          <div class="signin-header">
            <h2>Welcome Back</h2>
            <p>Sign in to your SwitchBit account</p>
          </div>
          
          <form method="post" action="<%=request.getContextPath()%>/user/login" class="signin-form" id="signinForm">
            <div class="form-group">
              <input type="hidden" name="page-referer" value=<%=request.getHeader("referer") %>>
              <label for="identifier">Email or Mobile Number *</label>
              <input 
                type="text" 
                id="identifier" 
                name="user-identifier" 
                required 
                placeholder="Enter your email or mobile number"
                class="form-input"
              />
              <span class="error-message" id="identifierError"></span>
            </div>

            <div class="form-group">
              <label for="password">Password *</label>
              <div class="password-input-wrapper">
                <input 
                  type="password" 
                  id="password" 
                  name="user-password" 
                  required 
                  placeholder="Enter your password"
                  class="form-input"
                />
                <button type="button" class="password-toggle" id="passwordToggle">
                  <span class="toggle-icon">🙈</span>
                </button>
              </div>
              <span class="error-message" id="passwordError"></span>
            </div>

            <button type="submit" class="signin-btn">
              <span class="btn-text">Sign In</span>
              <span class="btn-loader" style="display: none;">⏳</span>
            </button>

            <div class="signup-link">
              <p>Don't have an account? <a href="<%=request.getContextPath() %>/signup.jsp" class="signup-link-text">Create Account</a></p>
            </div>
          </form>
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
        <p>Â© 2025 SwitchBit. All Rights Reserved.</p>
      </div>
    </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {

        const signinForm = document.getElementById('signinForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const passwordInput = document.getElementById('password');
        const identifierInput = document.getElementById('identifier');
        const submitBtn = document.querySelector('.signin-btn');

        submitBtn.disabled = true; // Start disabled

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
            const type = passwordInput.type === 'password' ? 'text' : 'password';
            passwordInput.type = type;
            this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
        });

        // Validation functions
        function validateEmail(email) {
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return emailRegex.test(email);
        }

        function validatePhone(phone) {
            const cleanPhone = phone.replace(/\D/g, '');
            return cleanPhone.length >= 10 && cleanPhone.length <= 15;
        }

        function validateIdentifier(identifier) {
            if (validateEmail(identifier)) return { isValid: true, type: 'email' };
            if (validatePhone(identifier)) return { isValid: true, type: 'phone' };
            return { isValid: false, type: 'invalid' };
        }

        function showError(fieldId, message) {
            const errorElement = document.getElementById(fieldId + 'Error');
            const inputElement = document.getElementById(fieldId);
            errorElement.textContent = message;
            inputElement.classList.add('error');
        }

        function clearError(fieldId) {
            const errorElement = document.getElementById(fieldId + 'Error');
            const inputElement = document.getElementById(fieldId);
            errorElement.textContent = '';
            inputElement.classList.remove('error');
        }

        // Validate a single field
        function validateField(fieldId) {
            const value = document.getElementById(fieldId).value.trim();
            if (fieldId === 'identifier') {
                if (!value) { showError(fieldId, 'Email or phone is required'); return false; }
                const validation = validateIdentifier(value);
                if (!validation.isValid) { showError(fieldId, 'Please enter a valid email or phone'); return false; }
            }
            if (fieldId === 'password') {
                if (!value) { showError(fieldId, 'Password is required'); return false; }
                if (value.length < 8) { showError(fieldId, 'Password must be at least 8 characters'); return false; }
            }
            clearError(fieldId);
            return true;
        }

        // Check overall form validity
        function checkFormValidity() {
            const allValid = ['identifier', 'password'].every(validateField);
            submitBtn.disabled = !allValid;
        }

        // Real-time validation
        ['identifier', 'password'].forEach(id => {
            const input = document.getElementById(id);
            input.addEventListener('input', checkFormValidity);
            input.addEventListener('blur', () => validateField(id));
        });

        // Form submission
        signinForm.addEventListener('submit', function(e) {
            checkFormValidity();

            if (!submitBtn.disabled) {
                const btnText = document.querySelector('.btn-text');
                const btnLoader = document.querySelector('.btn-loader');

                btnText.style.display = 'none';
                btnLoader.style.display = 'inline';
                submitBtn.disabled = true; // Prevent double submission

            }
        });
        
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
    });
    </script>
  </body>
</html>
