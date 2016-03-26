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

<!-- Toggling functions -->
var MAIN = "MAIN";
<!-- Regular User -->
var REGULAR_USER = "REGULAR_USER";
var RECORD_A_VISIT = "RECORD_A_VISIT";
<!-- Admin -->
var ADMIN = "ADMIN";
var NONE = "NONE";

function showView(view) {
	$("#main_content").hide();
	$("#regular_user_content").hide();
	$("#regular_record_a_visit").hide();
	$("#admin_content").hide();

	if (view == MAIN)
		$("#main_content").show();
	else if (view == REGULAR_USER)
		$("#regular_user_content").show();
	else if (view == RECORD_A_VISIT)
		$("#regular_record_a_visit").show();
	else if (view == ADMIN)
		$("#admin_content").show();
}

</script> 
</head>
<body>

<%!

public String getUserInputPOINameJsp(User user, String question, Connection con) {
	TreeSet<String> pois = user.getUserInputPOIName(con);
	String result = "<h2>" + question + "</h2><div class=\"list-group\">";
	for (String poi : pois)
		result += "<button class=\"list-group-item\" onclick=\"return this\">" + poi + "</button>";
	return result + "<button class=\"list-group-item\">Exit</button></div>";
}

%>


<%
// Global variables
Connector connector = new Connector();
User user = new User();
String username = request.getParameter("username");
%>

<%@ include file="main.jsp" %>
<%@ include file="regular_user.jsp" %>
<%@ include file="admin.jsp" %>
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

	Starter main = new Starter();
	if (!is_admin) {
		user = new RegularUser(username);
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
	else {
		user = new Admin(username);
		boolean success = user.login(username, password, true, connector.con);
		if (success) {
			%>
			<script>showView(ADMIN);</script>
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
