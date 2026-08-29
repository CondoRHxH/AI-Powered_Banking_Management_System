<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
HttpSession userSession = request.getSession(false);

if(userSession == null || userSession.getAttribute("user") == null) {
    response.sendRedirect("Login_Servlet");
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Dashboard</title>
</head>
<body>
    <h1>Hello hello 😎</h1>
</body>
</html>