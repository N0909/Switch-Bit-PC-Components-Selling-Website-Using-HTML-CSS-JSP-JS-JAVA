<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.switchbit.model.User" %>
<html>
<head>
    <title>Welcome</title>
</head>
<body>
	<%
        User user = (User) session.getAttribute("user");
        if (user != null) {
    %>
    	<h2>Welcome, <%= user.getUserName() %></h2>
   	
    <p>You are successfully logged in.</p>

    <form action="<%=request.getContextPath()%>/user/logout" method="get">
        <button type="submit">Logout</button>
    </form>
    <%
        }else{  	
   	%>	
   		<p>You are not logged in.</p>
     <%
     	}
     %>
   	
</body>
</html>
