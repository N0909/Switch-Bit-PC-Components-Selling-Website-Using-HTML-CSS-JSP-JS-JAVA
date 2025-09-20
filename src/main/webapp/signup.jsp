<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.util.PaginatedResult" %>
<%@ page import="com.switchbit.model.*" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign Up - SwitchBit</title>
    <link rel="stylesheet" href="css/style.css" />
  </head>
  <body>
    <div class="page-container">
    <div class="header">
      <div class="company-logo">
        <div class="logo">
          <img width="30px" src="icons/mouse.png" alt="" />
        </div>
        <div class="title">SwitchBit</div>
      </div>

      <div class="nav">
        <ul>
          <li><a href="index.html">Home</a></li>
          <li><a href="">About</a></li>
          <li class="active"><a href="signup.html">Sign Up</a></li>
          <li><a href="">Contact</a></li>
        </ul>
      </div>

      <div class="side-container">
        <div class="search-container">
          <div class="search-input">
            <input
              type="text"
              placeholder="Search products..."
              name="search-query"
              class="search-field"
            />
            <button class="search-btn" type="submit">
              <img width="16px" src="icons/search-interface-symbol.png" alt="Search" />
            </button>
          </div>
        </div>
        <div class="cart-container">
          <div class="side-icon">
            <img width="20px" src="icons/shopping-cart.png" alt="c" />
          </div>
        </div>
        <div class="account-container">
          <div class="side-icon profile-trigger">
            <img width="20px" src="icons/profile-icon.png" alt="Profile" />
          </div>
          <div class="profile-dropdown">
            <div class="dropdown-item">
              <span class="dropdown-icon">📦</span>
              <span>Your Orders</span>
            </div>
            <div class="dropdown-item">
              <span class="dropdown-icon">⚙️</span>
              <span>Manage Account</span>
            </div>
            <div class="dropdown-divider"></div>
            <div class="dropdown-item logout">
              <span class="dropdown-icon">🚪</span>
              <span>Logout</span>
            </div>
          </div>
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
          
          <form class="signup-form" id="signupForm">
            <div class="form-group">
              <label for="name">Full Name *</label>
              <input 
                type="text" 
                id="name" 
                name="name" 
                required 
                placeholder="Enter your full name"
                class="form-input"
              />
              <span class="error-message" id="nameError"></span>
            </div>

            <div class="form-group">
              <label for="email">Email Address *</label>
              <input 
                type="email" 
                id="email" 
                name="email" 
                required 
                placeholder="Enter your email address"
                class="form-input"
              />
              <span class="error-message" id="emailError"></span>
            </div>

            <div class="form-group">
              <label for="phone">Phone Number *</label>
              <input 
                type="tel" 
                id="phone" 
                name="phone" 
                required 
                placeholder="Enter your phone number"
                class="form-input"
              />
              <span class="error-message" id="phoneError"></span>
            </div>

            <div class="form-group">
              <label for="address">Address (Optional)</label>
              <textarea 
                id="address" 
                name="address" 
                placeholder="Enter your address"
                class="form-input"
                rows="3"
              ></textarea>
            </div>

            <div class="form-group">
              <label for="password">Password *</label>
              <div class="password-input-wrapper">
                <input 
                  type="password" 
                  id="password" 
                  name="password" 
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

            <!-- <div class="form-group checkbox-group">
              <label class="checkbox-label">
                <input type="checkbox" id="terms" name="terms" required />
                <span class="checkmark"></span>
                I agree to the <a href="#" class="terms-link">Terms of Service</a> and <a href="#" class="terms-link">Privacy Policy</a>
              </label>
              <span class="error-message" id="termsError"></span>
            </div> -->

            <button type="submit" class="signup-btn">
              <span class="btn-text">Create Account</span>
              <span class="btn-loader" style="display: none;">⏳</span>
            </button>

            <div class="login-link">
              <p>Already have an account? <a href="signin.html" class="login-link-text">Sign In</a></p>
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
        const profileTrigger = document.querySelector('.profile-trigger');
        const profileDropdown = document.querySelector('.profile-dropdown');
        const accountContainer = document.querySelector('.account-container');
        
        // Toggle dropdown on click
        profileTrigger.addEventListener('click', function(e) {
          e.stopPropagation();
          const isVisible = profileDropdown.style.opacity === '1';
          
          if (isVisible) {
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          } else {
            profileDropdown.style.opacity = '1';
            profileDropdown.style.visibility = 'visible';
            profileDropdown.style.transform = 'translateY(0)';
          }
        });
        
        // Close dropdown when clicking outside
        document.addEventListener('click', function(e) {
          if (!accountContainer.contains(e.target)) {
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          }
        });
        
        // Handle dropdown item clicks
        const dropdownItems = document.querySelectorAll('.dropdown-item');
        dropdownItems.forEach(item => {
          item.addEventListener('click', function() {
            const text = this.querySelector('span:last-child').textContent;
            
            // Handle different actions
            if (text === 'Your Orders') {
              alert('Redirecting to Your Orders page...');
              // Add your navigation logic here
            } else if (text === 'Manage Account') {
              alert('Redirecting to Account Management...');
              // Add your navigation logic here
            } else if (text === 'Logout') {
              if (confirm('Are you sure you want to logout?')) {
                alert('Logging out...');
                // Add your navigation logic here
              }
            }
            
            // Close dropdown after action
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          });
        });

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
          e.preventDefault();
          
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
          const terms = document.getElementById('terms').checked;

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

          // Validate terms
          if (!terms) {
            showError('terms', 'You must agree to the terms and conditions');
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

            // Simulate form submission
            setTimeout(() => {
              alert('Account created successfully! Welcome to SwitchBit!');
              // Reset form
              signupForm.reset();
              btnText.style.display = 'inline';
              btnLoader.style.display = 'none';
              submitBtn.disabled = false;
            }, 2000);
          }
        });
      });
    </script>
  </body>
</html>
