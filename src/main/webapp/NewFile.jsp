<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<%@ page import="com.switchbit.model.User" %>
<!DOCTYPE html>
<html>
<head>
    <title>Signup Success 2</title>
</head>
<body>
    <h2>Signup Successful 2!</h2>

    <%
        User user = (User) session.getAttribute("user");
        if (user != null) {
    %>
        <p>Welcome, <strong><%= user.getUserName() %></strong>!</p>
        <p>Your User ID is: <%= user.getUserId() %></p>
    <%
        }
    %>

    <a href="index.jsp">Go to Home</a>
</body>
</html>
