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

String ordering = request.getParameter("ordering");
if (ordering == null)
	ordering = "";
String includeScoreStr = request.getParameter("includeScore");
String includeTrustedParamsStr = request.getParameter("includeTrustedParams");

boolean includeScore = false;
boolean includeTrustedParams = false;
if (includeScoreStr != null && includeScoreStr != "")
	includeScore = Boolean.parseBoolean(includeScoreStr);
if (includeTrustedParamsStr != null && includeTrustedParamsStr != "")
	includeTrustedParams = Boolean.parseBoolean(includeTrustedParamsStr);

SearchObject searchObject = new SearchObject(name, priceRange, city + " " + state, keywords, category, ordering, includeScore, includeTrustedParams);
List<POIInformation> pois = user.searchForPOI(connector.con, searchObject);
%>


<div>
<h1>Search results</h1>

<div class="container">
	<h3>POI's</h3>
	<table class="table table-bordered">
		<thead>
			<tr>
				<th>Name</th>
				<th>Address</th>
				<th>URL</th>
				<th>Phone number</th>
				<th>Price per person</th>
				<th>Year established</th>
				<th>Hours</th>
				<th>Category</th>
				<th>Average feedback score</th>
			</tr>
		</thead>
		<tbody>
			<%
				for (POIInformation poi : pois) {
					out.println("<tr><td>" + poi.name + "</td>");
					out.println("<td>" + poi.address + "</td>");
					out.println("<td>" + poi.url + "</td>");
					out.println("<td>" + poi.phoneNumber + "</td>");
					out.println("<td>" + poi.pricePerPerson + "</td>");
					out.println("<td>" + poi.yearEstablished + "</td>");
					out.println("<td>" + poi.hours + "</td>");
					out.println("<td>" + poi.category + "</td>");
					out.println("<td>" + poi.averageFeedbackScore + "</td></tr>");
				}
			%>
		</tbody>
	</table>
</div>

<form method="post">
	<input type="hidden" id="ordering" name="ordering">
	<input type="hidden" id="includeScore" name="includeScore">
	<input type="hidden" id="includeTrustedParams" name="includeTrustedParams">
</form>

</div>

<script>
function toggleSortByPrice() {
	// TODO: Implement
	// TODO: Figure out how to toggle asc vs desc
	$('#ordering').val(' order by p.price_per_person asc');
	//$('#ordering').val(' order by p.price_per_person desc');
	$('#includeScore').val(false);
	$('#includeTrustedParams').val(false);
}

function sortByAverageFeedbackScore() {
	// TODO: Implement
	$('#ordering').val(' order by score desc');
	$('#includeScore').val(true);
	$('#includeTrustedParams').val(false);
}

function sortByAverageTrustedFeedbackScore() {
	// TODO: Implement
	$('#ordering').val(' order by score desc');
	$('#includeScore').val(true);
	$('#includeTrustedParams').val(true);
}
</script>
<%
//response.sendRedirect("regular_user.jsp");
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
