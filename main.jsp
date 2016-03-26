<div id="main_content">
<h1>Welcome to the UTrack system!</h1>


	<h3>Regular User:</h3>
	<form role="form" name="user_search" method=get onsubmit="return check_all_fields(this)">
		<div class="form-group">
			<label for="username">Username:</label>
			<input type="text" class="form-control" name="username">
		</div>
		<div class="form-group">
			<label for="password">Password:</label>
			<input type="password" class="form-control" name="password">
		</div>
		<button type="submit" class="btn btn-default" name="regular_user_submit">Submit</button>
	</form>

	<h3>Create new account:</h3>
	<form role="form" name="user_search" method=get onsubmit="return check_all_fields(this)">
		<div class="form-group">
			<label for="username">Username:</label>
			<input type="text" class="form-control" name="username">
		</div>
		<button type="submit" class="btn btn-default" name="create_new_account_submit">Submit</button>
	</form>

	<h3>Administrator:</h3>
	<form for="form" name="user_search" method=get onsubmit="return check_all_fields(this)">
		<div class="form-group">
			<label for="username">Username:</label>
			<input type="text" class="form-control" name="username">
		</div>
		<div class="form-group">
			<label for="password">Password:</label>
			<input type="password" class="form-control" name="password">
		</div>
		<button type="submit" class="btn btn-default" name="admin_submit">Submit</button>
	</form>
</div>
