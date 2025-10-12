<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="java.util.*" %>
<%
    // ensure user is logged in (user-facing page)
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/signin.jsp");
        return;
    }
    
    String referer = request.getHeader("referer");
    
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report an Issue - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
      
        .report-container {
            max-width: 900px;
            margin: 36px auto;
            background: #fff;
            border-radius: 12px;
            padding: 28px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            border: 1px solid #e0e0e0;
        }

        .report-title {
            font-size: 1.6rem;
            color: #2c5aa0;
            font-weight: 700;
            margin-bottom: 18px;
            text-align: left;
        }
        
        #reportForm{
        	display: flex;
        	flex-direction:column;
        }

        .form-row {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 16px;
        }

        .field {
            flex: 1;
            min-width: 260px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        label {
            font-weight: 600;
            color: #333;
            font-size: 0.95rem;
        }

        input[type="text"].input-field {
            padding: 12px 14px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background: #fafafa;
            font-size: 1rem;
            outline: none;
            transition: all 0.2s ease;
        }

        input[type="text"].input-field:focus {
            border-color: #2c5aa0;
            background: #fff;
            box-shadow: 0 4px 20px rgba(44,90,160,0.08);
        }

        textarea.message-box {
            min-height: 180px;
            max-height: 400px;
            resize: vertical;
            padding: 12px 14px;
            border: 2px solid #e0e0e0;
            border-radius: 8px;
            background: #fafafa;
            font-size: 1rem;
            line-height: 1.4;
            outline: none;
            transition: all 0.2s ease;
        }

        textarea.message-box:focus {
            border-color: #2c5aa0;
            background: #fff;
            box-shadow: 0 4px 20px rgba(44,90,160,0.08);
        }

        .counter-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 10px;
            margin-top: 6px;
        }

        .char-counter {
            color: #666;
            font-weight: 600;
            font-size: 0.9rem;
        }

        .post-row {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 18px;
        }

        .btn-post {
            padding: 10px 16px;
            border-radius: 8px;
            border: none;
            font-weight: 700;
            color: #fff;
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3f73 100%);
            cursor: pointer;
            transition: all 0.2s ease;
        }
        .btn-post:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        .btn-cancel {
            padding: 10px 16px;
            border-radius: 8px;
            border: 2px solid #e0e0e0;
            background: #fff;
            font-weight: 700;
            color: #333;
            cursor: pointer;
        }

        .hint {
            color: #666;
            font-size: 0.9rem;
        }

        /* Responsive */
        @media only screen and (max-width: 720px) {
            .post-row { justify-content: stretch; }
            .btn-post, .btn-cancel { width: 100%; }
        }
    </style>
</head>
<body>
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
          <li class="active"><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
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
            <a href="<%=request.getContextPath()%>/cart"><img width="20px" src="<%= request.getContextPath() %>/icons/shopping-cart.png" alt="c" /></a>
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
        <% } %>
      </div>
    </div>

    <div class="main">
        <div class="report-container">
            <div class="report-title">Report an Issue / Send Feedback</div>

            <form id="reportForm" action="<%= request.getContextPath() %>/reports" method="post" novalidate>
                <div class="form-row">
                    <div class="field" style="flex-basis:100%">
                        <label for="subject">Subject</label>
                        <input id="subject" name="subject" type="text" class="input-field" maxlength="120" placeholder="Short summary (max 120 chars)" required />
                        <div class="counter-row">
                            <div class="hint">Keep it short and descriptive.</div>
                            <div class="char-counter" id="subjectCounter">0 / 120</div>
                        </div>
                    </div>
                </div>

                <div class="form-row">
                    <div class="field" style="flex-basis:100%">
                        <label for="message">Message</label>
                        <textarea id="message" name="message" class="message-box" maxlength="800" placeholder="Describe the issue or feedback (max 800 characters)" required></textarea>
                        <div class="counter-row">
                            <div class="hint">Provide as much detail as you can — steps to improve, expected behavior.</div>
                            <div class="char-counter" id="messageCounter">0 / 800</div>
                        </div>
                    </div>
                </div>

                <div class="post-row">
                    <button type="button" class="btn-cancel" onclick="window.location.href=<%= referer %>">Cancel</button>
                    <button id="postBtn" type="submit" class="btn-post" disabled>Post</button>
                </div>
            </form>
        </div>
    </div>
    
    <% if (successMessage != null) { %>
        <div id="toast-success"><%= successMessage %></div>
    <% } %>
    <% if (errorMessage != null) { %>
        <div id="toast-error"><%= errorMessage %></div>
    <% } %>
    

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
    		
            const subject = document.getElementById('subject');
            const message = document.getElementById('message');
            const subjectCounter = document.getElementById('subjectCounter');
            const messageCounter = document.getElementById('messageCounter');
            const postBtn = document.getElementById('postBtn');
            const MAX_SUBJECT = parseInt(subject.getAttribute('maxlength'), 10) || 120;
            const MAX_MESSAGE = parseInt(message.getAttribute('maxlength'), 10) || 800;

            function updateCounters() {
                subjectCounter.textContent = subject.value.length + ' / ' + MAX_SUBJECT;
                messageCounter.textContent = message.value.length + ' / ' + MAX_MESSAGE;
                validateForm();
            }

            function validateForm() {
                const subjectOk = subject.value.trim().length > 0 && subject.value.trim().length <= MAX_SUBJECT;
                const messageOk = message.value.trim().length > 0 && message.value.trim().length <= MAX_MESSAGE;
                postBtn.disabled = !(subjectOk && messageOk);
            }

            // initialize
            updateCounters();

            subject.addEventListener('input', updateCounters);
            message.addEventListener('input', updateCounters);

            // prevent submit if invalid (extra guard)
            document.getElementById('reportForm').addEventListener('submit', function(e){
                if (postBtn.disabled) {
                    e.preventDefault();
                    return false;
                }
            });
    </script>
</body>
</html>