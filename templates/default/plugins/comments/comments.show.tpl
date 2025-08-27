<li id="comment{{ id }}">
	<div class="comment clearfix">
		<div class="comment-avatar">
			<div class="avatar">{{ avatar|raw }}</div>
		</div>
		<div class="comment-content">
			<div class="comment-name">
				{% if profile_link %}
					<a href="{{ profile_link }}" target="_blank" title="Профиль">{{ author }}</a>
				{% else %}
					{{ author }}
				{% endif %}
			</div>
			<div class="meta">
				{{ date }} |
				{% if config.use_bbcodes %}
					<a onclick="quote('{{ author }}');" style="cursor: pointer;">{{ lang['comments:form.reply'] }}</a>
				{% endif %}
				{% if can_edit or can_delete or can_admin_reply %}
					|
					{% if can_edit %}
						<a href="javascript:void(0);" onclick="edit_comment({{ id }}); return false;">{{ lang['comments:form.edit'] }}</a> |
					{% endif %}
					{% if can_delete %}
						<a href="javascript:void(0);" onclick="delete_comment({{ id }}, '{{ delete_token }}'); return false;">{{ lang['comments:form.delete'] }}</a>
					{% endif %}
				{% endif %}
			</div>
			<div class="comment-text" id="comment_text_{{ id }}">
				{{ text|raw }}
				{% if answer %}
					<br clear="all"/>--------------------<br/><i>{{ lang['comments:external.admin_answer'] }}</i> <b>{{ name }}</b><br/>{{ answer|raw }}
				{% endif %}
				{{ edit_info|raw }}
			</div>
		</div>
	</div>
</li>
