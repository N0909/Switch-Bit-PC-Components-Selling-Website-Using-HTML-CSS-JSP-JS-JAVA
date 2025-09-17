package com.switchbit.controller.user;

import java.io.IOException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.switchbit.service.UserService;
import com.switchbit.model.User;
import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.model.Password;
/**
 * Servlet implementation class UpdatePasswordServlet
 */
//@WebServlet("/user/updatepassword")
public class UpdatePasswordServlet extends HttpServlet {
	private UserService userService;

	public void init() throws ServletException {
		super.init();
		this.userService = new UserService();
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

	    String oldPassword = request.getParameter("old-password");
	    String newPasswordRaw = request.getParameter("new-password");

	    HttpSession session = request.getSession(false);

	    // 1. Ensure user is logged in
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }

	    User user = (User) session.getAttribute("user");

	    try {
	        // 2. Build Password entity for update
	        Password newPass = new Password(
	                user.getUserId(),
	                newPasswordRaw,
	                new Timestamp(System.currentTimeMillis())
	        );

	        // 3. Call service method (verify old, update new)
	        userService.updatePassword(oldPassword, newPass);


	        // 4. Success -> forward to JSP
	        request.setAttribute("successMessage", "Password updated successfully.");
	        request.getRequestDispatcher("/change-password.jsp").forward(request, response);

	    } catch (AuthenticationException e) {
	        // Old password mismatch
	        request.setAttribute("errorMessage", "Invalid current password. Try again.");
	        request.getRequestDispatcher("/change-password.jsp").forward(request, response);

	    } catch (DataAccessException e) {
	        // DB failure
	        request.setAttribute("errorMessage", "Failed to update password. Please try later.");
	        request.getRequestDispatcher("/change-password.jsp").forward(request, response);
	    }
	}


}
