package com.switchbit.controller.user;

import java.io.IOException;

import com.switchbit.exceptions.CloseConnectionException;
import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.DuplicateResourceException;
import com.switchbit.exceptions.RollBackException;
import com.switchbit.model.User;
import com.switchbit.service.UserService;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.annotation.*;

/*
 * Handles UserUpdate request for users
 */

@WebServlet("/user/update")
public class UserUpdateServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            // If no session or not logged in → redirect to login
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // Fetch the logged-in user (current data in session)
        User sessionUser = (User) session.getAttribute("user");

        // Collect updated fields from form
        String userName = request.getParameter("user-name");
        String userEmail = request.getParameter("user-email");
        String userPhone = request.getParameter("user-phone");
        String userAddress = request.getParameter("user-address");

        // Update fields
        sessionUser.setUserName(userName);
        sessionUser.setUserEmail(userEmail);
        sessionUser.setUserPhone(userPhone);
        sessionUser.setUserAddress(userAddress);

        try {
            userService.updateUser(sessionUser);

            // Update session with new values
            session.setAttribute("user", sessionUser);

            // Redirect to a profile page or success page
            session.setAttribute("successMessage", "Account Updated Sucessfully");
            response.sendRedirect(request.getContextPath() + "/profile.jsp");

        } catch (DuplicateResourceException e) {
        	if (session!=null)
        		session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath()+"/profile.jsp");

        } catch (DataAccessException e) {
        	if (session!=null)
        		session.setAttribute("errorMessage", e.getMessage());
            response.sendRedirect(request.getContextPath()+"/profile.jsp");
        } catch (RollBackException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (CloseConnectionException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    }
}	
