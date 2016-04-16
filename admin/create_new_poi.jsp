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

String costPerPerson = request.getParameter("costPerPersonSave");
if (costPerPerson == null || costPerPerson == "") {
%>

<div>
<h1>Create New POI:</h1>

<form method="post">
	<div class="form-group">
		<label for="poiName">Name:</label>
		<input class="form-control" type="text" max="50" id="poiName" name="poiName" placeholder="The Pizza Place" required>

		<label for="address">Address:</label>
		<input class="form-control" type="text" max="80" id="address" name="address" placeholder="123 S. 456 E. Beaver, UT 12345" required>

		<label for="url">URL:</label>
		<input class="form-control" type="url" max="50" id="url" name="url" placeholder="www.mywebsitegoeshere.com" required>

		<label for="phone_num">Phone Number:</label>
		<input class="form-control" type='text' id="phone_num" name="phone_num" pattern='[\(]\d{3}[\)][\-]\d{3}[\-]\d{4}' title='Phone Number (Format: (123)-456-7890)' placeholder="(123)-456-7890" required>

		<div class="form-group">
			<label for="costPerPerson">Cost Per Person</label>
			<div class="input-group">
				<div class="input-group-addon">$</div>
				<input type="text" class="form-control" id="costPerPerson" placeholder="Amount" name="costPerPerson">
			</div>
		</div>

		<label for="yearEstablished">Year of Establishment:</label>
		<input class="form-control" type="text" min="4" max="4" id="yearEstablished" name="yearEstablished" placeholder="1970" required>

		<label for="hours">Hours:</label>
		<input class="form-control" type="text" max="22" id="hours" name="hours" placeholder="7:00am-9:00pm" required>

		<label for="category">Category:</label>
		<input class="form-control" type="text" max="50" id="category" name="category" placeholder="restaurant" required>



		<label for="fullname">Full name:</label>
		<input class="form-control" type="text" max="40" id="fullname" name="fullname" placeholder="John Psmythe" required>
	</div>
	<button type="submit" class="btn btn-default">Submit</button>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<%
}
else {
	out.println("<h1>OUTPUT PAGE</h1>");
	//response.sendRedirect("regular_user.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
