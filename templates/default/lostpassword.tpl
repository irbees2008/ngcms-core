<div class="block-title">{{ lang['lostpassword'] }}</div>
{{ entries }}
{% if flags.hasCaptcha %}
	<form name="lostpassword" action="{{ form_action }}" method="post">
		<input type="hidden" name="type" value="send" />
		{% if flags.hasCaptcha %}
			<div class="label label-table captcha pull-left">
				<label>{{ lang['captcha'] }}:</label>
				<input type="text" name="vcode" class="input" />
				<img id="img_captcha" onclick="reload_captcha();" src="{{ captcha_source_url }}?force=1" alt="{{ lang['captcha'] }}" style="cursor: pointer;"/>
				<div class="label-desc">{{ lang['captcha_desc'] }}</div>
			</div>
		{% endif %}
		<div class="clearfix"></div>
		<div class="label">
			<input type="submit" value="{{ lang['send_pass'] }}" class="button" />
		</div>
	</form>
{% endif %}
<script type="text/javascript">
function reload_captcha() {
    var captcha = document.getElementById('img_captcha');
    if (captcha) {
        captcha.src = "{{ captcha_source_url }}?force=1&t=" + Date.now();
    }
}
</script>
