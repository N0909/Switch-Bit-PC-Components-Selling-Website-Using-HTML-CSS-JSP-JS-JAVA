<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.model.*" %>

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

    <div class="main">
      <div class="signup-container">
        <div class="signup-form-wrapper">
          <div class="signup-header">
            <h2>Create Your Account</h2>
            <p>Join SwitchBit and start shopping for the best tech products</p>
          </div>
          
        
          <%
        	String error = (String) session.getAttribute("errorMessage");
        	if (error!=null){
          %>
          <div class="error-message"><%=error %></div>
          <%
          		session.removeAttribute("errorMessage");
        	}
          %>
          
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
      // Profile dropdown functionality
      document.addEventListener('DOMContentLoaded', function() {
       
        // Signup form functionality
        const signupForm = document.getElementById('signupForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const confirmPasswordToggle = document.getElementById('confirmPasswordToggle');
        const passwordInput = document.getElementById('password');
        const confirmPasswordInput = document.getElementById('confirmPassword');

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
          const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          passwordInput.setAttribute('type', type);
          this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
        });

        confirmPasswordToggle.addEventListener('click', function() {
          const type = confirmPasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          confirmPasswordInput.setAttribute('type', type);
          this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
        });

        // Form validation
        function validateEmail(email) {
          const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
          return emailRegex.test(email);
        }

        function validatePhone(phone) {
          const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
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

        // Real-time validation
        document.getElementById('email').addEventListener('blur', function() {
          const email = this.value.trim();
          if (email && !validateEmail(email)) {
            showError('email', 'Please enter a valid email address');
          } else {
            clearError('email');
          }
        });

        document.getElementById('phone').addEventListener('blur', function() {
          const phone = this.value.trim();
          if (phone && !validatePhone(phone)) {
            showError('phone', 'Please enter a valid phone number (10-15 digits)');
          } else {
            clearError('phone');
          }
        });

        document.getElementById('password').addEventListener('blur', function() {
          const password = this.value;
          if (password && !validatePassword(password)) {
            showError('password', 'Password must be at least 8 characters long');
          } else {
            clearError('password');
          }
        });

        document.getElementById('confirmPassword').addEventListener('blur', function() {
          const password = document.getElementById('password').value;
          const confirmPassword = this.value;
          if (confirmPassword && password !== confirmPassword) {
            showError('confirmPassword', 'Passwords do not match');
          } else {
            clearError('confirmPassword');
          }
        });

        // Form submission
        signupForm.addEventListener('submit', function(e) {
          
          // Clear previous errors
          const errorElements = document.querySelectorAll('.error-message');
          errorElements.forEach(element => element.textContent = '');
          
          const inputs = document.querySelectorAll('.form-input');
          inputs.forEach(input => input.classList.remove('error'));

          // Get form values
          const name = document.getElementById('name').value.trim();
          const email = document.getElementById('email').value.trim();
          const phone = document.getElementById('phone').value.trim();
          const address = document.getElementById('address').value.trim();
          const password = document.getElementById('password').value;
          const confirmPassword = document.getElementById('confirmPassword').value;
      

          let isValid = true;

          // Validate name
          if (!name) {
            showError('name', 'Name is required');
            isValid = false;
          }

          // Validate email
          if (!email) {
            showError('email', 'Email is required');
            isValid = false;
          } else if (!validateEmail(email)) {
            showError('email', 'Please enter a valid email address');
            isValid = false;
          }

          // Validate phone
          if (!phone) {
            showError('phone', 'Phone number is required');
            isValid = false;
          } else if (!validatePhone(phone)) {
            showError('phone', 'Please enter a valid phone number (10-15 digits)');
            isValid = false;
          }

          // Validate password
          if (!password) {
            showError('password', 'Password is required');
            isValid = false;
          } else if (!validatePassword(password)) {
            showError('password', 'Password must be at least 8 characters long');
            isValid = false;
          }

          // Validate confirm password
          if (!confirmPassword) {
            showError('confirmPassword', 'Please confirm your password');
            isValid = false;
          } else if (password !== confirmPassword) {
            showError('confirmPassword', 'Passwords do not match');
            isValid = false;
          }

          if (isValid) {
        	    // Show loading state
        	    const submitBtn = document.querySelector('.signup-btn');
        	    const btnText = document.querySelector('.btn-text');
        	    const btnLoader = document.querySelector('.btn-loader');
        	    
        	    btnText.style.display = 'none';
        	    btnLoader.style.display = 'inline';
        	    submitBtn.disabled = true;

        	    // Get context path from JSP
        	    const contextPath = '<%= request.getContextPath() %>

        	    // Collect form data
        	    const form = document.getElementById('signupForm');
        	    const formData = new FormData(form);

        	    // Send POST request to servlet
        	    fetch(contextPath + '/user/signup', {
        	        method: 'POST',
        	        body: formData
        	    })
        )});
    </script>
  </body>
</html>
