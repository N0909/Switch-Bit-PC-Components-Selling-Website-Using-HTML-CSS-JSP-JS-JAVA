<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.switchbit.model.*" %>
<%@ page import="com.switchbit.dto.*" %>
<%
	Admin admin = (Admin) session.getAttribute("admin");
	
	if (admin==null){
		response.sendRedirect(request.getContextPath()+"/admin/admin-signin.jsp");
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
<html>
<head>
<meta charset="UTF-8">
<title>Admin- Report Details</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/admin-style.css">
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
        
        .message-box:focus {
		  border-color: #2563eb;
		  background-color: #fff;
		  outline: none;
		  box-shadow: 0 0 0 3px rgba(37,99,235,0.15);
		}
		
        .report-response-form {
		  display: flex;
		  flex-direction: column;
		  gap: 16px;
		  width: 100%;
		  max-width: 700px;
		  background: #ffffff;
		  border: 1px solid #e5e7eb;
		  border-radius: 10px;
		  padding: 20px 24px;
		  box-shadow: 0 2px 8px rgba(0,0,0,0.06);
		  margin-top: 25px;
		}
		
		.response-submit-btn {
		  align-self: flex-end;
		  background: #2563eb;
		  color: #fff;
		  font-size: 16px;
		  font-weight: 500;
		  border: none;
		  border-radius: 8px;
		  padding: 10px 20px;
		  cursor: pointer;
		  transition: background 0.2s;
		}
		
		.response-submit-btn:hover {
		  background: #1e40af;
		}
		
		.response-submit-btn:active {
		  background: #1d4ed8;
		}

        .muted { color: #666; }

        .empty-state { text-align: center; padding: 20px; color: #666; }

    </style>
</head>
<body>

	<div class="main">
        <div class="details-container">
            <div class="details-header">
                <div class="details-title">Report Details</div>
                <a class="back-link" href="<%= request.getContextPath() %>/admin/reports">← Back to Reports</a>
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
                        <form class="report-response-form" 
						      action="<%=request.getContextPath()%>/admin/reports/detail" 
						      method="post">
						      
						    <input type="hidden" value=<%= r.getReport_id() %> name="report-id">
						    
						    <textarea class="message-box" name="response-message" id="response-message"
						              placeholder="Write your response to the user..."></textarea>
						    
						    <button type="submit" class="response-submit-btn">Send Response</button>
						</form>
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
    
    <% if (successMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/successMessage.js" ></script>
	<% } %>
	
	<% if (errorMessage != null) { %>
		<script src="<%=request.getContextPath()%>/js/errorMessage.js" ></script>
	<% } %>

</body>
</html>