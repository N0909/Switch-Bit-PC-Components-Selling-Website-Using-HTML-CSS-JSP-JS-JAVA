<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>

<%
	Admin admin = (Admin) session.getAttribute("admin");
	
	if (admin==null){
		response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
		return;
	}
	
	List<ReportDTO> reports = (List<ReportDTO>) request.getAttribute("reports");
	if (reports == null) {
	    reports = new ArrayList<>();
	}
	
	String successMessage = (String) session.getAttribute("successMessage");
	String errorMessage = (String) session.getAttribute("errorMessage");
	session.removeAttribute("successMessage");
	session.removeAttribute("errorMessage");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Reports - SwitchBit Admin</title>
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/admin-style.css">
    <link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
    <style>
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
	
    <div class="main">
    	<div class="sidebar">
	        <h2>Welcome, <%= admin.getAdmin_username() %></h2>
	        <a href="<%=request.getContextPath()%>/admin/home">Dashboard</a>
	        <a href="<%=request.getContextPath()%>/admin/products">Manage Products</a>
	        <a href="<%=request.getContextPath()%>/admin/orders">Manage Orders</a>
	        <a href="<%=request.getContextPath()%>/admin/reports">Manage Reports</a>
    	</div>
    	
        <div class="container">
            <div class="table-top">
                <div class="reports-title">All Reports</div>
            </div>

            <% if (reports.isEmpty()) { %>
                <div class="empty-state"> not any reports yet.</div>
            <% } else { %>
                <table class="reports-table" aria-label="User reports table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>User ID</th>
                            <th>Subject</th>
                            <th>Submitted</th>
                            <th>Message</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%	
                            for (ReportDTO dto : reports) {
                                // dto.getReport() should return the Report model
                                Report r = dto.getReport();
                                ReportStatus rs = dto.getReportStatus();
                        %>
                        <tr>
                            <td><%= r != null ? r.getReport_id() : "—" %></td>
                            <td><%= r != null? r.getUser_id() : "—" %> </td>
                            <td><%= r != null ? r.getSubject() : "—" %></td>
                            <td><%= r != null ? r.getSubmitted_at() : "—" %></td>
                            <td><%= (r != null && r.getMessage()!=null && !r.getMessage().trim().isEmpty()) ? r.getMessage() : "—" %></td>
                            <td><span class="status-badge status-<%= rs.getStatus().getValue() %>"><%= ( rs.getStatus().getValue() != null && !rs.getStatus().getValue().isEmpty()) ? rs.getStatus().getValue() : "Unknown"   %></span></td>
                            <td>
                                <a class="new-report-btn" href="<%= request.getContextPath() %>/admin/reports/detail?report-id=<%= r != null ? r.getReport_id() : "" %>">View</a>
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
    
    <% if (successMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/successMessage.js" ></script>
	<% } %>
	
	<% if (errorMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/errorMessage.js" ></script>
	<% } %>
</body>
</html>