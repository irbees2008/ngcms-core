<div class="block-title">{{ lang['lostpassword'] }}</div>
<form name="lostpassword" action="{{ form_action }}" method="post">
	<input type="hidden" name="type" value="send"/>
	{{ entries }}
	{{ captcha_widget|raw }}
	<div class="clearfix"></div>
	<div class="label">
		<input type="submit" value="{{ lang['send_pass'] }}" class="button"/>
	</div>
</form>
