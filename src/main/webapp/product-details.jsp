<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Product Details - SwitchBit</title>
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
          <li><a href="signin.html">Sign In</a></li>
          <li><a href="products.html">Products</a></li>
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
      <div class="product-details-page">
        <!-- Breadcrumb -->
        <div class="breadcrumb">
          <a href="index.html">Home</a>
          <span class="breadcrumb-separator">></span>
          <a href="products.html">Products</a>
          <span class="breadcrumb-separator">></span>
          <span class="breadcrumb-current">Product Details</span>
        </div>

        <div class="product-details-container">
          <div class="product-image-section">
            <div class="main-image">
              <img src="images/Products/CPU/Intel Core i9-13900K.jpg" alt="Intel Core i9-13900K" />
            </div>
            </div>
          </div>

          <div class="product-info-section">
            <div class="product-header">
              <h1 class="product-title">Intel Core i9-13900K</h1>
              <div class="product-category">CPU / Processors</div>
            </div>

            <div class="product-price">
              <span class="current-price">₹38,000</span>
            </div>

            <div class="product-description">
              <h3>Description</h3>
              <p>
                The Intel Core i9-13900K is a high-performance 13th generation processor that delivers exceptional computing power for gaming, content creation, and professional workloads. Built with Intel's advanced 10nm process technology, this processor features 24 cores and 32 threads, providing incredible multi-tasking capabilities.
              </p>
              <p>
                Perfect for gamers, content creators, and professionals who demand the best performance. The i9-13900K offers outstanding single-core and multi-core performance, making it ideal for gaming, video editing, 3D rendering, and other intensive applications.
              </p>
            </div>


            <div class="product-actions">
              <div class="quantity-selector">
                <label for="quantity">Quantity:</label>
                <div class="quantity-controls">
                  <button class="quantity-btn minus" type="button">-</button>
                  <input type="number" id="quantity" name="quantity" value="1" min="1" max="10" class="quantity-input">
                  <button class="quantity-btn plus" type="button">+</button>
                </div>
              </div>

              <div class="action-buttons">
                <button class="btn-buy-now-large">Buy Now</button>
                <button class="btn-add-cart-large">Add to Cart</button>
              </div>
            </div>

            <div class="product-shipping">
              <div class="shipping-info">
                <div class="shipping-item">
                  <span class="shipping-icon">🚚</span>
                  <div class="shipping-text">
                    <strong>Free Shipping</strong>
                    <p>On orders over ₹5,000</p>
                  </div>
                </div>
                <div class="shipping-item">
                  <span class="shipping-icon">🔄</span>
                  <div class="shipping-text">
                    <strong>Easy Returns</strong>
                    <p>30-day return policy</p>
                  </div>
                </div>
                <div class="shipping-item">
                  <span class="shipping-icon">🛡️</span>
                  <div class="shipping-text">
                    <strong>Warranty</strong>
                    <p>3-year manufacturer warranty</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
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

        // Product details functionality
        const quantityInput = document.getElementById('quantity');
        const minusBtn = document.querySelector('.quantity-btn.minus');
        const plusBtn = document.querySelector('.quantity-btn.plus');
        const buyNowBtn = document.querySelector('.btn-buy-now-large');
        const addToCartBtn = document.querySelector('.btn-add-cart-large');
        const thumbnails = document.querySelectorAll('.thumbnail');
        const mainImage = document.querySelector('.main-image img');

        // Quantity controls
        minusBtn.addEventListener('click', function() {
          const currentValue = parseInt(quantityInput.value);
          if (currentValue > 1) {
            quantityInput.value = currentValue - 1;
          }
        });

        plusBtn.addEventListener('click', function() {
          const currentValue = parseInt(quantityInput.value);
          const maxValue = parseInt(quantityInput.getAttribute('max'));
          if (currentValue < maxValue) {
            quantityInput.value = currentValue + 1;
          }
        });

        // Thumbnail image switching
        thumbnails.forEach(thumbnail => {
          thumbnail.addEventListener('click', function() {
            // Remove active class from all thumbnails
            thumbnails.forEach(t => t.classList.remove('active'));
            // Add active class to clicked thumbnail
            this.classList.add('active');
            // Update main image
            const thumbnailImg = this.querySelector('img');
            mainImage.src = thumbnailImg.src;
            mainImage.alt = thumbnailImg.alt;
          });
        });

        // Buy Now button
        buyNowBtn.addEventListener('click', function() {
          const quantity = quantityInput.value;
          alert(`Proceeding to checkout for ${quantity} x Intel Core i9-13900K`);
          // Add your buy now logic here
        });

        // Add to Cart button
        addToCartBtn.addEventListener('click', function() {
          const quantity = quantityInput.value;
          alert(`${quantity} x Intel Core i9-13900K added to cart!`);
          // Add your add to cart logic here
        });
      });
    </script>
  </body>
</html>
