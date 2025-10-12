package com.switchbit.controller.report;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.exceptions.*;
import com.switchbit.service.*;
import com.switchbit.model.*;
/**
 * Servlet implementation class ReportServlet
 */
@WebServlet("/reports")
public class ReportServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReportService reportService;

    public void init() throws ServletException {
    	super.init();
    	reportService = new ReportService();
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		User user = (User) request.getSession().getAttribute("user");
		String referer = request.getHeader("referer");
		
		try {
			
			request.setAttribute("reports",reportService.getReports(user.getUserId()));
			request.getRequestDispatcher("/reports.jsp").forward(request, response);
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
		User user = (User) request.getSession().getAttribute("user");
		
		if (user==null) {
			response.sendRedirect(request.getContextPath()+"/signin.jsp");
			return;
		}
		
		String subject = request.getParameter("subject");
		String message = request.getParameter("message");
		String referer = request.getHeader("referer");
		
		Report report = new Report();
		
		report.setUser_id(user.getUserId());
		report.setSubject(subject);
		report.setMessage(message);
		
		try {
			reportService.addReport(report);
			request.getSession().setAttribute("successMessage", "report posted successfully");
			response.sendRedirect(referer);
		} catch (RollBackException e) {
			e.printStackTrace();
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		}
		
	}

}
