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

String poiName = request.getParameter("poiName");
if (poiName == null || poiName == "") {
%>

<div>
<h1>Select POI to Update:</h1>

<h3>POI</h3>
<form role="form" method="post">
	<div class="list-group">
	<%
	TreeSet<String> pois = user.getUserInputPOIName(connector.con);
	String start = "<button type=\"text\" class=\"list-group-item\" onclick=\"clicked(this)\" name=\"poiName\" value=\"";
	for (String poi : pois)
		out.println(start + poi + "\">" + poi + "</button>");
	%>
	</div>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<%
}
else {
	POIInformation poi = user.updatePOI(connector.con, poiName);
%>
<h1>Update POI:</h1>
<form method="post" onsubmit="saveKeywords();">
	<div class="form-group">
		<label for="poiName">Name:</label>
		<input class="form-control" type="text" max="50" id="poiName" name="poiName" placeholder="The Pizza Place" value="<%=poi.name%>" required>

		<label for="address">Address:</label>
		<input class="form-control" type="text" max="80" id="address" name="address" placeholder="123 S. 456 E. Beaver, UT 12345" value="<%=poi.address%>" required>

		<label for="url">URL:</label>
		<input class="form-control" type="text" max="50" id="url" name="url" placeholder="www.mywebsitegoeshere.com" value="<%=poi.url%>" required>

		<%
		String phone = "(" + poi.phoneNumber.substring(0, 3) + ")-" + poi.phoneNumber.substring(3, 6) + "-" + poi.phoneNumber.substring(6, 10);
		%>
		<label for="phone_num">Phone Number:</label>
		<input class="form-control" type='text' id="phone_num" name="phone_num" pattern='[\(]\d{3}[\)][\-]\d{3}[\-]\d{4}' title='Phone Number (Format: (123)-456-7890)' placeholder="(123)-456-7890" value="<%=phone%>" required>

		<div class="form-group">
			<label for="costPerPerson">Cost Per Person</label>
			<div class="input-group">
				<div class="input-group-addon">$</div>
				<input type="text" class="form-control" id="costPerPerson" placeholder="Amount" name="costPerPerson" value="<%=poi.pricePerPerson%>" required>
			</div>
		</div>

		<label for="yearEstablished">Year of Establishment:</label>
		<input class="form-control" type="text" min="4" max="4" id="yearEstablished" name="yearEstablished" placeholder="1970" value="<%=poi.yearEstablished%>" required>

		<label for="hours">Hours:</label>
		<input class="form-control" type="text" max="22" id="hours" name="hours" placeholder="7:00am-9:00pm" value="<%=poi.hours%>" required>

		<label for="category">Category:</label>
		<input class="form-control" type="text" max="50" id="category" name="category" placeholder="restaurant" value="<%=poi.category%>" required>

		<div class="input-group">
			<input type="text" id="keyword" class="form-control" placeholder="keyword">
			<span class="input-group-btn">
				<button type="button" class="btn btn-default" onclick="addKeyword()">Add</button>
			</span>
		</div>
		<ul id="keywords" class="list-group">
			<%
			String span = "<span onmouseover=\"\" onclick=\"this.parentElement.remove()\" style=\"font-size: 16px; cursor: pointer;\" class=\"pull-right hidden-xs showopacity glyphicon glyphicon-minus\"></span>";
			for (String keyword : poi.keywords)
				out.println("<li class=\"list-group-item\">" + keyword + span + "</li>");
			%>
		</ul>
	</div>

	<input type="hidden" id="keywordList" name="keywordList">
	<button type="submit" class="btn btn-default">Update</button>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<script>
function addKeyword() {
	var exists = false;
	$('#keywords').find('li').each(function () {
		if (this.innerText == $('#keyword').val())
			exists = true;
	});
	// If keyword already exists, don't add it
	var span = '<span onmouseover="" onclick="this.parentElement.remove()" style="font-size: 16px; cursor: pointer;" class="pull-right hidden-xs showopacity glyphicon glyphicon-minus"></span>';
	if (!exists)
		$('#keywords').append('<li class="list-group-item">' + $('#keyword').val() + span + '</li>');
	$('#keyword').val('');
	$('#keyword').focus();
}

function saveKeywords() {
	var keywords = '';
	$('#keywords').find('li').each(function () {
		keywords += this.innerText + ' ';
	});
	$('#keywordList').val(keywords);
}
</script>
<%
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
