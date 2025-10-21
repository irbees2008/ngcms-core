<form method="POST" action="{{ delURL }}">
	<div class="block-title">{{ subject }}
		{% if (ifinbox) %}от
		{% endif %}
		{% if not (ifinbox) %}для
		{% endif %}
		{{ author }}
		{% if flags.hasAvatar %}
			<img src="{{ avatar }}" alt="" style="max-width: 50px; max-height: 50px;"/>
		{% endif %}
		{{ pmdate|date('Y-m-d H:i') }}</div>
	<table class="table table-striped table-bordered">
		<tr>
			<th>
				<a href="{{ pm_inbox_link }}">{{ lang['pm:inbox'] }}</a>
				|
				<a href="{{ pm_outbox_link }}">{{ lang['pm:outbox'] }}</a>
				|
				<a href="{{ pm_set_link }}" align="right">{{ lang['pm:set'] }}</a>
			</th>
		</tr>
		<tr>
			<td width="100%">
				<blockquote>{{ content }}</blockquote>
			</td>
		</tr>
	</table>
	<div class="clearfix"></div>
	<div class="label pull-right">
		<label class="default">&nbsp;</label>
		<input class="button" type="submit" value="{{ lang['pm:delete_one'] }}">
	</form>
	{% if (ifinbox == 1) %}
		<form name="pm" method="POST" action="{{ replyURL }}" style="display: inline;">
			<input class="button" type="submit" value="{{ lang['pm:reply'] }}">
		</form>
	{% endif %}
</div>
