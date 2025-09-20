<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.util.PaginatedResult" %>
<%@ page import="com.switchbit.model.*" %>
<%
    // Get session user
    User user = (User) session.getAttribute("user");
    
    // Get data from HomeController
    List<Product> products = (List<Product>) request.getAttribute("products");
    List<Category> categories = (List<Category>) request.getAttribute("categories");
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>SwitchBit</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css" />
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
          <li class="active"><a href="<%= request.getContextPath() %>/home">Home</a></li>
          <li><a href="">About</a></li>
          <% if (user == null) { %>
            <li><a href="<%= request.getContextPath() %>/signup.jsp">Sign Up</a></li>
            <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
          <% } %>
          <li><a href="">Contact</a></li>
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
        
        <% if (user != null) { %>
        <div class="cart-container">
          <div class="side-icon">
            <img width="20px" src="<%= request.getContextPath() %>/icons/shopping-cart.png" alt="c" />
          </div>
        </div>
        <div class="account-container">
          <div class="side-icon profile-trigger">
            <img width="20px" src="<%= request.getContextPath() %>/icons/profile-icon.png" alt="Profile" />
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
        <% } %>
      </div>
    </div>

    <div class="main">
      <!-- Featured Products Section -->
      <div class="featured-section">
        <h2 class="section-title">Featured Products</h2>
        <div class="product-cards">
          <% if (products != null && !products.isEmpty()) { %>
            <% for (int i = 0; i < Math.min(5, products.size()); i++) { %>
              <% Product product = products.get(i); %>
              <div class="product-card">
                <div class="product-img">
                  <img
                    width="100px"
                    src="<%= request.getContextPath() %>/<%= product.getProduct_img() %>"
                    alt="<%= product.getProduct_name() %>"
                  />
                </div>
                <div class="product-name"><%= product.getProduct_name() %></div>
                <div class="price">₹ <%= product.getPrice() %></div>
                <div class="buttons">
                  <button onclick="buyNow('<%= product.getProduct_id() %>', '<%= product.getProduct_name() %>')">Buy Now</button>
                  <% if (user != null) { %>
                    <button onclick="addToCart('<%= product.getProduct_id() %>', '<%= product.getProduct_name() %>')">Add to Cart</button>
                  <% } else { %>
                    <button onclick="showLoginAlert()">Add to Cart</button>
                  <% } %>
                </div>
              </div>
            <% } %>
          <% } %>
        </div>
        <div class="browse-all-container">
          <a href="<%= request.getContextPath() %>/product/products" class="browse-all-btn">Browse All Products</a>
        </div>
      </div>

      <!-- Categories Section -->
      <div class="categories-section">
        <h2 class="section-title">Browse by Categories</h2>
        <div class="category-cards">
          <% if (categories != null && !categories.isEmpty()) { %>
            <% for (Category category : categories) { %>
              <div class="category-card">
                <div class="category-img">
                  <img src="<%= request.getContextPath() %>/<%= category.getCategory_image() %>" alt="<%= category.getCategory_name() %>" />
                </div>
                <div class="category-name"><%= category.getCategory_name() %></div>
              </div>
            <% } %>
          <% } %>
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
      // Profile dropdown functionality (only if user is logged in)
      document.addEventListener('DOMContentLoaded', function() {
        <% if (user != null) { %>
        const profileTrigger = document.querySelector('.profile-trigger');
        const profileDropdown = document.querySelector('.profile-dropdown');
        const accountContainer = document.querySelector('.account-container');
        
        if (profileTrigger && profileDropdown && accountContainer) {
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
                window.location.href = '<%= request.getContextPath() %>/orders.jsp';
              } else if (text === 'Manage Account') {
                window.location.href = '<%= request.getContextPath() %>/account.jsp';
              } else if (text === 'Logout') {
                if (confirm('Are you sure you want to logout?')) {
                  window.location.href = '<%= request.getContextPath() %>/logout';
                }
              }
              
              // Close dropdown after action
              profileDropdown.style.opacity = '0';
              profileDropdown.style.visibility = 'hidden';
              profileDropdown.style.transform = 'translateY(-10px)';
            });
          });
        }
        <% } %>

        // Product card interactions
        const buyNowButtons = document.querySelectorAll('.btn-buy-now');
        const addToCartButtons = document.querySelectorAll('.btn-add-cart');

        buyNowButtons.forEach(button => {
          button.addEventListener('click', function() {
            const productTitle = this.closest('.product-card').querySelector('.product-name').textContent;
            alert(`Proceeding to checkout for: ${productTitle}`);
            // Add your buy now logic here
          });
        });

        addToCartButtons.forEach(button => {
          button.addEventListener('click', function() {
            const productTitle = this.closest('.product-card').querySelector('.product-name').textContent;
            alert(`${productTitle} added to cart!`);
            // Add your add to cart logic here
          });
        });
      });

      // Function to handle buy now
      function buyNow(productId, productName) {
        alert(`Proceeding to checkout for: ${productName}`);
        // Add your buy now logic here
        // window.location.href = '<%= request.getContextPath() %>/checkout.jsp?productId=' + productId;
      }

      // Function to handle add to cart
      function addToCart(productId, productName) {
        alert(`${productName} added to cart!`);
        // Add your add to cart logic here
        // You can make an AJAX call to add to cart
      }

      // Function to show login alert for non-logged in users
      function showLoginAlert() {
        alert('Please login to add items to cart');
        window.location.href = '<%= request.getContextPath() %>/signin.jsp';
      }
    </script>
  </body>
</html>
