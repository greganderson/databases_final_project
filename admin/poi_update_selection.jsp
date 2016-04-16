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

<%
Connector connector = new Connector();
String username = (String)session.getAttribute("username");
Admin user = new Admin(username);

String poiName = request.getParameter("poiName");
if (poiName == null || poiName == "") {
%>

<div>
<h1>Select POI to Update:</h1>

<h3>POI</h3>
<form role="form" method="post">
	<div class="list-group">
	<%
	TreeSet<String> pois = user.getUserInputPOIName(connector.con);
	String start = "<button type=\"text\" class=\"list-group-item\" onclick=\"clicked(this)\" name=\"poiName\" value=\"";
	for (String poi : pois)
		out.println(start + poi + "\">" + poi + "</button>");
	%>
	</div>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<%
}
else {
	session.setAttribute("poiName", poiName);
	response.sendRedirect("update_poi.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
