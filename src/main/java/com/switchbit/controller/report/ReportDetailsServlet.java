package com.switchbit.controller.report;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.*;

import com.switchbit.model.*;
import com.switchbit.dto.*;
import com.switchbit.service.*;
import com.switchbit.exceptions.*;

/**
 * Servlet implementation class ReportDetailsServlet
 */
@WebServlet("/reports/details")
public class ReportDetailsServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;	
	private ReportService reportService;
	
	public void init() throws ServletException{
		super.init();
		reportService = new ReportService();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		String report_id = request.getParameter("report-id");
		String referer = request.getHeader("referer");
		
		try {
			request.setAttribute("report", reportService.getReport(report_id));
			request.getRequestDispatcher("/report-details.jsp").forward(request, response);
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage",e.getMessage());
		}
		
	}

}
