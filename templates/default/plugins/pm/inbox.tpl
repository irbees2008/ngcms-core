<div class="block-title">{{ lang['pm:inbox'] }}</div>
<form name="form" method="POST" action="{{ pm_del_link }}" style="display: inline;">
	<table class="table table-striped table-bordered">
		<tr>
			<th colspan="5">
				<a href="{{ pm_inbox_link }}">{{ lang['pm:inbox'] }}</a>
				|
				<a href="{{ pm_outbox_link }}">{{ lang['pm:outbox'] }}</a>
				|
				<a href="{{ pm_set_link }}" align="right">{{ lang['pm:set'] }}</a>
			</th>
		</tr>
		<tr>
			<td colspan="6" style="background: #f0f0f0; padding: 5px; text-align: center;">
				Лимит:
				{% if max_messages > 0 %}
					{{ max_messages }}
				{% else %}
					{{ lang['pm:not'] }}
				{% endif %}
				|
				{{ lang['pm:noti'] }}:
				{{ current_messages }}
			</td>
		</tr>
		<tr align="center">
			<td width="20%">{{ lang['pm:date'] }}</td>
			<td width="40%">{{ lang['pm:subject'] }}</td>
			<td width="25%">{{ lang['pm:from'] }}</td>
			<td width="10%">{{ lang['pm:state'] }}</td>
			<td width="10%" class="contentHead">{{ lang['pm:ava'] }}</td>
			<td width="5%">
				<input type="checkbox" name="master_box" title="{{ lang['pm:checkall'] }}" onclick="javascript:check_uncheck_all(form)">
			</td>
		</tr>
		{% for entry in entries %}
			<tr align="center">
				<td>{{ entry.pmdate|date('Y-m-d H:i') }}</td>
				<td>
					<a href="{{ entry.readURL }}">{{ entry.subject }}</a>
				</td>
				<td>{{ entry.link }}</td>
				<td>
					{% if (entry.viewed == 1) %}
						<img src="/engine/plugins/pm/img/viewed.yes.gif"/>
					{% else %}
						<img src="/engine/plugins/pm/img/viewed.no.gif"/>
					{% endif %}
				</td>
				<td class="contentEntry1">
					{% if entry.flags.hasAvatar %}
						<img src="{{ entry.avatar }}" alt="" style="max-width: 50px; max-height: 50px;"/>
					{% endif %}
				</td>
				<td><input name="selected_pm[]" value="{{ entry.pmid }}" type="checkbox"/></td>
			</tr>
		{% endfor %}
	</table>
	<div class="pagination" style="margin-top: 10px;">
		<ul>
			{{ pagination }}
		</ul>
	</div>
	<div class="clearfix"></div>
	<div class="label pull-right">
		<label class="default">&nbsp;</label>
		<input type="submit" class="button" value="{{ lang['pm:delete'] }}"/>
	</form>
	<form name="pm" method="POST" action="{{ pm_write_link }}" style="display: inline;">
		<input class="button" type="submit" value="{{ lang['pm:write'] }}">
	</form>
</div>
{# Notify toast on successful send #}
<script>
	document.addEventListener('DOMContentLoaded', function () {
try {
if ({{ sent|default(0) }}) {
if (window.showToast) {
window.showToast('{{ lang['pm:msgo_sent']|e('js') }}', {
type: 'success',
title: '{{ lang['pm:pm']|e('js') }}'
});
}
}
{% if delFlash %}
if (window.showToast) {
{% if delFlash.ok %}
window.showToast('{{ (lang['pm:msgo_deleted'] ?? 'Удалено')|e('js') }}', {
type: 'success',
title: '{{ (lang['pm:pm'] ?? 'Личные сообщения')|e('js') }}'
});
{% else %}
window.showToast('{{ (delFlash.message ?? (lang['pm:msge_bad_del'] ?? 'Ошибка удаления'))|e('js') }}', {
type: 'error',
title: '{{ (lang['pm:pm'] ?? 'Личные сообщения')|e('js') }}'
});{% endif %}
}
{% endif %}
} catch (e) { /* noop */
}
});
</script>
