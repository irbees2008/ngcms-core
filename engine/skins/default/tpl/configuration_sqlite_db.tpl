<tr>
	<td width="50%">{{ lang['dbtype'] }}</td>
	<td width="50%">
		SQLite
		<input type="hidden" name="save_con[dbtype]" id="db_dbtype" value="sqlite"/>
		<input type="hidden" name="save_con[dbhost]" value="{{ config['dbhost']|default('')|e('html_attr') }}"/>
		<input type="hidden" name="save_con[dbname]" value="{{ config['dbname']|default('')|e('html_attr') }}"/>
		<input type="hidden" name="save_con[dbuser]" value="{{ config['dbuser']|default('')|e('html_attr') }}"/>
		<input type="hidden" name="save_con[dbpasswd]" value="{{ config['dbpasswd']|default('')|e('html_attr') }}"/>
	</td>
</tr>
<tr>
	<td width="50%">{{ lang['dbpath'] }}<br/><small>{{ lang['dbpath_readonly'] }}</small></td>
	<td width="50%"><input id="db_dbpath" type="text" name="save_con[dbpath]" value="{{ config['dbpath']|default(config['dbname']|default(''))|e('html_attr') }}" class="form-control" readonly/></td>
</tr>
