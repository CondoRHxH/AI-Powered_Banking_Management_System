<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<h1>Hello</h1>
	
	<form method="POST" action="Login_Servlet">
		<label>Nom : </label>
		<input type="text" name="nom"><br> <br>
		
		<label>Prenom : </label>
		<input type="text" name="prenom"><br> <br>
		
		<label>Email : </label>
		<input type="text" name="email"><br> <br>
		
		<label>Pass : </label>
		<input type="text" name="password"><br> <br>
		
		<input type="submit" value="Submit">
	</form>
</body>
</html>