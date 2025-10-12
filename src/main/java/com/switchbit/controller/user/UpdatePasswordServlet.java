package com.switchbit.controller.user;

import java.io.IOException;
import java.sql.Timestamp;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.*;

import com.switchbit.service.UserService;
import com.switchbit.model.User;
import com.switchbit.exceptions.AuthenticationException;
import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.model.Password;


/**
 * Handles login requests for users.
 * Responsibilities:
 * 1. Check Old Password With Current Password
 * 3. On success → set success message in session and redirect to change-password.jsp
 * 4. On failure → set error message in session and redirect to change-password.jsp
 */

@WebServlet("/user/updatepassword")
public class UpdatePasswordServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserService userService;

	public void init() throws ServletException {
		super.init();
		this.userService = new UserService();
	}
	
	
	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {

	    String oldPassword = request.getParameter("old-password");
	    String newPasswordRaw = request.getParameter("new-password");

	    HttpSession session = request.getSession(false);

	    // Ensure user is logged in
	    if (session == null || session.getAttribute("user") == null) {
	        response.sendRedirect(request.getContextPath() + "/login.jsp");
	        return;
	    }
	    
	    // Fetch User from Session
	    User user = (User) session.getAttribute("user");

	    try {
	        // Build Password entity for update
	        Password newPass = new Password(
	                user.getUserId(),
	                newPasswordRaw,
	                new Timestamp(System.currentTimeMillis())
	        );

	        // Call service method (verify old, update new)
	        userService.updatePassword(oldPassword, newPass);


	        // Success -> forward to JSP
	        session.setAttribute("successMessage", "Password updated successfully.");
	        response.sendRedirect(request.getContextPath()+"/change-password.jsp");

	    } catch (AuthenticationException e) {
	        // Old password mismatch
	        session.setAttribute("errorMessage", e.getMessage());
	        response.sendRedirect(request.getContextPath()+"/change-password.jsp");

	    } catch (DataAccessException e) {
	        // DB failure
	    	session.setAttribute("errorMessage", e.getMessage());
	        response.sendRedirect(request.getContextPath()+"/change-password.jsp");
	    } catch (RollBackException e) {
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			e.printStackTrace();
		}
	}


}
