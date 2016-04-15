<%@ page language="java" import="cs5530.*,java.util.List,java.sql.*" %>
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
RegularUser user = new RegularUser(username);

String name = (String)session.getAttribute("name");
String priceRange = (String)session.getAttribute("priceRange");
String city = (String)session.getAttribute("city");
String state = (String)session.getAttribute("state");
String keywords = (String)session.getAttribute("keywords");
String category = (String)session.getAttribute("category");

SearchObject searchObject = new SearchObject(name, priceRange, city + " " + state, keywords, category);
user.searchForPOI(connector.con, searchObject);

if ((name == null || name == "") &&
	(priceRange == null || priceRange == "") &&
	(city == null || city == "") &&
	(state == null || state == "") &&
	(keywords == null || keywords == "") &&
	(category == null || category == "")) {
%>


<div>
<h1>Search results</h1>


</div>

<script>
</script>
<%
}
else {
	out.println("<h1>OUTPUT PAGE</h1>");
	out.println("<h3>Name: " + name + "</h3>");
	out.println("<h3>Name: " + priceRange + "</h3>");
	out.println("<h3>Name: " + city + "</h3>");
	out.println("<h3>Name: " + state + "</h3>");
	out.println("<h3>Name: " + keywords + "</h3>");
	out.println("<h3>Name: " + category + "</h3>");
	//response.sendRedirect("regular_user.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
