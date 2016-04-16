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
<h1>Cool Statistics:</h1>

<form method="post">
	<div class="form-group">
		<div class="form-control">
			<label for="topResults">Number of results to show:</label>
			<input type="number" id="topResults" name="topResults" min="1" required>
		</div>
		<div class="form-inline">
			<label for="statSelection">Statistic to show:</label>
			<select id="statSelection" name="statSelection" class="form-control">
				<option value="0">Top most popular POI's per category</option>
				<option value="1">Most expensive POI's per category</option>
				<option value="2">Top rated POI's per category</option>
			</select>
		</div>
	</div>
	<input type="hidden" id="stat" name="stat">
	<button type="submit" class="btn btn-default">Go!</button>
</form>

<%

String statSelectionStr = request.getParameter("statSelection");
if (statSelectionStr != null && statSelectionStr != "") {
	int statSelection = Integer.parseInt(statSelectionStr);
	int numResults = Integer.parseInt(request.getParameter("topResults"));

	String sql = "";
	String secondField = "";
	if (statSelection == 0) {
		sql = "select p.name, count(*) from Visit v, POI p where v.pid = p.pid and " +
		"p.category = ? group by v.pid order by count(*) desc limit " + numResults;
		secondField = "Total number of visits";
	}
	else if (statSelection == 1) {
		sql = "select p.name, avg(e.cost) from Visit v, POI p, VisitEvent e where " +
		"v.pid = p.pid and v.vid = e.vid and p.category = ? group by v.pid order by " +
		"avg(e.cost) desc limit " + numResults;
		secondField = "Price per person";
	}
	else if (statSelection == 2) {
		sql = "select p.name, avg(f.score) from Feedback f, POI p where f.pid = p.pid " +
		"and p.category = ? group by p.pid order by avg(f.score) desc limit " + numResults;
		secondField = "Average feedback score";
	}

	List<String> categories = user.getCategories(connector.con);
	for (String category : categories) {
		List<String[]> result = user.getTopNStatPOIs(connector.con, sql, category);
%>
<h3><%=category%></h3>
<table class="table table-hover">
	<thead>
		<tr>
			<th>POI Name</th>
			<th><%=secondField%></th>
		</tr>
	</thead>
	<tbody>
		<%
		for (String[] poi : result) {
			out.println("<tr><th>" + poi[0] + "</th>");
			out.println("<th>" + poi[1] + "</th></tr>");
		}
		%>
	</tbody>
</table>
<%
	}
}
%>

<button type="button" class="btn btn-default" onclick="window.location.replace('regular_user.jsp')">Go back</button>

</div>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
