<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>User Login</title>
</head>
<body>
    <h2>User Login</h2>

    <!-- Display error message if exists -->
    <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>

    <form action="<%=  request.getContextPath()  %>/user/login" method="post">
        <label for="identifier">Email / Phone / User ID:</label><br>
        <input type="text" id="identifier" name="user-identifier" required><br><br>

        <label for="password">Password:</label><br>
        <input type="password" id="password" name="user-password" required><br><br>

        <input type="submit" value="Login">
    </form>
</body>
</html>
