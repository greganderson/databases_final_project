<%@ page language="java" import="cs5530.*,java.util.*,java.sql.*" %>
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

<div>
<h1>Top rated feedback:</h1>

<form method="post">
	<div class="form-group">
		<div class="form-control">
			<input type="number" id="top" name="top" min="1">
		</div>
	</div>
	<button type="submit" class="btn btn-default">Go!</button>
</form>

<%

String topStr = request.getParameter("top");
if (topStr != null && topStr != "") {
	int top = Integer.parseInt(topStr);
%>
<table class="table table-hover">
	<h3>Feedback</h3>
	<thead>
		<tr>
			<th>User</th>
			<th>POI Name</th>
			<th>Feedback Score</th>
			<th>Text</th>
			<th>Feedback Date</th>
			<th>Average Usefulness Rating</th>
		</tr>
	</thead>
	<tbody>
		<%
		List<TopFeedbackInformation> result = user.findTopNMostUsefulFeedbacks(connector.con, top);
		for (TopFeedbackInformation info : result) {
			out.println("<tr><th>" + info.user + "</th>");
			out.println("<th>" + info.poiName + "</th>");
			out.println("<th>" + info.score + "</th>");
			out.println("<th>" + info.text + "</th>");
			out.println("<th>" + info.date + "</th>");
			out.println("<th>" + info.rating + "</th></tr>");
		}
		%>
	</tbody>
</table>
<%
}
%>

<button type="button" class="btn btn-default" onclick="window.location.replace('regular_user.jsp')">Go back</button>

</div>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
