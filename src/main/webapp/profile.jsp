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
    <title>User Profile</title>
</head>
<body>
    <h2>Welcome, <%= user.getUserName() %></h2>
    <p><strong>Email:</strong> <%= user.getUserEmail() %></p>
    <p><strong>Phone:</strong> <%= user.getUserPhone() %></p>
    <p><strong>Address:</strong> <%= user.getUserAddress() %></p>

    <a href="<%=request.getContextPath()%>/update-user.jsp">Edit Profile</a>
</body>
</html>
