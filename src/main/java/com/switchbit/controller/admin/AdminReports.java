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


@WebServlet("/admin/reports")
public class AdminReports extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private ReportService reportService;

    public void init() throws ServletException {
    	super.init();
    	reportService = new ReportService();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String referer = request.getHeader("referer");
		try {
			request.setAttribute("reports", reportService.getReports());
			request.getRequestDispatcher("/admin/admin-reports.jsp").forward(request, response);
		} catch (DataAccessException e) {
			e.printStackTrace();
			request.getSession().setAttribute("errorMessage", e.getMessage());
			response.sendRedirect(referer);
		}
	}
	
	
}
