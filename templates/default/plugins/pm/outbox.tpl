<form name="form" method="POST" action="{{ pm_del_link }}">
	<div class="block-title">{{ lang['pm:outbox'] }}</div>
	<table class="table table-striped table-bordered">
		<tr>
			<th colspan="4">
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
				{{ lang['pm:notiout'] }}:
				{{ current_messages }}
			</td>
		</tr>
		<tr align="center">
			<td width="25%">{{ lang['pm:date'] }}</td>
			<td width="40%">{{ lang['pm:subject'] }}</td>
			<td width="30%">{{ lang['pm:too'] }}</td>
			<td width="15%" class="contentHead">{{ lang['pm:ava'] }}</td>
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
	</div>
</form>
{# notify.css/js подключены глобально в templates/default/main.tpl #}
<script>
	document.addEventListener('DOMContentLoaded', function () {
try {
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
