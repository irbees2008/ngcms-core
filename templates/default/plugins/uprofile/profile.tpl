<script type="text/javascript">
	document.ready = function () {
		var sizelimit = {{ info_sizelimit }};
		if (sizelimit <= 0) {
			document.getElementById('sizelimit_text').style.display = "none";
		}
	}
	function validate_form() {
		var f = document.getElementById('profileForm');
		// Email
		var email = f.editmail.value;
		if ((email.length > 0) && (!emailCheck(email))) {
			alert("{{ lang.uprofile['wrong_email'] }}");
			return false;
		}
		// About
		var about = f.editabout.value;
		if (({{ info_sizelimit }} > 0) &&
		(about.length > {{ info_sizelimit }})
	)
		{
			alert("{{ info_sizelimit_text }}");
			return false;
		}
		return true;
	}
</script>
<div class="block-title">{{ lang.uprofile['profile_of'] }}</div>
<form id="profileForm" method="post" action="{{ form_action }}" enctype="multipart/form-data">
	<input type="hidden" name="token" value="{{ token }}"/>
	<div class="label label-table">
		<label>{{ lang.uprofile['email'] }}:</label>
		<input type="text" name="editmail" value="{{ user.email }}" class="input"/>
	</div>
	<div class="label label-table">
		<label>{{ lang.uprofile['from'] }}:</label>
		<input type="text" name="editfrom" value="{{ user.from }}" class="input"/>
	</div>
	<div class="label label-table">
		<label>{{ lang.uprofile['about'] }}: </label>
		<textarea style="height: 60px;" name="editabout" class="textarea">{{ user.info }}</textarea>
		{% if (info_sizelimit > 0) %}
			<div class="label-desc" id="sizelimit_text">{{ lang.uprofile['sizelimit_min'] }}
			{about_sizelimit} {{ lang.uprofile['characters'] }}</div>{% endif %}
	</div>
	<div class="label label-table">
		<label>{{ lang.uprofile['new_pass'] }}:</label>
		<input type="password" name="editpassword" class="input"/>
	</div>
	<div class="label label-table">
		<label>{{ lang.uprofile['oldpass'] }}:</label>
		<input type="password" name="oldpass" value="" class="input"/>
		<div class="label-desc">{{ lang.uprofile['oldpass#desc'] }}</div>
	</div>
	{% if (flags.avatarAllowed) %}
		<div class="label label-table">
			<label>{{ lang.uprofile['avatar'] }}:</label>
			<div class="input-fileform">
				<div class="fileformlabel"></div>
				<div class="selectbutton">{{ lang.uprofile['upload_file'] }}</div>
				<input type="file" name="newavatar" class="upload"/>
			</div>
			{% if (user.flags.hasAvatar) %}
				<img src="{{ user.avatar }}" style="margin: 5px; border: 0px; max-width: 80px; max-height: 80px;" alt=""/>
				<br/>
				<input type="checkbox" name="delavatar" id="delavatar"/>&nbsp;{{ lang.uprofile['delete'] }}
			{% endif %}
		</div>
	{% else %}
		<div class="label label-table">
			<label>{{ lang.uprofile['avatar'] }}:</label>
			{{ lang.uprofile['avatars_denied'] }}
		</div>
	{% endif %}
	{% if pluginIsActive('xfields') %}{{ plugin_xfields_0 }}{% endif %}
	<div class="clearfix"></div>
	<div class="label">
		<input type="submit" onclick="return validate_form();" value="{{ lang.uprofile['save'] }}" class="button">
	</div>
</form>