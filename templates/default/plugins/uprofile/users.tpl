<div class="block-title">{{ lang.uprofile['profile_of'] }}
	{{ user.name }}
	{% if (user.flags.isOwnProfile) %}[
		<a href="{{ edit_profile }}">{{ lang.uprofile['edit_profile'] }}</a>
		]
	{% endif %}
</div>
<div class="block-user-info">
	<div class="avatar">
		<img src="{{ user.avatar }}" alt=""/>
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
