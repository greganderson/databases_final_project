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
RegularUser user = new RegularUser(username);

String poi = request.getParameter("poi");
if (poi == null || poi == "") {
%>

<div>
<h1>Provide feedback:</h1>

<form role="form" method="post">
	<div class="form-group">
		<label for="poi">POI:</label>
		<select class="form-control" id="poi" name="poi" required>
			<%
			TreeSet<String> pois = user.getUserInputPOIName(connector.con);
			for (String name : pois)
				out.println("<option>" + name + "</option>");
			%>
		</select>
	</div>

	<div class="form-group">
		<label for="score">Score 1-10:</label>
		<select class="form-control" id="score" name="score" required>
			<%
			for (int i = 1; i <= 10; i++)
				out.println("<option>" + i + "</option>");
			%>
		</select>
	</div>

	<div class="form-group">
		<label for="feedback">Feedback (maximum 100 characters)</label>
		<textarea class="form-control" id="feedback" name="feedback" maxlength="100" placeholder="This place was awesome!"></textarea>
	</div>

	<button type="submit" class="btn btn-default">Submit</button>
</form>

</div>

<%
}
else {
	String score = request.getParameter("score");
	String feedback = request.getParameter("feedback");
	boolean success = user.provideFeedback(connector.con, poi, score, feedback);
	if (!success) {
		String error = "Either you've already provided feedback for this POI or something went wrong on the server.  Click to return to home.";
		out.println("<p>" + error + "</p>");
		out.println("<button class=\"btn btn-default\" onclick=\"window.location.replace('regular_user.jsp')\">Return</button>");
	}
	else
		response.sendRedirect("regular_user.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
