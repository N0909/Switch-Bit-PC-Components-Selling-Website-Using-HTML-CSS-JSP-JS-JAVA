<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%
    // ensure user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/signin.jsp");
        return;
    }

    // The ReportsServlet (or equivalent) should set request attribute "report-details" (ReportDTO)
    ReportDTO reportDto = (ReportDTO) request.getAttribute("report");
   
    // Toasts
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Report Details - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
       
        .details-container {
            max-width: 900px;
            margin: 32px auto;
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            border: 1px solid #e0e0e0;
        }

        .details-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            margin-bottom: 12px;
        }

        .details-title {
            font-size: 1.4rem;
            color: #2c5aa0;
            font-weight: 700;
        }

        .back-link {
            padding: 8px 12px;
            border-radius: 8px;
            background: #f8f9fa;
            color: #2c5aa0;
            text-decoration: none;
            font-weight: 700;
            border: 1px solid #e0e0e0;
        }

        .detail-row {
            display: flex;
            gap: 18px;
            flex-wrap: wrap;
            margin-bottom: 14px;
        }

        .detail-card {
            flex: 1;
            min-width: 240px;
            background: #f8f9fa;
            padding: 14px 16px;
            border-radius: 10px;
            border: 1px solid #e0e0e0;
        }

        .label {
            color: #666;
            font-weight: 600;
            margin-bottom: 6px;
            display: block;
        }

        .value {
            color: #222;
            font-weight: 700;
        }

        .message-box {
            padding: 14px;
            background: #fff;
            border-radius: 8px;
            border: 1px solid #e0e0e0;
            margin-top: 8px;
            white-space: pre-wrap;
        }

        .muted { color: #666; }

        .empty-state { text-align: center; padding: 20px; color: #666; }

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
          <li class=""><a href="<%= request.getContextPath() %>/home">Home</a></li>
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
        <div class="details-container">
            <div class="details-header">
                <div class="details-title">Report Details</div>
                <a class="back-link" href="<%= request.getContextPath() %>/reports">← Back to Reports</a>
            </div>

            <% if (reportDto == null || reportDto.getReport() == null) { %>
                <div class="empty-state">Report not found or not provided. Please go back to the reports list.</div>
            <% } else { 
                Report r = reportDto.getReport();
                ReportStatus rs = reportDto.getReportStatus();
            %>
                <div class="detail-row">
                    <div class="detail-card">
                        <span class="label">Report ID</span>
                        <div class="value"><%= r.getReport_id() %></div>
                    </div>
                    <div class="detail-card">
                        <span class="label">Status</span>
                        <div class="value"><%= rs.getStatus().getValue() %></div>
                    </div>
                </div>

                <div class="detail-row" style="margin-top:8px;">
                    <div style="flex:1;">
                        <span class="label">Subject</span>
                        <div class="value"><%= r.getSubject() %></div>
                    </div>
                </div>

                <div style="margin-top:12px;">
                    <span class="label">Message</span>
                    <div class="message-box"><%= r.getMessage() %></div>
                </div>

                <div style="margin-top:14px;">
                    <span class="label">Response</span>
                    <% String resp = r.getResponse_message(); %>
                    <% if (resp == null || resp.trim().isEmpty()) { %>
                        <div class="muted">No response yet.</div>
                    <% } else { %>
                        <div class="message-box"><%= resp %></div>
                    <% } %>
                </div>
            <% } %>
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
	</script>
</body>
</html>