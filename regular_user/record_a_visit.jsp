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

<%!
public String getUserInputPOINameJsp(User user, String question, Connection con) {
	TreeSet<String> pois = user.getUserInputPOIName(con);
	String result = "<h2>" + question + "</h2><div class=\"list-group\">";
	for (String poi : pois)
		result += "<button class=\"list-group-item\" name=\"" + poi + "\">" + poi + "</button>";
	return result + "<button class=\"list-group-item\">Exit</button></div>";
}
%>

<%
Connector connector = new Connector();
String username = (String)session.getAttribute("username");
RegularUser user = new RegularUser(username);

String costPerPerson = request.getParameter("costPerPersonSave");
if (costPerPerson == null || costPerPerson == "") {
%>

<div>
<h1>Record a visit:</h1>

<h3>POI</h3>
<select id="poiName" class="form-control" required>
	<%
	TreeSet<String> pois = user.getUserInputPOIName(connector.con);
	for (String poi : pois)
		out.println("<option>" + poi + "</option>");
	%>
</select>

<h3>Cost per person</h3>
<form class="form-inline">
	<div class="form-group">
		<label class="sr-only" for="costPerPerson">Amount (in dollars)</label>
		<div class="input-group">
			<div class="input-group-addon">$</div>
			<input type="text" class="form-control" id="costPerPerson" placeholder="Amount" name="costPerPersonName">
		</div>
	</div>
</form>

<h3>Number of people</h3>
<div class="form-group">
	<select id="numberOfPeople" class="form-control" required>
		<%
		for (int i = 1; i <= 50; i++)
			out.println("<option>" + i + "</option>");
		%>
	</select>
</div>

<h3>Date</h3>
<input id="date" type="date" class="col-xs-2">

<br><br>
<!-- Trigger the modal with a button -->
<button type="button" class="btn btn-info btn-lg" onclick="displayConfirmation();">Open Modal</button>

<!-- Modal -->
<form role="form" method="post" onsubmit="return saveVisit()">
	<input type="hidden" id="poiNameSave" name="poiNameSave">
	<input type="hidden" id="costPerPersonSave" name="costPerPersonSave">
	<input type="hidden" id="numberOfPeopleSave" name="numberOfPeopleSave">
	<input type="hidden" id="dateSave" name="dateSave">
	<div id="confirmationModal" class="modal fade" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">Confirm Visit</h4>
				</div>
				<div class="modal-body">
					<div id="confirmationContent"></div>
				</div>
				<div class="modal-footer">
					<button type="submit" class="btn btn-default">Save</button>
					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>

		</div>
	</div>
</form>

<script>
function displayConfirmation() {
	var poiName = $('#poiName').val();
	var costPerPerson = $('#costPerPerson').val();
	var numberOfPeople = $('#numberOfPeople').val();
	var date = $('#date').val();

	if (costPerPerson == '' || date == '') {
		alert('Please fill out all fields.');
		return;
	}

	var results = '';
	results += '<p><strong>POI:</strong> ' + poiName + '</p>';
	results += '<p><strong>Cost per person:</strong> $' + costPerPerson + '</p>';
	results += '<p><strong>Number of people:</strong> ' + numberOfPeople + '</p>';
	results += '<p><strong>Date:</strong> ' + date + '</p>';
	$('#confirmationContent').html(results);
	$('#confirmationModal').modal({backdrop: 'static'});
}

function saveVisit() {
	$('#poiNameSave').val($('#poiName').val());
	$('#costPerPersonSave').val($('#costPerPerson').val());
	$('#numberOfPeopleSave').val($('#numberOfPeople').val());
	$('#dateSave').val($('#date').val());
	return true;
}
</script>

</div>

<%
}
else {
	String poiName = request.getParameter("poiNameSave");
	String cost = request.getParameter("costPerPersonSave");
	String numberOfPeople = request.getParameter("numberOfPeopleSave");
	String date = request.getParameter("dateSave");
	boolean success = user.recordNewVisit(connector.con, poiName, cost, numberOfPeople, date);
	response.sendRedirect("regular_user.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
