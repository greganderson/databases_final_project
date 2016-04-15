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

String name = request.getParameter("name");
String priceRange = request.getParameter("priceRange");
String city = request.getParameter("city");
String state = request.getParameter("state");
String keywords = request.getParameter("keywords");
String category = request.getParameter("category");
if ((name == null || name == "") &&
	(priceRange == null || priceRange == "") &&
	(city == null || city == "") &&
	(state == null || state == "") &&
	(keywords == null || keywords == "") &&
	(category == null || category == "")) {
%>


<div>
<h1>Search for POI</h1>

<form method="post" onsubmit="return search()">
	<!-- Name -->
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" id="nameCheck" value="">Name</label>
		</div>
		<label for="name">Name:</label>
		<input type="text" class="form-control" id="name" name="name">
	</div>

	<!-- Price range -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" id="priceRangeCheck" value="">Price Range</label>
		</div>
		<select id="priceRange" name="priceRange" class="form-control">
			<option>$0 - $10</option>
			<option>$10 - $20</option>
			<option>$20 - $30</option>
			<option>$30 - $40</option>
			<option>$40 - $50</option>
			<option>$50 and more</option>
		</select>
	</div>

	<!-- Address -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" id="addressCheck" value="">Address</label>
		</div>
		<label for="city">City:</label>
		<input type="text" class="form-control" id="city" name="city">
		<label for="state">State:</label>
		<input type="text" class="form-control" id="state" name="state">
	</div>

	<!-- Keywords -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" id="keywordsCheck" value="">Keywords</label>
		</div>
		<label for="keywords">Keywords (comma separated):</label>
		<input type="text" class="form-control" id="keywords" name="keywords">
	</div>

	<!-- Category -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" id="categoryCheck" value="">Category</label>
		</div>
		<select id="category" name="category" class="form-control">
			<%
			List<String> categories = user.getListOfCategories(connector.con);
			for (String s : categories)
				out.println("<option>" + s + "</option>");
			%>
		</select>
	</div>

	<button type="submit" class="btn btn-default">Search</button>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('regular_user.jsp')">Go back</button>

</div>

<script>
function search() {
	// Clear out all search parameters that aren't checked
	if (!$('#nameCheck').is(':checked'))
		$('#name').val('');
	if (!$('#priceRangeCheck').is(':checked'))
		$('#priceRange').val('');
	if (!$('#addressCheck').is(':checked')) {
		$('#city').val('');
		$('#state').val('');
	}
	if (!$('#keywordsCheck').is(':checked'))
		$('#keywords').val('');
	if (!$('#categoryCheck').is(':checked'))
		$('#category').val('');
	return true;
}
</script>
<%
}
else {
	session.setAttribute("name", name);
	session.setAttribute("priceRange", priceRange);
	session.setAttribute("city", city);
	session.setAttribute("state", state);
	session.setAttribute("keywords", keywords);
	session.setAttribute("category", category);
	response.sendRedirect("search_results.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
