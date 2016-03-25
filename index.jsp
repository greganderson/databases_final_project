<%@ page language="java" import="cs5530.*" %>
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

<script LANGUAGE="javascript">

function check_all_fields(form_obj){
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
<h1>Welcome to the UTrack system!</h1>

<%
String username = request.getParameter("username");
if(username == null){
%>

	<h3>Regular User:</h3>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)">
		Username: <input type=text name="username">
		Password: <input type=password name="password">
		<input type=submit name="regular_user_submit">
	</form>

	<h3>Create new account:</h3>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)">
		Username: <input type=text name="username">
		<input type=submit name="create_new_account_submit">
	</form>

	<h3>Administrator:</h3>
	<form name="user_search" method=get onsubmit="return check_all_fields(this)">
		Username: <input type=text name="username">
		Password: <input type=password name="password">
		<input type=submit name="admin_submit">
	</form>

<%

} else {

	String password = request.getParameter("password");

	boolean is_admin = false;
	if (request.getParameter("admin_submit") != null)
		is_admin = true;

	%>
	Here is what I got: username = <%=username%>, password = <%=password%>, is_admin = <%=is_admin%>
	<%

	Connector connector = new Connector();
	Starter main = new Starter();
	if (!is_admin) {
		//RegularUser user = new RegularUser(username);
		//user.login(username, password, false, con.con);
	}
	%>
	SQL results: <%=main.getTest(connector.stmt)%>
	
	<%
	//Connector connector = new Connector();
	//Order order = new Order();
	
	//connector.closeStatement();
	//connector.closeConnection();
}
%>

<!-- jQuery (necessary for Bootstraps JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="js/bootstrap.min.js"></script>
</body>
</html>
