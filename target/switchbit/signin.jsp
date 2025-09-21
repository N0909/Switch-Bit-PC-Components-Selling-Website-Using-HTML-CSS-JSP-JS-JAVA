<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.util.PaginatedResult" %>
<%@ page import="com.switchbit.model.*" %>
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

    <div class="main">
      <div class="signin-container">
        <div class="signin-form-wrapper">
          <div class="signin-header">
            <h2>Welcome Back</h2>
            <p>Sign in to your SwitchBit account</p>
          </div>
          
          <%
          	String error = (String) request.getAttribute("errorMessage");
          	if (error!=null){
          %>
          <div class="error-message"><%= error %></div>
          <%
          	}
          %>
          
          <form method="post" action="<%=request.getContextPath()%>/user/login" class="signin-form" id="signinForm">
            <div class="form-group">
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
              <span class="btn-loader" style="display: none;">â³</span>
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
      // Profile dropdown functionality
      document.addEventListener('DOMContentLoaded', function() {

                
        // Signin form functionality
        const signinForm = document.getElementById('signinForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const passwordInput = document.getElementById('password');

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
          const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          passwordInput.setAttribute('type', type);
          this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
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

        function validateIdentifier(identifier) {
          // Check if it's an email or phone number
          if (validateEmail(identifier)) {
            return { isValid: true, type: 'email' };
          } else if (validatePhone(identifier)) {
            return { isValid: true, type: 'phone' };
          }
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

        // Real-time validation for identifier
        document.getElementById('identifier').addEventListener('blur', function() {
          const identifier = this.value.trim();
          if (identifier) {
            const validation = validateIdentifier(identifier);
            if (!validation.isValid) {
              showError('identifier', 'Please enter a valid email address or phone number');
            } else {
              clearError('identifier');
            }
          }
        });

        // Real-time validation for password
        document.getElementById('password').addEventListener('blur', function() {
          const password = this.value;
          if (password && password.length < 8) {
            showError('password', 'Password must be at least 8 characters long');
          } else {
            clearError('password');
          }
        });
        
        

      });
    </script>
  </body>
</html>
