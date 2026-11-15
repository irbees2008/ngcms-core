<table class="table">
	<tr>
		<td>
			{{ lang['sqlite_backup_unavailable'] }}
			{% if config['auto_backup']|default('0') != '0' %}
				<br/><label for="sqlite_auto_backup">{{ lang['sqlite_backup_disable'] }}</label>
				<select id="sqlite_auto_backup" name="save_con[auto_backup]">
					<option value="1" selected>{{ lang['yesa'] }}</option>
					<option value="0">{{ lang['noa'] }}</option>
				</select>
			{% else %}
				<input type="hidden" name="save_con[auto_backup]" value="0"/>
			{% endif %}
			<input type="hidden" name="save_con[auto_backup_time]" value="{{ config['auto_backup_time']|default('')|e('html_attr') }}"/>
		</td>
	</tr>
</table>
