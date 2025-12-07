<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item">
				<a href="{{ php_self }}?mod=users">{{ lang['users_title'] }}</a>
			</li>
			<li class="breadcrumb-item active" aria-current="page">{{ lang['profile_of'] }}
				[{{ name }}]</li>
		</ol>
		<h4>{{ lang['profile_of'] }}
			[{{ name }}]</h4>
	</div>
</div>
<!-- end page title -->
<form action="{{ php_self }}?mod=users" method="post" enctype="multipart/form-data">
	<input type="hidden" name="token" value="{{ token }}"/>
	<input type="hidden" name="action" value="edit"/>
	<input type="hidden" name="id" value="{{ id }}"/>
	<div
		class="row">
		<!-- Left edit column -->
		<div
			class="col-lg-8">
			<!-- MAIN CONTENT -->
			<div id="maincontent" class="x_panel mb-4">
				<div class="x_content">
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['groupName'] }}</label>
						<select name="status" class="form-select">
							{{ status }}
						</select>
					</div>
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['new_pass'] }}</label>
						<input type="text" name="password" class="form-control"/>
						<small class="form-text text-muted">{{ lang['pass_left'] }}</small>
					</div>
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['email'] }}</label>
						<input type="email" name="mail" value="{{ mail }}" class="form-control"/>
					</div>
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['from'] }}</label>
						<input type="text" name="where_from" value="{{ where_from }}" class="form-control" maxlength="60"/>
					</div>
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['about'] }}</label>
						<textarea name="info" class="form-control" rows="7" cols="60">{{ info }}</textarea>
					</div>
					{# Аватар пользователя #}
					<div class="form-row mb-3">
						<label class="col-form-label">{{ lang['avatar'] }}</label>
						<div class="mb-2">
							<img src="{{ avatar|default(skins_url ~ '/images/default-avatar.jpg') }}" alt="avatar" style="max-width: 80px; max-height: 80px;" class="rounded"/>
						</div>
						{% if pluginIsActive('uprofile') and flags.avatarAllowed %}
							<input type="file" name="newavatar" class="form-control" accept="image/*"/>
							<small class="form-text text-muted">{{ avatar_hint }}</small>
							{% if flags.hasAvatar %}
								<div class="mt-2 d-flex align-items-center">
									<div class="form-check mb-0">
										<input class="form-check-input" type="checkbox" name="delavatar" id="delavatar" value="1"/>
										<label class="form-check-label" for="delavatar">{{ lang['delete_avatar'] }}</label>
									</div>
								</div>
							{% endif %}
						{% else %}
							<small class="form-text text-muted">{{ lang['avatars_plugin_disabled']|default('Плагин профиля отключён или аватары запрещены') }}</small>
						{% endif %}
						{% if not flags.avatarAllowed %}
							<small class="form-text text-muted">{{ lang['avatars_disabled'] }}</small>
						{% endif %}
					</div>
				</div>
			</div>
		</div>
		<!-- Right edit column -->
		<div id="rightBar" class="col col-lg-4">
			<div class="x_panel mb-4">
				<div class="x_content">
					<ul class="list-unstyled mb-0">
						<li>{{ lang['regdate'] }}:
							<b>{{ regdate }}</b>
						</li>
						<li>{{ lang['last_login'] }}:
							<b>{{ last }}</b>
						</li>
						<li>{{ lang['last_ip'] }}:
							<b>{{ ip }}</b>
							<a href="http://www.nic.ru/whois/?ip={{ ip }}" title="{{ lang['whois'] }}">{{ lang['whois'] }}</a>
						</li>
						<li>{{ lang['all_news'] }}:
							<b>{{ news }}</b>
						</li>
						<li>{{ lang['all_comments'] }}:
							<b>{{ com }}</b>
						</li>
					</ul>
				</div>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col col-lg-8">
			<div class="row">
				{% if (perm.modify) %}
					<div class="col-md-6 mb-4">
						<button type="button" class="btn btn-outline-dark" onclick="history.back();">
							{{ lang['cancel'] }}
						</button>
					</div>
					<div class="col-md-6 mb-4 text-right">
						<button type="submit" class="btn btn-outline-success">
							<span class="d-xl-none">
								<i class="fa fa-floppy-o"></i>
							</span>
							<span class="d-none d-xl-block">{{ lang['save'] }}</span>
						</button>
					</div>
				{% endif %}
			</div>
		</div>
	</div>
</form>
{% if (pluginIsActive('xfields')) %}
	<div class="row my-5">
		<div class="col-lg-8">
			<div class="x_panel">
				<div class="x_title">Доп. поля в профиле пользователя (только просмотр)</div>
				<table class="table table-sm">
					<thead>
						<tr>
							<th>ID поля</th>
							<th>Название поля</th>
							<th>Тип поля</th>
							<th>Блок</th>
							<!-- <th>V</th> -->
							<th>Значение</th>
						</tr>
					</thead>
					<tbody>
						{% for xFN,xfV in p.xfields.fields %}
							<tr>
								<td>{{ xFN }}</td>
								<td>{{ xfV.title }}</td>
								<td>{{ xfV.data.type }}</td>
								<td>{{ xfV.data.area }}</td>
								<!-- 	<td>{% if (xfV.data.type == "select") and (xfV.data.storekeys) %}<span style="font-color: red;"><b>{{ xfV.secure_value }}{% else %}&nbsp;{% endif %}</td> -->
								<td>{{ xfV.input }}</td>
							</tr>
						{% endfor %}
					</tbody>
				</table>
			</div>
		</div>
	</div>
{% endif %}
