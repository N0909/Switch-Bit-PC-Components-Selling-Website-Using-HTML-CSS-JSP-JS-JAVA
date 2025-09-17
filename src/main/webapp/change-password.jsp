<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Change Password</title>
</head>
<body>
    <h2>Change Password</h2>

    <!-- Show messages using scriptlets -->
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("errorMessage");
        if (successMessage != null) {
    %>
        <p style="color: green;"><%= successMessage %></p>
    <%
        }
        if (errorMessage != null) {
    %>
        <p style="color: red;"><%= errorMessage %></p>
    <%
        }
    %>

    <!-- Form for changing password -->
    <form action="<%= request.getContextPath() %>/user/updatepassword" method="post">
        <label for="old-password">Current Password:</label>
        <input type="password" name="old-password" required><br><br>

        <label for="new-password">New Password:</label>
        <input type="password" name="new-password" required><br><br>

        <button type="submit">Update Password</button>
    </form>

    <p><a href="<%= request.getContextPath() %>/index.jsp">Back to Home</a></p>
</body>
</html>
