<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.switchbit.model.User" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<html>
<head>
    <title>Update Profile</title>
</head>
<body>
    <h2>Update Your Profile</h2>

    <% if (request.getAttribute("errorMessage") != null) { %>
        <p style="color:red;"><%= request.getAttribute("errorMessage") %></p>
    <% } %>

    <form action="<%= request.getContextPath() %>/user/update" method="post">
        <input type="hidden" name="userId" value="<%= user.getUserId() %>">

        <label>Name:</label>
        <input type="text" name="user-name" value="<%= user.getUserName() %>" required><br><br>

        <label>Email:</label>
        <input type="email" name="user-email" value="<%= user.getUserEmail() %>" required><br><br>

        <label>Phone:</label>
        <input type="text" name="user-phone" value="<%= user.getUserPhone() %>" required><br><br>

        <label>Address:</label>
        <input type="text" name="user-address" value="<%= user.getUserAddress() %>"><br><br>

        <button type="submit">Update</button>
    </form>
</body>
</html>
