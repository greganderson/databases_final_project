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

<!-- Toggling functions -->
var MAIN = "MAIN";
var REGULAR_USER = "REGULAR_USER";
var NONE = "NONE";

function showView(view) {
	$("#main_content").hide();
	$("#regular_user_content").hide();

	if (view == MAIN)
		$("#main_content").show();
	else if (view == REGULAR_USER)
		$("#regular_user_content").show();
		
}

</script> 
</head>
<body>
<%
String username = request.getParameter("username");
%>
<%@ include file="main.jsp" %>
<%@ include file="regular_user.jsp" %>
<script>showView(NONE);</script>

<%


if(username == null || username == ""){
	%>
	<script>showView(MAIN);</script>
	<%
} else {
	String password = request.getParameter("password");

	boolean is_admin = false;
	if (request.getParameter("admin_submit") != null)
		is_admin = true;

	Connector connector = new Connector();
	Starter main = new Starter();
	if (!is_admin) {
		RegularUser user = new RegularUser(username);
		boolean success = user.login(username, password, false, connector.con);
		if (success) {
			%>
			<script>showView(REGULAR_USER);</script>
			<%
		}
		else {
			%>
			<script>alert("Invalid username or password"); showView(MAIN);</script>
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
