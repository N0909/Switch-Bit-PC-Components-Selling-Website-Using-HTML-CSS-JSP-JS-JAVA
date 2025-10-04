<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <meta charset="UTF-8">
    <title>Admin Sign In - SwitchBit</title>
     <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css" />
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
    <div class="main">
      <div class="signin-container">
        <div class="signin-form-wrapper">
          <div class="signin-header">
            <h2>Welcome Back</h2>
            <p>Sign in to your SwitchBit Admin account</p>
          </div>
          
          <form method="post" action="<%=request.getContextPath()%>/admin/signin" class="signin-form" id="signinForm">
            <div class="form-group">
              <label for="identifier">Admin ID/UserName/Email*</label>
              <input 
                type="text" 
                id="identifier" 
                name="admin_identifier" 
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
                  name="password" 
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
          </form>
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
        function validateIdentifier(identifier) {
            if (validateEmail(identifier)) return { isValid: true, type: 'email' };
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
            if (fieldId === 'password') {
                if (!value) { showError(fieldId, 'Password is required'); return false; }
                if (value.length < 8) { showError(fieldId, 'Password must be at least 8 characters'); return false; }
            }
            clearError(fieldId);
            return true;
        }

        // Check overall form validity
        function checkFormValidity() {
            const allValid = ['password'].every(validateField);
            submitBtn.disabled = !allValid;
        }

        // Real-time validation
        ['password'].forEach(id => {
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