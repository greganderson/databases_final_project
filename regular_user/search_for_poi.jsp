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
%>


<div id="regular_user_content">
<h1>Search for POI</h1>

<form method="post" role="form">
	<!-- Name -->
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" value="">Name</label>
		</div>
		<label for="name">Name:</label>
		<input type="text" class="form-control" id="name">
	</div>

	<!-- Price range -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" value="">Price Range</label>
		</div>
		<select id="priceRange" class="form-control">
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
			<label><input type="checkbox" value="">Address</label>
		</div>
		<label for="city">City:</label>
		<input type="text" class="form-control" id="city">
		<label for="state">State:</label>
		<input type="text" class="form-control" id="state">
	</div>

	<!-- Keywords -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" value="">Keywords</label>
		</div>
		<label for="keywords">Keywords (comma separated):</label>
		<input type="text" class="form-control" id="keywords">
	</div>

	<!-- Category -->
	<hr>
	<div class="form-group">
		<div class="checkbox">
			<label><input type="checkbox" value="">Category</label>
		</div>
		<select id="category" class="form-control">
			<%
			List<String> categories = user.getListOfCategories(connector.con);
			for (String s : categories)
				out.println("<option>" + s + "</option>");
			%>
		</select>
	</div>
</form>

</div>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
