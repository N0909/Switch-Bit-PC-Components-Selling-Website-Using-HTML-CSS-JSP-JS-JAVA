<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%
	String error = (String) session.getAttribute("errorMessage");
	String flash = (String) session.getAttribute("successMessage");
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("signin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Account</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css"> 
</head>
<body>
<div class="page-container">
    
    <!-- Header / Navbar -->
    <header class="header">
        <div class="company-logo">
        <div class="logo">
          <img width="30px" src="<%= request.getContextPath() %>/icons/mouse.png" alt="" />
        </div>
        <div class="title">SwitchBit</div>
      </div>
        <nav class="nav">
            <ul>
                <li><a href="<%=request.getContextPath()%>/home">Home</a></li>
                <li><a href="<%=request.getContextPath()%>/about.jsp">About</a></li>
                <li class="active"><a href="<%=request.getContextPath() %>/profile.jsp">My Account</a></li>
                <li><a href="<%=request.getContextPath()%>/product/products">Products</a></li>
                <li><a href="<%=request.getContextPath()%>/contact.jsp">Contact</a></li>
            </ul>
        </nav>
        <div class="side-container">
        <%
        	if (user!=null){
        %>
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
        <%
        	}
        %>
        </div>
    </header>
    
    <!-- Main -->
    <main class="main">
        <div class="signup-container">
            <div class="signup-form-wrapper">
                <div class="signup-header">
                    <h2>My Account</h2>
                    <p>Update your password</p>
                </div>
                
                <%
                	if (error!=null){
                %>
                	<div class="error-message"><%=error %></div>
                <%
                		session.removeAttribute("errorMessage");
                	}
                %>
                <%
                  if (flash != null) {
				%>
  					 <div class="success-message"><%= flash %></div>
				<%
      						session.removeAttribute("successMessage"); // remove after showing
   						}
				%>
				
                <form class="signup-form" action="<%=request.getContextPath()%>/user/updatepassword" method="post">
                    
                    <div class="form-group">
              			<label for="old-password">Old Password *</label>
              			<div class="password-input-wrapper">
                		<input 
                  		type="password" 
                  		id="old-password" 
                  		name="old-password" 
                  		required 
                  		placeholder="Enter your password"
                  		class="form-input"
                		/>
                		<button type="button" class="password-toggle" id="old-passwordToggle">
                  		<span class="toggle-icon">🙈</span>
                		</button>
                	</div>
                	
                    <div class="form-group">
              			<label for="new-password">New Password *</label>
              			<div class="password-input-wrapper">
                		<input 
                  		type="password" 
                  		id="new-password" 
                  		name="new-password" 
                  		required 
                  		placeholder="Enter your password"
                  		class="form-input"
                		/>
                		<button type="button" class="password-toggle" id="new-passwordToggle">
                  		<span class="toggle-icon">🙈</span>
                		</button>
                	</div>
                	<button type="submit" class="signup-btn">Update Password</button>
                </form>
            </div>
        </div>
    </main>
    
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
      
      
      const oldpasswordToggle = document.getElementById('old-passwordToggle');
      const newpasswordToggle = document.getElementById('new-passwordToggle');
      const newpasswordInput = document.getElementById('new-password');
      const oldpasswordInput = document.getElementById('old-password');

      // Password toggle functionality
      oldpasswordToggle.addEventListener('click', function() {
        const type = oldpasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
        oldpasswordInput.setAttribute('type', type);
        this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
      });
      
      newpasswordToggle.addEventListener('click', function() {
          const type = newpasswordInput.getAttribute('type') === 'password' ? 'text' : 'password';
          newpasswordInput.setAttribute('type', type);
          this.querySelector('.toggle-icon').textContent = type === 'password' ? '👁️' : '🙈';
        });
    });
    </script>
</div>
</body>
</html>