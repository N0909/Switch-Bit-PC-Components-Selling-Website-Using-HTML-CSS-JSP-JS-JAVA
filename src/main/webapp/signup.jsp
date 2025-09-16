<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up</title>
</head>
<body>
    <h2>User Sign Up</h2>

    <!-- Display error message if exists -->
    
    <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>

    <form action="<%= request.getContextPath() %>/api/signup" method="post">
        <label>Name:</label>
        <input type="text" name="user-name" required><br><br>

        <label>Email:</label>
        <input type="email" name="user-email" required><br><br>

        <label>Phone:</label>
        <input type="text" name="user-phone"><br><br>

        <label>Address:</label>
        <input type="text" name="user-address"><br><br>

        <label>Password:</label>
        <input type="password" name="user-password" required><br><br>

        <button type="submit">Sign Up</button>
    </form>
</body>
</html>
