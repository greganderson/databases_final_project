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

String poiName = request.getParameter("poiName");
if (poiName == null || poiName == "") {
%>

<div>
<h1>Rate feedback:</h1>

<div class="container">
	<h3>Feedback</h3>
	<table id="data" class="table">
		<thead>
			<tr>
				<th>User</th>
				<th>POI</th>
				<th>Score</th>
				<th>Feedback</th>
				<th>Feedback Date</th>
			</tr>
		</thead>
		<tbody>
			<%
				FeedbackInformation result = user.rateFeedback(connector.con);
				for (Map.Entry<Integer, FeedbackData> entry : result.feedbackDataSet.entrySet()) {
					FeedbackData fbd = entry.getValue();
					out.println("<tr class=\"clickable-row\" onmouseover=\"\" style=\"cursor: pointer;\"><td>" + result.usernameToFullName.get(fbd.username) + "</td>");
					out.println("<td>" + result.pidToPOIName.get(fbd.pid) + "</td>");
					out.println("<td>" + fbd.score + "</td>");
					out.println("<td>" + fbd.text + "</td>");
					out.println("<td>" + fbd.date + "</td></tr>");
				}
			%>
		</tbody>
	</table>
</div>

<script>
$('#data').on('click', '.clickable-row', function(event) {
	if($(this).hasClass('active')){
		$(this).removeClass('active'); 
	} else {
		$(this).addClass('active').siblings().removeClass('active');
	}
});
</script>

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
