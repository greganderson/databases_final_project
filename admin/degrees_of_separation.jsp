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
Admin user = new Admin(username);

String user1 = request.getParameter("user1");
String user2 = request.getParameter("user2");
if (user1 == null || user1 == "") {
%>

<div>
<h1>Select Two Users:</h1>

<form role="form" method="post" onsubmit="return check()">
	<div class="row">
		<div class="col-md-6">
			<label for="notSelected">Not Selected</label>
			<ul id="notSelected" class="list-group">
				<%
				Set<String> users = user.getListOfUsers(connector.con);
				String notSelectedSpan = "<span onmouseover=\"\" onclick=\"addUser(this.parentElement)\" style=\"font-size: 16px; cursor: pointer;\" class=\"pull-right hidden-xs showopacity glyphicon glyphicon-plus\"></span>";
				String selectedSpan = "<span onmouseover=\"\" onclick=\"removeUser(this.parentElement)\" style=\"font-size: 16px; cursor: pointer;\" class=\"pull-right hidden-xs showopacity glyphicon glyphicon-minus\"></span>";
				for (String u : users)
					out.println("<li class=\"list-group-item\">" + u + notSelectedSpan + "</li>");
				%>
			</ul>
		</div>
		<div class="col-md-6">
			<label for="selected">Selected</label>
			<ul id="selected" class="list-group">
			</ul>
		</div>
	</div>
	<input type="hidden" id="user1" name="user1">
	<input type="hidden" id="user2" name="user2">
	<button type="submit" class="btn btn-default">Submit</button>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<script>
function check() {
	var selectedUsers = $('#selected li').get();
	if (selectedUsers.length != 2) {
		alert('Please select 2 users');
		return false;
	}
	$('#user1').val(selectedUsers[0].innerText);
	$('#user2').val(selectedUsers[1].innerText);
	return true;
}

function addUser(item) {
	$('#selected').append('<li class="list-group-item">' + item.innerText + '<%=selectedSpan%></li>');
	var items = $('#selected li').get();
	items.sort(comparator);
	$.each(items, function(i, li) {
		$('#selected').append(li);
	});
	item.remove();
}

function removeUser(item) {
	$('#notSelected').append('<li class="list-group-item">' + item.innerText + '<%=notSelectedSpan%></li>');
	var items = $('#notSelected li').get();
	items.sort(comparator);
	$.each(items, function(i, li) {
		$('#notSelected').append(li);
	});
	item.remove();
}

function comparator(a, b) {
	var keyA = $(a).text();
	var keyB = $(b).text();

	if (keyA < keyB)
		return -1;
	if (keyA > keyB)
		return 1;
	return 0;
}
</script>

<%
}
else {
	out.println("<h1>Degrees of Separation</h1>");
	String separation = user.getDegreesOfSeparation(connector.con, user1, user2);
	out.println("<h3>" + separation + "</h3>");
	out.println("<button type=\"button\" class=\"btn btn-default\" onclick=\"window.location.replace('admin.jsp')\">Go back</button>");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
