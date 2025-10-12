<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%
    // Ensure user is logged in
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/signin.jsp");
        return;
    }

    // The servlet (ReportsServlet) should set a request attribute "reports" which is List<ReportDTO>
    List<ReportDTO> reports = (List<ReportDTO>) request.getAttribute("reports");
    if (reports == null) {
        reports = new ArrayList<>();
    }

    // Optional toasts
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Your Reports - SwitchBit</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
        .reports-container {
            max-width: 1100px;
            margin: 32px auto;
            background: #fff;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.06);
            border: 1px solid #e0e0e0;
        }

        .reports-title {
            font-size: 1.6rem;
            color: #2c5aa0;
            font-weight: 700;
            margin-bottom: 12px;
        }

        .reports-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 12px;
        }

        .reports-table th, .reports-table td {
            padding: 12px 14px;
            border: 1px solid #e8eaee;
            text-align: left;
            vertical-align: middle;
            font-size: 0.98rem;
        }

        .reports-table th {
            background: #f8f9fa;
            color: #2c5aa0;
            font-weight: 700;
        }

        .status-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            font-weight: 700;
            font-size: 0.85rem;
            color: #fff;
        }
        .status-OPEN { background: #ff6b6b; }        /* Red-ish for open */
        .status-RESOLVED { background: #28a745; }     /* Green for resolved */

        .action-link {
            color: #2c5aa0;
            text-decoration: none;
            font-weight: 700;
        }
        .action-link:hover { text-decoration: underline; }

        .empty-state {
            text-align: center;
            padding: 36px 12px;
            color: #666;
        }

        .new-report-btn {
            display: inline-block;
            padding: 10px 14px;
            background: linear-gradient(135deg, #2c5aa0 0%, #1e3f73 100%);
            color: #fff;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            margin-left: auto;
        }

        .table-top {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }

        @media only screen and (max-width: 760px) {
            .reports-table th, .reports-table td {
                padding: 8px;
                font-size: 0.9rem;
            }
            .table-top { flex-direction: column; align-items: flex-start; gap: 8px; }
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
          <li class=""><a href="<%= request.getContextPath() %>/home">Home</a></li>
          <li><a href="">About</a></li>
          <% if (user == null) { %>
            <li><a href="<%= request.getContextPath() %>/signup.jsp">Sign Up</a></li>
            <li><a href="<%= request.getContextPath() %>/signin.jsp">Sign In</a></li>
          <% } %>
          <li><a href="<%=request.getContextPath()%>/report.jsp">Report</a></li>
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
        <div class="reports-container">
            <div class="table-top">
                <div class="reports-title">Your Reports</div>
                <a class="new-report-btn" href="<%= request.getContextPath() %>/report.jsp">+ New Report</a>
            </div>

            <% if (reports.isEmpty()) { %>
                <div class="empty-state">You have not submitted any reports yet.</div>
            <% } else { %>
                <table class="reports-table" aria-label="User reports table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Report ID</th>
                            <th>Subject</th>
                            <th>Submitted</th>
                            <th>Message</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            int idx = 1;
                            for (ReportDTO dto : reports) {
                                // dto.getReport() should return the Report model
                                Report r = dto.getReport();
                                ReportStatus rs = dto.getReportStatus();
                        %>
                        <tr>
                            <td><%= idx++ %></td>
                            <td><%= r != null ? r.getReport_id() : "—" %></td>
                            <td><%= r != null ? r.getSubject() : "—" %></td>
                            <td><%= r != null ? r.getSubmitted_at() : "—" %></td>
                            <td><%= (r != null && r.getMessage()!=null && !r.getMessage().trim().isEmpty()) ? r.getMessage() : "—" %></td>
                            <td><span class="status-badge status-<%= rs.getStatus().getValue() %>"><%= ( rs.getStatus().getValue() != null && !rs.getStatus().getValue().isEmpty()) ? rs.getStatus().getValue() : "Unknown"   %></span></td>
                            <td>
                                <a class="action-link" href="<%= request.getContextPath() %>/reports/details?report-id=<%= r != null ? r.getReport_id() : "" %>">View</a>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
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