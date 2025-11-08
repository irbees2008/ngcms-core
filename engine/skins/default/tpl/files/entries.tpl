<tr>
	<td>{{ id }}</td>
	<td nowrap>{{ file_link|raw }}</td>
	<td>{{ size }}</td>
	<td>{{ folder }}</td>
	<td>{{ user }}</td>
	<td nowrap>{{ insert_file|raw }}
		{{ rename|raw }}</td>
	<td><input type="checkbox" name="files[]" value="{{ id }}"/></td>
</tr>
