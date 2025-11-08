<tr>
	<td colspan="2">
		<fieldset class="admGroup">
			<legend class="title">
				{{ title|raw }}
				{% if toggle %}[<a href="#" data-toggle="admin-group">{{ lang['group.toggle']|default('Свернуть/развернуть') }}</a>]{% endif %}
			</legend>
			<div class="admin-group-content" {% if toggle %} style="display:{{ toggle_mode }};" {% endif %}>
				<table class="table table-sm">
					<tbody>
						{{ entries|raw }}
					</tbody>
				</table>
			</div>
		</fieldset>
	</td>
</tr>
