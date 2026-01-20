<!-- Page Header -->
<header class="intro-header" style="background-image: url('{tpl_url}/img/home-bg.jpg')">
	<div class="container">
		<div class="row justify-content-center">
			<div class="col-lg-8 col-md-10">
				<div class="post-heading">
					<h1>{{ lang['login.title'] }}</h1>
					<hr class="small">
				</div>
			</div>
		</div>
	</div>
</header>
<!-- Page Content -->
<div class="container">
	<div class="row justify-content-center">
		<div class="col-lg-8 col-md-10">
			<form name="login" method="post" action="{{ form_action }}">
				<input type="hidden" name="redirect" value="{{ redirect }}"/>
				<fieldset>
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{{ lang['login.username'] }}:</label>
							<input type="text" type="text" name="username" class="input"/>
					</div>
					<div class="form-group row">
						<label class="col-sm-4 col-form-label">{{ lang['login.password'] }}:</label>
							<input type="password" name="password" class="input"/>
					</div>
					<div class="form-group row">
						<div class="col-sm-4"></div>
						<div class="col-sm-4">
							<button type="submit" class="btn btn-success">{{ lang['login.submit'] }}</button>
						</div>
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</div>
{% if (flags.error) %}
	<div class="alert alert-error">{{ lang['login.error'] }}</div>
{% endif %}
{% if (flags.banned) %}
	<div class="alert alert-info">{{ lang['login.banned'] }}</div>
{% endif %}
{% if (flags.need_activate) %}
	<div class="alert alert-info">{{ lang['login.need_activate'] }}</div>
{% endif %}
