package com.switchbit.controller.user;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.sql.*;

import com.switchbit.exceptions.DataAccessException;
import com.switchbit.exceptions.DuplicateResourceException;
import com.switchbit.model.*;
import com.switchbit.service.UserService;


/**
 * Servlet implementation class UserLoginServlet
 */
public class UserSignUpServlet extends HttpServlet {

    private UserService userService;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userService = new UserService();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 1. Collect form input
        String userName = request.getParameter("user-name");
        String userEmail = request.getParameter("user-email");
        String userPhone = request.getParameter("user-phone");
        String userAddress = request.getParameter("user-address");
        String password = request.getParameter("user-password");

        // 2. Basic validation
        if (userName == null || userEmail == null || password == null ||
            userName.isEmpty() || userEmail.isEmpty() || password.isEmpty()) {
            request.setAttribute("errorMessage", "Name, Email, and Password are required.");
            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            return;
        }

        // 3. Create User object
        User user = new User();
        user.setUserName(userName);
        user.setUserEmail(userEmail.toLowerCase().trim()); // normalize email
        user.setUserPhone(userPhone);
        user.setUserAddress(userAddress);
        user.setRegDate(new Timestamp(System.currentTimeMillis()));

        try {
            // 4. Call service to add user
            User createdUser = userService.addUser(user, password);

            // 5. Store in session
            HttpSession session = request.getSession();
            session.setAttribute("user", createdUser);

            // 6. Redirect to success page
            response.sendRedirect(request.getContextPath() + "/sign-up-success.jsp");

        }
        catch (DuplicateResourceException e) {
        	request.setAttribute("errorMessage", "Email or Phone already exists");
        	request.getRequestDispatcher("/signup.jsp").forward(request, response);
        }
        catch (DataAccessException e) {
            // Handle DB errors
            request.setAttribute("errorMessage", "Failed to register user. Try again.");
//            request.getRequestDispatcher("/signup.jsp").forward(request, response);
            response.getWriter().println(e);
        }
    }
}

