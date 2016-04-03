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
<link href="../css/bootstrap.min.css" rel="stylesheet">

<!-- jQuery (necessary for Bootstraps JavaScript plugins) -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js"></script>
</head>
<body>

<%!
public String getUserInputPOINameJsp(User user, String question, Connection con) {
	TreeSet<String> pois = user.getUserInputPOIName(con);
	String result = "<h2>" + question + "</h2><div class=\"list-group\">";
	for (String poi : pois)
		result += "<button class=\"list-group-item\" name=\"" + poi + "\">" + poi + "</button>";
	return result + "<button class=\"list-group-item\">Exit</button></div>";
}
%>

<%
String username = (String)session.getAttribute("username");
RegularUser user = new RegularUser(username);

%>


<div id="regular_user_content">
<h1>Welcome <%=username%>!</h1>

<div class="list-group">
	<button class="list-group-item">Record a visit</button>
	<button class="list-group-item">Set a favorite POI</button>
	<button class="list-group-item">Provide feedback for a POI</button>
	<button class="list-group-item">Rate a feedback</button>
	<button class="list-group-item">Declare a user as trusted or not</button>
	<button class="list-group-item">Search for a POI</button>
	<button class="list-group-item">See top rated feedback</button>
	<button class="list-group-item">See cool statistics</button>
	<button class="list-group-item">Logout</button>
</div>

</div>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
