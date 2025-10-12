package com.switchbit.controller.admin;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.*;
import com.switchbit.model.*;
import com.switchbit.service.*;

@WebServlet("/admin/reports/detail")
public class AdminReportDetailServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReportService reportService;
	
	public void init() throws ServletException {
		super.init();
		reportService = new ReportService();
	}
    
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String report_id = request.getParameter("report-id");
		String referer = request.getHeader("referer");
		
		try {
			request.setAttribute("report",reportService.getReport(report_id));
			request.getRequestDispatcher("/admin/admin-report-detail.jsp").forward(request, response);
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(referer);
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String report_id = request.getParameter("report-id");
		String response_message = request.getParameter("response-message");
		
		try {
			Report report = new Report();
			report.setReport_id(report_id);
			report.setResponse_message(response_message);
			reportService.updateReportResponse(report);
			request.getSession().setAttribute("successMessage", "response updated");
			response.sendRedirect(request.getContextPath()+"/admin/reports/detail?report-id="+report_id);
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(request.getContextPath()+"/admin/reports/detail?report-id="+report_id);
		} catch (RollBackException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
