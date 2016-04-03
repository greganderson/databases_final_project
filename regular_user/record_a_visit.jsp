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
Connector connector = new Connector();
String username = (String)session.getAttribute("username");
RegularUser user = new RegularUser(username);
%>


<div id="regular_user_content">
<h1>Record a visit:</h1>

<h3>POI</h3>
<select class="form-control" required name="poiSelection">
	<%
	TreeSet<String> pois = user.getUserInputPOIName(connector.con);
	for (String poi : pois)
		out.println("<option>" + poi + "</option>");
	%>
</select>


</div>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
