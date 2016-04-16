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

if (true) {
%>

<div>
<h1>Select Two Users:</h1>

<h3>POI</h3>
<form role="form" method="post">
	<div class="row">
		<div class="col-md-6">
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
			<ul id="selected" class="list-group">
			</ul>
		</div>
	</div>
</form>

<button type="button" class="btn btn-default" onclick="window.location.replace('admin.jsp')">Go back</button>

</div>

<script>
function addUser(item) {
	$('#selected').append('<li class="list-group-item">' + item.innerText + '<%=selectedSpan%></li>');
	item.remove();
}

function removeUser(item) {
	$('#notSelected').append('<li class="list-group-item">' + item.innerText + '<%=notSelectedSpan%></li>');
	item.remove();
}
</script>

<%
}
else {
	out.println("<h1>OUTPUT PAGE</h1>");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
