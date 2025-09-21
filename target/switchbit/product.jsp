<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="com.switchbit.util.PaginatedResult" %>
<%@ page import="com.switchbit.model.*" %>

<%
    // Get session user
    User user = (User) session.getAttribute("user");
    
    // Get paginated result from request attribute
    PaginatedResult<Product> productsPage = (PaginatedResult<Product>) request.getAttribute("productsPage");
    
    // Get current page and total pages
    int currentPage = productsPage.getPage();
    int totalPages = (int) Math.ceil((double) productsPage.getTotal() / productsPage.getPageSize());
    int pageSize = productsPage.getPageSize();
    List<Product> products = productsPage.getItems();
%>

<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Products - SwitchBit</title>
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
          <li><a href="<%= request.getContextPath() %>/home">Home</a></li>
          <li><a href="">About</a></li>
          <% if (user == null) { %>
            <li><a href="<%= request.getContextPath() %>/signup.jsp">Sign Up</a></li>
            <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
          <% } %>
          <li class="active"><a href="<%= request.getContextPath() %>/product/products">Products</a></li>
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
      <div class="products-page">
        <div class="page-header">
          <h1>Our Products</h1>
          <p>Discover the latest technology and computer components</p>
        </div>

        <div class="products-container">
          <% if (products != null && !products.isEmpty()) { %>
            <% for (Product product : products) { %>
              <div class="product-card-horizontal">
                <div class="product-image">
                  <img src="<%= request.getContextPath() %>/<%= product.getProduct_img() %>" alt="<%= product.getProduct_name() %>" />
                </div>
                <div class="product-details">
                  <div class="product-info">
                    <a style="text-decoration:none" href="<%=request.getContextPath()%>/product/getProduct?product-id=<%=product.getProduct_id()%>"><h3 class="product-title"><%= product.getProduct_name() %></h3></a>
                    <p class="product-description"><%= product.getDescription() %></p>
                  </div>
                  <div class="product-actions">
                    <div class="price-section">
                      <span class="current-price">₹<%= product.getPrice() %></span>
                    </div>
                    <div class="action-buttons">
                      <button class="btn-buy-now" onclick="buyNow('<%= product.getProduct_id() %>', '<%= product.getProduct_name() %>')">Buy Now</button>
                      <% if (user != null) { %>
                        <button class="btn-add-cart" onclick="addToCart('<%= product.getProduct_id() %>', '<%= product.getProduct_name() %>')">Add to Cart</button>
                      <% } else { %>
                        <button class="btn-add-cart" onclick="showLoginAlert()">Add to Cart</button>
                      <% } %>
                    </div>
                  </div>
                </div>
              </div>
            <% } %>
          <% } else { %>
            <div class="no-products">
              <h3>No products available</h3>
              <p>Please check back later for new products</p>
            </div>
          <% } %>
        </div>

        <!-- Pagination -->
        <% if (products != null && !products.isEmpty() && totalPages > 1) { %>
        <div class="pagination-container">
          <div class="pagination">
            <% if (currentPage > 1) { %>
              <a href="<%= request.getContextPath() %>/product/products?page=<%= currentPage - 1 %>" class="pagination-btn prev-btn">
                <span>←</span> Previous
              </a>
            <% } else { %>
              <span class="pagination-btn prev-btn" style="opacity: 0.5; cursor: not-allowed;">
                <span>←</span> Previous
              </span>
            <% } %>
            
            
            <div class="pagination-numbers">
              <% 
                int startPage = Math.max(1, currentPage - 2);
                int endPage = Math.min(totalPages, currentPage + 2);
                
                if (startPage > 1) {
              %>
                <a href="<%= request.getContextPath() %>/product/products?page=1" class="pagination-number">1</a>
                <% if (startPage > 2) { %>
                  <span class="pagination-dots">...</span>
                <% } %>
              <% } %>
              
              <% for (int i = startPage; i <= endPage; i++) { %>
                <% if (i == currentPage) { %>
                  <span class="pagination-number active"><%= i %></span>
                <% } else { %>
                  <a href="<%= request.getContextPath() %>/product/products?page=<%= i %>" class="pagination-number"><%= i %></a>
                <% } %>
              <% } %>
              
              <% if (endPage < totalPages) { %>
                <% if (endPage < totalPages - 1) { %>
                  <span class="pagination-dots">...</span>
                <% } %>
                <a href="<%= request.getContextPath() %>/product/products?page=<%= totalPages %>" class="pagination-number"><%= totalPages %></a>
              <% } %>
            </div>
            
            <% if (currentPage < totalPages) { %>
              <a href="<%= request.getContextPath() %>/product/products?page=<%= currentPage + 1 %>" class="pagination-btn next-btn">
                Next <span>→</span>
              </a>
            <% } else { %>
              <span class="pagination-btn next-btn" style="opacity: 0.5; cursor: not-allowed;">
                Next <span>→</span>
              </span>
            <% } %>
          </div>
          
          <div class="pagination-info">
            <span>Showing <%= (currentPage - 1) * pageSize + 1 %>-<%= Math.min(currentPage * pageSize, productsPage.getTotal()) %> of <%= productsPage.getTotal() %> products</span>
          </div>
        </div>
        <% } %>
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
                window.location.href = '<%= request.getContextPath() %>/profile.jsp';
              } else if (text === 'Logout') {
                if (confirm('Are you sure you want to logout?')) {
                  window.location.href = '<%= request.getContextPath() %>/user/logout';
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

      });
    </script>
  </body>
</html>
