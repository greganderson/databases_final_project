<div id="regular_user_content">
<h1>Welcome <%=username%>!</h1>

<div class="list-group">
	<button class="list-group-item" onclick="showView(RECORD_A_VISIT);">Record a visit</button>
	<button class="list-group-item">Set a favorite POI</button>
	<button class="list-group-item">Provide feedback for a POI</button>
	<button class="list-group-item">Rate a feedback</button>
	<button class="list-group-item">Declare a user as trusted or not</button>
	<button class="list-group-item">Search for a POI</button>
	<button class="list-group-item">See top rated feedback</button>
	<button class="list-group-item">See cool statistics</button>
	<button class="list-group-item">Logout</button>
</div>

</div>

<div id="regular_record_a_visit">
<%
String output = getUserInputPOINameJsp(user, "What is your quest:", connector.con);
out.println(output);
%>
</div>
