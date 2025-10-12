<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
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
    <title>Sign Up - SwitchBit</title>
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
          <li><a href="<%=request.getContextPath()%>/about.html">About</a></li>
          <li class="active"><a href="<%=request.getContextPath()%>/signup.jsp">Sign Up</a></li>
          <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
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
      <div class="signup-container">
        <div class="signup-form-wrapper">
          <div class="signup-header">
            <h2>Create Your Account</h2>
            <p>Join SwitchBit and start shopping for the best tech products</p>
          </div>
          
          
          <form method="post" class="signup-form" id="signupForm" action="<%= request.getContextPath() %>/user/signup">
            <div class="form-group">
              <label for="user-name">Full Name *</label>
              <input 
                type="text" 
                id="name" 
                name="user-name" 
                required 
                placeholder="Enter your full name"
                class="form-input"
              />
              <span class="error-message" id="nameError"></span>
            </div>

            <div class="form-group">
              <label for="user-email">Email Address *</label>
              <input 
                type="email" 
                id="email" 
                name="user-email" 
                required 
                placeholder="Enter your email address"
                class="form-input"
              />
              <span class="error-message" id="emailError"></span>
            </div>

            <div class="form-group">
              <label for="user-phone">Phone Number *</label>
              <input 
                type="tel" 
                id="phone" 
                name="user-phone" 
                required 
                placeholder="Enter your phone number"
                class="form-input"
              />
              <span class="error-message" id="phoneError"></span>
            </div>

            <div class="form-group">
              <label for="user-address">Address (Optional)</label>
              <textarea 
                id="address" 
                name="user-address" 
                placeholder="Enter your address"
                class="form-input"
                rows="3"
              ></textarea>
            </div>

            <div class="form-group">
              <label for="user-password">Password *</label>
              <div class="password-input-wrapper">
                <input 
                  type="password" 
                  id="password" 
                  name="user-password" 
                  required 
                  placeholder="Create a strong password"
                  class="form-input"
                />
                <button type="button" class="password-toggle" id="passwordToggle">
                  <span class="toggle-icon">👁️</span>
                </button>
              </div>
              <span class="error-message" id="passwordError"></span>
            </div>

            <div class="form-group">
              <label for="confirmPassword">Confirm Password *</label>
              <div class="password-input-wrapper">
                <input 
                  type="password" 
                  id="confirmPassword" 
                  name="confirmPassword" 
                  required 
                  placeholder="Confirm your password"
                  class="form-input"
                />
                <button type="button" class="password-toggle" id="confirmPasswordToggle">
                  <span class="toggle-icon">👁️</span>
                </button>
              </div>
              <span class="error-message" id="confirmPasswordError"></span>
            </div>
            
            <button type="submit" class="signup-btn">
              <span class="btn-text">Create Account</span>
              <span class="btn-loader" style="display: none;">⏳</span>
            </button>

            <div class="login-link">
              <p>Already have an account? <a href="<%=request.getContextPath()%>/signin.jsp" class="login-link-text">Sign In</a></p>
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
        <p>© 2025 SwitchBit. All Rights Reserved.</p>
      </div>
    </div>
    </div>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
    	
        const signupForm = document.getElementById('signupForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const confirmPasswordToggle = document.getElementById('confirmPasswordToggle');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');
        const submitBtn = document.querySelector('.signup-btn');

        submitBtn.disabled = true; // Start with button disabled

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
            const type = passwordInput.type === 'password' ? 'text' : 'password';
            passwordInput.type = type;
            this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
        });

        confirmPasswordToggle.addEventListener('click', function() {
            const type = confirmPasswordInput.type === 'password' ? 'text' : 'password';
            confirmPasswordInput.type = type;
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

        function validatePassword(password) {
            return password.length >= 8;
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

        // Validate a single field and return boolean
        function validateField(fieldId) {
            const value = document.getElementById(fieldId).value.trim();
            switch (fieldId) {
                case 'name':
                    if (!value) { showError(fieldId, 'Name is required'); return false; }
                    break;
                case 'email':
                    if (!value) { showError(fieldId, 'Email is required'); return false; }
                    if (!validateEmail(value)) { showError(fieldId, 'Please enter a valid email'); return false; }
                    break;
                case 'phone':
                    if (!value) { showError(fieldId, 'Phone number is required'); return false; }
                    if (!validatePhone(value)) { showError(fieldId, 'Please enter a valid phone number (10-15 digits)'); return false; }
                    break;
                case 'password':
                    if (!value) { showError(fieldId, 'Password is required'); return false; }
                    if (!validatePassword(value)) { showError(fieldId, 'Password must be at least 8 characters'); return false; }
                    break;
                case 'confirmPassword':
                    const password = document.getElementById('password').value;
                    if (!value) { showError(fieldId, 'Please confirm your password'); return false; }
                    if (value !== password) { showError(fieldId, 'Passwords do not match'); return false; }
                    break;
                default:
                    break;
            }
            clearError(fieldId);
            return true;
        }

        // Check all fields and enable/disable submit button
        function checkFormValidity() {
            const fields = ['name', 'email', 'phone', 'password', 'confirmPassword'];
            const allValid = fields.every(validateField);
            submitBtn.disabled = !allValid;
        }

        // real-time validation on blur
        ['name', 'email', 'phone', 'password', 'confirmPassword'].forEach(id => {
            const input = document.getElementById(id);
            input.addEventListener('input', checkFormValidity);
            input.addEventListener('blur', () => validateField(id));
        });

        // Form submission
        signupForm.addEventListener('submit', function(e) {

            // Final validation before submission
            checkFormValidity();

            if (!submitBtn.disabled) {
                const btnText = document.querySelector('.btn-text');
                const btnLoader = document.querySelector('.btn-loader');

                btnText.style.display = 'none';
                btnLoader.style.display = 'inline';
                submitBtn.disabled = true; // prevent double submission
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
