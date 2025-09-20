<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Sign In - SwitchBit</title>
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
          <li><a href="signup.html">Sign Up</a></li>
          <li class="active"><a href="signin.html">Sign In</a></li>
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
      <div class="signin-container">
        <div class="signin-form-wrapper">
          <div class="signin-header">
            <h2>Welcome Back</h2>
            <p>Sign in to your SwitchBit account</p>
          </div>
          
          <form class="signin-form" id="signinForm">
            <div class="form-group">
              <label for="identifier">Email or Mobile Number *</label>
              <input 
                type="text" 
                id="identifier" 
                name="identifier" 
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
                  <span class="toggle-icon">👁️</span>
                </button>
              </div>
              <span class="error-message" id="passwordError"></span>
            </div>

            <!-- <div class="form-options">
              <label class="checkbox-label">
                <input type="checkbox" id="rememberMe" name="rememberMe" />
                <span class="checkmark"></span>
                Remember me
              </label>
              <a href="#" class="forgot-password">Forgot Password?</a>
            </div> -->

            <button type="submit" class="signin-btn">
              <span class="btn-text">Sign In</span>
              <span class="btn-loader" style="display: none;">⏳</span>
            </button>

            <div class="signup-link">
              <p>Don't have an account? <a href="signup.html" class="signup-link-text">Create Account</a></p>
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
                // Add your logout logic here
              }
            }
            
            // Close dropdown after action
            profileDropdown.style.opacity = '0';
            profileDropdown.style.visibility = 'hidden';
            profileDropdown.style.transform = 'translateY(-10px)';
          });
        });

        // Signin form functionality
        const signinForm = document.getElementById('signinForm');
        const passwordToggle = document.getElementById('passwordToggle');
        const passwordInput = document.getElementById('password');

        // Password toggle functionality
        passwordToggle.addEventListener('click', function() {
          const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          passwordInput.setAttribute('type', type);
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
          if (password && password.length < 6) {
            showError('password', 'Password must be at least 6 characters long');
          } else {
            clearError('password');
          }
        });

        // Form submission
        signinForm.addEventListener('submit', function(e) {
          e.preventDefault();
          
          // Clear previous errors
          const errorElements = document.querySelectorAll('.error-message');
          errorElements.forEach(element => element.textContent = '');
          
          const inputs = document.querySelectorAll('.form-input');
          inputs.forEach(input => input.classList.remove('error'));

          // Get form values
          const identifier = document.getElementById('identifier').value.trim();
          const password = document.getElementById('password').value;
          const rememberMe = document.getElementById('rememberMe').checked;

          let isValid = true;

          // Validate identifier
          if (!identifier) {
            showError('identifier', 'Email or mobile number is required');
            isValid = false;
          } else {
            const validation = validateIdentifier(identifier);
            if (!validation.isValid) {
              showError('identifier', 'Please enter a valid email address or phone number');
              isValid = false;
            }
          }

          // Validate password
          if (!password) {
            showError('password', 'Password is required');
            isValid = false;
          } else if (password.length < 6) {
            showError('password', 'Password must be at least 6 characters long');
            isValid = false;
          }

          if (isValid) {
            // Show loading state
            const submitBtn = document.querySelector('.signin-btn');
            const btnText = document.querySelector('.btn-text');
            const btnLoader = document.querySelector('.btn-loader');
            
            btnText.style.display = 'none';
            btnLoader.style.display = 'inline';
            submitBtn.disabled = true;

            // Simulate form submission
            setTimeout(() => {
              alert('Welcome back! You have successfully signed in to SwitchBit!');
              // Reset form
              signinForm.reset();
              btnText.style.display = 'inline';
              btnLoader.style.display = 'none';
              submitBtn.disabled = false;
              
              // Redirect to home page after successful login
              setTimeout(() => {
                window.location.href = 'index.html';
              }, 1000);
            }, 2000);
          }
        });
      });
    </script>
  </body>
</html>
