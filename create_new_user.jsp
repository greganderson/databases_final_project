<%@ page language="java" import="cs5530.*,java.util.*,java.sql.*" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!-- The above 3 meta tags *must* come first in the head; any other head content must come *after* these tags -->
<title>UTrack</title>

<!-- Bootstrap -->
<link href="css/bootstrap.min.css" rel="stylesheet">

<!-- jQuery (necessary for Bootstraps JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
</head>
<body>

<%
Connector connector = new Connector();

String username = request.getParameter("username");
if (username == null || username == "") {
%>

<div>
<h1>New Account Info:</h1>

<form method="post">
	<div class="form-group">
		<label for="username">Username:</label>
		<input class="form-control" type="text" max="30" id="username" name="username" required>

		<label for="password">Password:</label>
		<input class="form-control" type="password" max="30" id="password" name="password" required>

		<label for="fullname">Full name:</label>
		<input class="form-control" type="text" max="40" id="fullname" name="fullname" required>

		<label for="address">Address:</label>
		<input class="form-control" type="text" max="80" id="address" name="address" required>

		<label for="phone_num">Phone number:</label>
		<input class="form-control" type='text' id="phone_num" name="phone_num" pattern='[\(]\d{3}[\)][\-]\d{3}[\-]\d{4}' title='Phone Number (Format: (123)-456-7890)' required>
	</div>
	<button type="submit" class="btn btn-default">Submit</button>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('index.jsp')">Go back</button>

</div>

<%
}
else {
	String password = request.getParameter("password");
	String fullname = request.getParameter("fullname");
	String address = request.getParameter("address");
	String phoneNum = request.getParameter("phone_num");
	out.println("<h1>" + phoneNum + "</h1>");
	phoneNum = phoneNum.replaceAll("[\\(\\)-]", "");
	out.println("<h1>" + phoneNum + "</h1>");

	boolean success = RegularUser.createNewUser(connector.con, username, password, fullname, address, phoneNum);
	if (success) {
		session.setAttribute("username", username);
		response.sendRedirect("regular_user/regular_user.jsp");
	}
	else {
		out.println("<h1>Invalid something or other</h1>");
	}
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>
</body>
</html>
