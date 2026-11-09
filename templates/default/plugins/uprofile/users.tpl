<div class="block-title">{{ lang.uprofile['profile_of'] }}
	{{ user.name }}
	{% if (user.flags.isOwnProfile) %}[
		<a href="{{ edit_profile }}">{{ lang.uprofile['edit_profile'] }}</a>
		]
	{% endif %}
</div>
<div class="block-user-info">
	<div class="avatar">
		<img src="{{ avatarUrl(user.avatar) }}" alt=""/>
		{% if not (global.user.status == 0) %}
			{% if pluginIsActive('pm') %}
				<a href="{{ user.write_pm_link }}">{{ lang.uprofile['write_pm'] }}</a>
			{% endif %}
		{% endif %}
	</div>
	<div class="user-info">
		<table class="table" cellspacing="0" cellpadding="0">
			<tr>
				<td>{{ lang.uprofile['user'] }}:</td>
				<td class="second">{{ user.name }}
					[id:
					{{ user.id }}]</td>
			</tr>
			<tr>
				<td>{{ lang.uprofile['status'] }}:</td>
				<td class="second">{{ user.status }}</td>
			</tr>
			<tr>
				<td>{{ lang.uprofile['regdate'] }}:</td>
				<td class="second">{{ user.reg }}</td>
			</tr>
			<tr>
				<td>{{ lang.uprofile['last'] }}:</td>
				<td class="second">{{ user.last }}</td>
			</tr>
			<tr>
				<td>{{ lang.uprofile['from'] }}:</td>
				<td class="second">{{ user.from }}</td>
			</tr>
			<tr>
				<td>{{ lang.uprofile['about'] }}:</td>
				<td class="second">{{ user.info }}</td>
			</tr>
			<tr>
				<td class="active">{{ lang.uprofile['del_profile'] }}:</td>
				<td>{{ user.del_profile }}</td>
			</tr>
			{% if user.deletion.is_pending %}
				<tr>
					<td colspan="2" style="background-color: #ffe6e6; padding: 10px; border: 1px solid #cc0000;">
						<strong style="color: #cc0000;">⚠️ Внимание!</strong><br>
						Ваш профиль будет удален через
						{{ user.deletion.days_remaining }}
						{{ user.deletion.days_remaining == 1 ? 'день' : (user.deletion.days_remaining < 5 ? 'дня' : 'дней') }}.<br>
						<a href="{{ user.deletion.cancel_link }}" style="color: #0066cc; font-weight: bold;">Отменить удаление профиля</a>
					</td>
				</tr>
			{% endif %}
		</table>
	</div>
</div>
<div class="block-title-mini">{{ lang.uprofile['contact_data'] }}</div>
<div class="block-title-mini">{{ lang.uprofile['activity_data'] }}</div>
<p>
	{{ lang.uprofile['all_news'] }}:
	{{ user.news }}<br>
	{{ lang.uprofile['all_comments'] }}:
	{{ user.com }}
</p>
