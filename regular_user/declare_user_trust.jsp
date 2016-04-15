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

String name = request.getParameter("name");
String trusted = request.getParameter("trusted");
if (name == null || name == "") {
%>

<div>
<h1>Declare a user as trusted (or not):</h1>

<div class="container">
	<h3>Users</h3>
	<form method="post" onsubmit="return saveTrust()">
		<table id="data" class="table">
			<thead>
				<tr>
					<th>User</th>
				</tr>
			</thead>
			<tbody>
				<%
					Set<String> result = user.declareUserTrust(connector.con);
					for (String s : result)
						out.println("<tr class=\"clickable-row\" onmouseover=\"\" style=\"cursor: pointer;\"><td>" + s + "</td></tr>");
				%>
			</tbody>
		</table>
		<select id="trustedOption" class="form-control">
			<option value="1">Trusted</option>
			<option value="-1">Not Trusted</option>
		</select>
		<button type="submit" class="btn btn-default">Execute Judgement</button>
		<input type="hidden" id="name" name="name">
		<input type="hidden" id="trusted" name="trusted">
	</form>
</div>

<script>
selectedUser = ''
function saveTrust() {
	if (selectedUser == '')
		return false;
	$('#name').val(selectedUser);
	$('#trusted').val($('#trustedOption').val());
	return true;
}

$('#data').on('click', '.clickable-row', function(event) {
	if($(this).hasClass('active')){
		$(this).removeClass('active'); 
		selectedUser = '';
	} else {
		$(this).addClass('active').siblings().removeClass('active');
		selectedUser = this.innerText;
	}
});
</script>

</div>

<%
}
else {
	user.declareUserTrustSql(connector.con, name, Integer.parseInt(trusted));
	response.sendRedirect("regular_user.jsp");
}
%>

<!-- Include all compiled plugins (below), or include individual files as needed -->
<script src="../js/bootstrap.min.js"></script>
</body>
</html>
