<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("signin.jsp");
        return;
    }
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
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
                <li><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
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
              <span class="dropdown-icon">💬</span>
              <span>Submitted Reports</span>
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
    <!-- Main -->
    <main class="main">
        <div class="signup-container">
            <div class="signup-form-wrapper">
                <div class="signup-header">
                    <h2>My Account</h2>
                    <p>Update your password</p>
                </div>
                
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
                		<span class="error-message" id="old-passwordError"></span>
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
                		<span class="error-message" id="new-passwordError"></span>
                		<button type="button" class="password-toggle" id="new-passwordToggle">
                  		<span class="toggle-icon">🙈</span>
                		</button>
                	</div>
                	<button type="submit" class="signup-btn">Update Password</button>
                </form>
            </div>
        </div>
    </main>
    
    <% if (user!=null) {%>
	    <script src="<%=request.getContextPath()%>/js/profile-dropdown.js"></script> 
    <% } %>
    
    <% if (successMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/successMessage.js" ></script>
	<% } %>
	
	<% if (errorMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/errorMessage.js" ></script>
	<% } %>
    
    <script>
    
	  const contextPath = "<%= request.getContextPath() %>" ;

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
      
      
      
      // Validate password 
      
      const submitBtn = document.querySelector('.signup-btn');
      submitBtn.disabled = true;
      const changeForm = document.querySelector('.signup-form');
      
      function showError(fieldId, message) {
    	  const inputelement = document.getElementById(fieldId);
    	  const errorelement = document.getElementById(fieldId+"Error");
    	  
    	  errorelement.textContent = message;
    	  inputelement.classList.add('error');
      }
      
      function clearError(fieldId) {
    	  const inputelement = document.getElementById(fieldId);
    	  const errorelement = document.getElementById(fieldId+"Error");
    	  
    	  errorelement.textContent = '';
    	  inputelement.classList.remove('error')
      }
      
      function validatePassword(fieldId){
    	  const value = document.getElementById(fieldId).value;
    	  
    	  if (!value){
    		  showError(fieldId, fieldId+' is required');
    		  return false;
    	  }
    	  if (value.length<8){
    		  showError(fieldId, fieldId+' must be at least 8 characters');
    		  return false;
    	  };
    	  clearError(fieldId);
    	  return true;
      }
      
      function checkFormValidity() {
          const allValid = ['old-password', 'new-password'].every(validatePassword);
          submitBtn.disabled = !allValid;
      }
      
      ['old-password', 'new-password'].forEach(id => {
    	  const input = document.getElementById(id);
          input.addEventListener('input', checkFormValidity);
          input.addEventListener('blur', () => validatePassword(id));
      })
      
      changeForm.addEventListener('submit', function(e) {
            checkFormValidity();

            if (!submitBtn.disabled) {
                submitBtn.disabled = true; // Prevent double submission
            }
        });
      
    });
    </script>
</div>
</body>
</html>