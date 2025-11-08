<tr>
	<td width="50%">
		{{ title|raw }}
		{% if descr %}
			<small class="form-text text-muted">{{ descr|raw }}</small>
		{% endif %}
	</td>
	<td width="50%">
		{{ input|raw }}
		{{ error|raw }}
	</td>
</tr>
