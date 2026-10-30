<div class="block-title">{{ lang['lostpassword'] }}</div>
<form name="lostpassword" action="{{ form_action }}" method="post">
	<input type="hidden" name="type" value="send"/>
	{% for entry in entries %}
		<div class="label label-table">
			<label for="{{ entry.id }}">{{ entry.title }}:</label>
			<span class="input2">{{ entry.input }}</span>
			<div class="label-desc" id="{{ entry.id }}">{{ entry.descr }}</div>
		</div>
	{% endfor %}
	{{ captcha_widget|raw }}
	<div class="clearfix"></div>
	<div class="label">
		<input type="submit" value="{{ lang['send_pass'] }}" class="button"/>
	</div>
</form>
