<%@ page language="java" import="cs5530.*,java.util.TreeSet,java.sql.*" %>
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

<script LANGUAGE="javascript">

function check_all_fields(form_obj) {
	alert(form_obj.searchAttribute.value+"='"+form_obj.attributeValue.value+"'");
	if( form_obj.attributeValue.value == ""){
		alert("Search field should be nonempty");
		return false;
	}
	return true;
}

</script> 
</head>
<body>

<%
String username = request.getParameter("username");

if(username == null || username == ""){
%>

<div>
<h1>Welcome to the UTrack system!</h1>


	<h3>Regular User:</h3>
	<form role="form" name="user_search" method="post" onsubmit="return check_all_fields(this)">
		<div class="form-group">
			<label for="username">Username:</label>
			<input type="text" class="form-control" name="username">
		</div>
		<div class="form-group">
			<label for="password">Password:</label>
			<input type="password" class="form-control" name="password">
		</div>
		<button type="submit" class="btn btn-default" name="regular_user_submit">Login</button>
	</form>

	<button type="button" class="btn btn-default" onclick="window.location.replace('create_new_user.jsp')">Create new account</button>

	<h3>Administrator:</h3>
	<form for="form" name="user_search" method="post" onsubmit="return check_all_fields(this)">
		<div class="form-group">
			<label for="username">Username:</label>
			<input type="text" class="form-control" name="username">
		</div>
		<div class="form-group">
			<label for="password">Password:</label>
			<input type="password" class="form-control" name="password">
		</div>
		<button type="submit" class="btn btn-default" name="admin_submit">Login</button>
	</form>
</div>

<%
} else {
	String password = request.getParameter("password");

	Connector connector = new Connector();

	User user;

	boolean is_admin = false;
	if (request.getParameter("admin_submit") != null)
		is_admin = true;

	if (!is_admin) {
		user = new RegularUser(username);
		boolean success = user.login(username, password, false, connector.con);
		if (success) {
			session.setAttribute("username", username);
			response.sendRedirect("regular_user/regular_user.jsp");
		}
		else {
			%>
			<script>alert("Invalid username or password");</script>
			<%
		}
	}
	else {
		user = new Admin(username);
		boolean success = user.login(username, password, true, connector.con);
		if (success) {
			session.setAttribute("username", username);
			response.sendRedirect("admin/admin.jsp");
		}
		else {
			%>
			<script>alert("Invalid username or password");</script>
			<%
		}
	}
	
	connector.closeConnection();
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>
</body>
</html>
