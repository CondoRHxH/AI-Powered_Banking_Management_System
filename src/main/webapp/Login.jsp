<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form method="POST" action="Login_Servlet">
		<label>Email : </label>
		<input type="text" name="email">
		
		<label>Password : </label>
		<input type="text" name="password">
	
		<button type="submit">Login</button>
	</form>
</body>
</html>