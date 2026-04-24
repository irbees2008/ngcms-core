<!-- start page title -->
<div class="row mb-2">
	<div class="col-12">
		<ol class="breadcrumb m-0">
			<li class="breadcrumb-item">
				<a href="admin.php">
					<i class="fa fa-home"></i>
				</a>
			</li>
			<li class="breadcrumb-item active">{{ lang['configuration_title'] }}</li>
		</ol>
		<h4>{{ lang['configuration_title'] }}</h4>
	</div>
</div>
<!-- end page title -->
<div class="x_panel">
	<form action="{{ php_self }}" method="post">
		<input type="hidden" name="token" value="{{ token }}"/>
		<input type="hidden" name="mod" value="configuration"/>
		<input type="hidden" name="subaction" value="save"/>
		<input type="hidden" name="save" value=""/>
		<input id="selectedOption" type="hidden" name="selectedOption"/>
		<ul class="nav nav-pills bg-nav-pills mb-3">
			<li class="nav-item">
				<a href="#userTabs-db" class="nav-link rounded-0 active" data-bs-toggle="tab" aria-expanded="false">{{ lang['db'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-security" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['security'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-system" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="true">{{ lang['syst'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-news" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['sn'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-users" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['users'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-imgfiles" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['files'] }}/{{ lang['img'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-cache" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['cache'] }}</a>
			</li>
			<li class="nav-item">
				<a href="#userTabs-multi" class="nav-link rounded-0" data-bs-toggle="tab" aria-expanded="false">{{ lang['multi'] }}</a>
			</li>
		</ul>
		<div
			id="userTabs" class="tab-content">
			<!-- ########################## DB TAB ########################## -->
			<div
				id="userTabs-db" class="tab-pane active">
				<!-- TABLE DB//Connection -->
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['db_connect'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbtype'] }}
							<small class="form-text text-muted">{{ lang['example'] }}pdo</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[dbtype]', 'value' : config['dbtype'], 'id' : 'db_dbtype', 'values' : { 'pdo' : lang['pdo'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbhost'] }}
							<small class="form-text text-muted">{{ lang['example'] }}localhost</small>
						</td>
						<td width="50%">
							<input id="db_dbhost" type="text" name="save_con[dbhost]" value="{{ config['dbhost'] }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbname'] }}
							<small class="form-text text-muted">{{ lang['example'] }}ng</small>
						</td>
						<td width="50%">
							<input id="db_dbname" type="text" name='save_con[dbname]' value='{{ config['dbname'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbuser'] }}
							<small class="form-text text-muted">{{ lang['example'] }}root</small>
						</td>
						<td width="50%">
							<input id="db_dbuser" type="text" name='save_con[dbuser]' value='{{ config['dbuser'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbpass'] }}
							<small class="form-text text-muted">{{ lang['example'] }}password</small>
						</td>
						<td width="50%">
							<input id="db_dbpasswd" type="password" name='save_con[dbpasswd]' value='{{ config['dbpasswd'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['dbprefix'] }}
							<small class="form-text text-muted">{{ lang['example'] }}ng</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[prefix]' value='{{ config['prefix'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">&nbsp;</td>
						<td width="50%">
							<button type="button" onclick="ngCheckDB();" class="btn btn-outline-primary">{{ lang['btn_checkDB'] }}</button>
						</td>
					</tr>
				</table>
				<!-- END: TABLE DB//Connection -->
				<!-- TABLE DB//Backup -->
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['db_backup'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['auto_backup'] }}
							<small class="form-text text-muted">{{ lang['auto_backup_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[auto_backup]', 'value' : config['auto_backup'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['auto_backup_time'] }}
							<small class="form-text text-muted">{{ lang['auto_backup_time_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[auto_backup_time]' value='{{ config['auto_backup_time'] }}' class="form-control" maxlength="5"/>
						</td>
					</tr>
				</table>
				<!-- END: TABLE DB//Backup -->
			</div>
			<!-- ########################## SECURITY TAB ########################## -->
			<div id="userTabs-security" class="tab-pane">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['logging'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['x_ng_headers'] }}
							<small class="form-text text-muted">{{ lang['x_ng_headers#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[x_ng_headers]', 'value' : config['x_ng_headers'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['syslog'] }}
							<small class="form-text text-muted">{{ lang['syslog_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[syslog]', 'value' : config['syslog'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['load'] }}
							<small class="form-text text-muted">{{ lang['load_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[load_analytics]', 'value' : config['load_analytics'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['load_profiler'] }}
							<small class="form-text text-muted">{{ lang['load_profiler_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name="save_con[load_profiler]" value="{{ config['load_profiler'] }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['security'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['flood_time'] }}
							<small class="form-text text-muted">{{ lang['flood_time_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[flood_time]' value='{{ config['flood_time'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_captcha'] }}
							<small class="form-text text-muted">{{ lang['use_captcha_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_captcha]', 'value' : config['use_captcha'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['captcha_font'] }}
							<small class="form-text text-muted">{{ lang['captcha_font_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[captcha_font]', 'value' : config['captcha_font'], 'values' : list['captcha_font'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_cookies'] }}
							<small class="form-text text-muted">{{ lang['use_cookies_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_cookies]', 'value' : config['use_cookies'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_sessions'] }}
							<small class="form-text text-muted">{{ lang['use_sessions_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_sessions]', 'value' : config['use_sessions'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['sql_error'] }}
							<small class="form-text text-muted">{{ lang['sql_error_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[sql_error_show]', 'value' : config['sql_error_show'], 'values' : { 0 : lang['sql_error_0'], 1 : lang['sql_error_1'], 2 : lang['sql_error_2'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['multiext_files'] }}
							<small class="form-text text-muted">{{ lang['multiext_files_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[allow_multiext]', 'value' : config['allow_multiext'] }) }}
						</td>
					</tr>
				</table>
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['debug_generate'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['debug'] }}
							<small class="form-text text-muted">{{ lang['debug_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[debug]', 'value' : config['debug'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['debug_queries'] }}
							<small class="form-text text-muted">{{ lang['debug_queries_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[debug_queries]', 'value' : config['debug_queries'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['debug_profiler'] }}
							<small class="form-text text-muted">{{ lang['debug_profiler_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[debug_profiler]', 'value' : config['debug_profiler'] }) }}
						</td>
					</tr>
				</table>
			</div>
			<!-- ########################## SYSTEM TAB ########################## -->
			<div id="userTabs-system" class="tab-pane show">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['syst'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['home_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[home_url]' value='{{ config['home_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['admin_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com/engine</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[admin_url]' value='{{ config['admin_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['home_title'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								NGCNS</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[home_title]' value="{{ config['home_title']|escape }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['admin_mail'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								admin@server.com</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[admin_mail]' value='{{ config['admin_mail'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['lock'] }}
							<small class="form-text text-muted">{{ lang['lock_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[lock]', 'value' : config['lock'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['lock_reason'] }}
							<small class="form-text text-muted">{{ lang['lock_reason_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[lock_reason]' value='{{ config['lock_reason'] }}' maxlength="200" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['meta'] }}
							<small class="form-text text-muted">{{ lang['meta_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[meta]', 'value' : config['meta'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['description'] }}
							<small class="form-text text-muted">{{ lang['description_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name="save_con[description]" value="{{ config['description'] }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['keywords'] }}
							<small class="form-text text-muted">{{ lang['keywords_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name="save_con[keywords]" value="{{ config['keywords'] }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['theme'] }}
							<small class="form-text text-muted">{{ lang['theme_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[theme]', 'value' : config['theme'], 'values' : list['theme'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['admin_skin'] }}
							<small class="form-text text-muted">{{ lang['admin_skin_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[admin_skin]', 'value' : config['admin_skin']|default('default'), 'values' : list['admin_skin'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['lang'] }}
							<small class="form-text text-muted">{{ lang['lang_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[default_lang]', 'value' : config['default_lang'], 'values' : list['default_lang'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_gzip'] }}
							<small class="form-text text-muted">{{ lang['use_gzip_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_gzip]', 'value' : config['use_gzip'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['404_mode'] }}
							<small class="form-text text-muted">{{ lang['404_mode_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[404_mode]', 'value' : config['404_mode'], 'values' : { 0 : lang['404.int'], 1 : lang['404.ext'], 2 : lang['404.http'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['libcompat'] }}
							<small class="form-text text-muted">{{ lang['libcompat_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[libcompat]', 'value' : config['libcompat'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">
							{{ lang['url_external_nofollow'] }}
							<small class="form-text text-muted">{{ lang['url_external_nofollow_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[url_external_nofollow]', 'value' : config['url_external_nofollow'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['url_external_target_blank'] }}
							<small class="form-text text-muted">{{ lang['url_external_target_blank_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[url_external_target_blank]', 'value' : config['url_external_target_blank'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['timezone'] }}
							<small class="form-text text-muted">{{ lang['timezone#desc'] }}</small>
						</td>
						<td width="50%">
							<select id="timezone" name="save_con[timezone]" class="form-select">
								{% for zone in list['timezoneList'] %}
									<option value="{{ zone }}" {% if (config['timezone'] == zone) %} selected {% endif %}>{{ zone }}</option>
								{% endfor %}
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['email_configuration'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['mailfrom_name'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								Administrator</small>
						</td>
						<td width="50%">
							<input id="mail_fromname" type="text" name='save_con[mailfrom_name]' value='{{ config['mailfrom_name'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['mailfrom'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								mailbot@server.com</small>
						</td>
						<td width="50%">
							<input id="mail_frommail" type="text" name='save_con[mailfrom]' value='{{ config['mailfrom'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['mail_mode'] }}:
							<small class="form-text text-muted">{{ lang['mail_mode#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[mail_mode]', 'id' : 'mail_mode', 'value' : config['mail_mode'], 'values' : { 'mail' : 'mail', 'sendmail' : 'sendmail', 'smtp' : 'smtp' } }) }}
						</td>
					</tr>
					<tr class="useSMTP">
						<td colspan="2" class="h3 font-weight-light">{{ lang['smtp_config'] }}</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_host'] }}:
							<small class="form-text text-muted">{{ lang['example'] }}
								smtp.mail.ru</small>
						</td>
						<td width="50%">
							<input id="mail_smtp_host" type="text" name="save_con[mail][smtp][host]" value="{{ config['mail']['smtp']['host'] }}" class="form-control"/>
						</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_port'] }}:
							<small class="form-text text-muted">{{ lang['example'] }}
								25</small>
						</td>
						<td width="50%">
							<input id="mail_smtp_port" type="text" name="save_con[mail][smtp][port]" value="{{ config['mail']['smtp']['port'] }}" class="form-control"/>
						</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_auth'] }}:
							<small class="form-text text-muted">{{ lang['smtp_auth#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[mail][smtp][auth]', 'id' : 'mail_smtp_auth', 'value' : config['mail']['smtp']['auth'] }) }}
						</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_secure'] }}:
							<small class="form-text text-muted">{{ lang['smtp_secure#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[mail][smtp][secure]', 'id' : 'mail_smtp_secure', 'value' : config['mail']['smtp']['secure'], 'values' : { '' : 'None', 'tls' : 'TLS', 'ssl' : 'SSL' } }) }}
						</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_auth_login'] }}:
							<small class="form-text text-muted">{{ lang['example'] }}
								email@mail.ru</small>
						</td>
						<td width="50%">
							<input id="mail_smtp_login" type="text" name="save_con[mail][smtp][login]" value="{{ config['mail']['smtp']['login'] }}" class="form-control"/>
						</td>
					</tr>
					<tr class="useSMTP">
						<td width="50%">{{ lang['smtp_auth_pass'] }}:
							<small class="form-text text-muted">{{ lang['example'] }}
								mySuperPassword</small>
						</td>
						<td width="50%">
							<input id="mail_smtp_pass" type="text" name="save_con[mail][smtp][pass]" value="{{ config['mail']['smtp']['pass'] }}" class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%"></td>
						<td width="50%">
							<div class="form-group row">
								<label class="col-sm-4 col-form-label">EMail:</label>
								<div class="col-sm-8">
									<input id="mail_tomail" type="text" name="" value="" class="form-control"/>
								</div>
							</div>
							<div class="form-group row">
								<div class="col-sm-8 offset-sm-4">
									<button type="button" class="btn btn-block btn-outline-primary" onclick="ngCheckEmail(); return false;">{{ lang['btn_checkSMTP'] }}</button>
								</div>
							</div>
						</td>
					</tr>
				</table>
			</div>
			<!-- ########################## NEWS TAB ########################## -->
			<div id="userTabs-news" class="tab-pane">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['sn'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['number'] }}</td>
						<td width="50%">
							<input type="text" name='save_con[number]' value='{{ config['number'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['news_multicat_url'] }}
							<small class="form-text text-muted">{{ lang['news_multicat_url#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[news_multicat_url]', 'value' : config['news_multicat_url'], 'values' : { 0 : lang['news_multicat:0'], 1 : lang['news_multicat:1'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['nnavigations'] }}
							<small class="form-text text-muted">{{ lang['nnavigations_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[newsNavigationsCount]' value='{{ config['newsNavigationsCount'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['nnavigations_admin'] }}
							<small class="form-text text-muted">{{ lang['nnavigations_admin_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[newsNavigationsAdminCount]' value='{{ config['newsNavigationsAdminCount'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['category_counters'] }}
							<small class="form-text text-muted">{{ lang['category_counters_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[category_counters]', 'value' : config['category_counters'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['news_view_counters'] }}
							<small class="form-text text-muted">{{ lang['news_view_counters#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[news_view_counters]', 'value' : config['news_view_counters'], 'values' : {1: lang['yesa'], 0: lang['noa'], 2: lang['news_view_counters#2'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['news.edit.split'] }}
							<small class="form-text text-muted">{{ lang['news.edit.split#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[news.edit.split]', 'value' : config['news.edit.split'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['news_without_content'] }}
							<small class="form-text text-muted">{{ lang['news_without_content_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[news_without_content]', 'value' : config['news_without_content'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['date_adjust'] }}
							<small class="form-text text-muted">{{ lang['date_adjust_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[date_adjust]' value='{{ config['date_adjust'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['timestamp_active'] }}
							<small class="form-text text-muted">{{ lang['date_help'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[timestamp_active]' value='{{ config['timestamp_active'] }}' class="form-control"/>
							<small class="form-text text-muted">{{ lang['date_now'] }}
								{{ timestamp_active_now }}</small>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['timestamp_updated'] }}
							<small class="form-text text-muted">{{ lang['date_help'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[timestamp_updated]' value='{{ config['timestamp_updated'] }}' class="form-control"/>
							<small class="form-text text-muted">{{ lang['date_now'] }}
								{{ timestamp_updated_now }}</small>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['smilies'] }}
							<small class="form-text text-muted">{{ lang['smilies_desc'] }}
								(<b>,</b>)</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[smilies]' value='{{ config['smilies'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['blocks_for_reg'] }}
							<small class="form-text text-muted">{{ lang['blocks_for_reg_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[blocks_for_reg]', 'value' : config['blocks_for_reg'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['extended_more'] }}
							<small class="form-text text-muted">{{ lang['extended_more_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[extended_more]', 'value' : config['extended_more'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_smilies'] }}
							<small class="form-text text-muted">{{ lang['use_smilies_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_smilies]', 'value' : config['use_smilies'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_bbcodes'] }}
							<small class="form-text text-muted">{{ lang['use_bbcodes_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_bbcodes]', 'value' : config['use_bbcodes'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_htmlformatter'] }}
							<small class="form-text text-muted">{{ lang['use_htmlformatter_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_htmlformatter]', 'value' : config['use_htmlformatter'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['default_newsorder'] }}
							<small class="form-text text-muted">{{ lang['default_newsorder_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[default_newsorder]', 'value' : config['default_newsorder'], 'values' : { 'id desc' : lang['order_id_desc'], 'id asc' : lang['order_id_asc'], 'postdate desc' : lang['order_postdate_desc'], 'postdate asc' : lang['order_postdate_asc'], 'title desc' : lang['order_title_desc'], 'title asc' : lang['order_title_asc'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['template_mode'] }}
							<small class="form-text text-muted">{{ lang['template_mode#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[template_mode]', 'value' : config['template_mode'], 'values' : { 1 : lang['template_mode.1'], 2 : lang['template_mode.2'] } }) }}
						</td>
					</tr>
				</table>
			</div>
			<!-- ########################## USERS TAB ########################## -->
			<div
				id="userTabs-users" class="tab-pane">
				<!-- TABLE AUTH -->
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['auth'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['remember'] }}
							<small class="form-text text-muted">{{ lang['remember_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[remember]', 'value' : config['remember'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['auth_module'] }}
							<small class="form-text text-muted">{{ lang['auth_module_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[auth_module]', 'value' : config['auth_module'], 'values' : list['auth_module'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['auth_db'] }}
							<small class="form-text text-muted">{{ lang['auth_db_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[auth_db]', 'value' : config['auth_db'], 'values' : list['auth_db'] }) }}
						</td>
					</tr>
				</table>
				<!-- END: TABLE AUTH -->
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['users'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['users_selfregister'] }}
							<small class="form-text text-muted">{{ lang['users_selfregister_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[users_selfregister]', 'value' : config['users_selfregister'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['register_type'] }}
							<small class="form-text text-muted">{{ lang['register_type_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[register_type]', 'value' : config['register_type'], 'values' : { 0 : lang['register_extremly'], 1 : lang['register_simple'], 2 : lang['register_activation'], 3 : lang['register_manual'], 4 : lang['register_manual_confirm']  } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['user_aboutsize'] }}
							<small class="form-text text-muted">{{ lang['user_aboutsize_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[user_aboutsize]' value='{{ config['user_aboutsize'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['users.avatars'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['use_avatars'] }}
							<small class="form-text text-muted">{{ lang['use_avatars_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[use_avatars]', 'value' : config['use_avatars'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['avatars_gravatar'] }}
							<small class="form-text text-muted">{{ lang['avatars_gravatar_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectYN({'name' : 'save_con[avatars_gravatar]', 'value' : config['avatars_gravatar'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['avatars_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com/uploads/avatars</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[avatars_url]' value='{{ config['avatars_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['avatars_dir'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								/home/servercom/public_html/uploads/avatars/</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[avatars_dir]' value='{{ config['avatars_dir'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['avatar_wh'] }}
							<small class="form-text text-muted">{{ lang['avatar_wh_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[avatar_wh]' value='{{ config['avatar_wh'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['avatar_max_size'] }}
							<small class="form-text text-muted">{{ lang['avatar_max_size_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[avatar_max_size]' value='{{ config['avatar_max_size'] }}' class="form-control"/>
						</td>
					</tr>
				</table>
			</div>
			<!-- ########################## IMAGES TAB ########################## -->
			<div id="userTabs-imgfiles" class="tab-pane">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['files'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['files_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com/uploads/files</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[files_url]' value='{{ config['files_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['files_dir'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								/home/servercom/public_html/uploads/files/</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[files_dir]' value='{{ config['files_dir'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['attach_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com/uploads/dsn</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[attach_url]' value='{{ config['attach_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['attach_dir'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								/home/servercom/public_html/uploads/dsn/</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[attach_dir]' value='{{ config['attach_dir'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['files_ext'] }}
							<small class="form-text text-muted">{{ lang['files_ext_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[files_ext]' value='{{ config['files_ext'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['files_max_size'] }}
							<small class="form-text text-muted">{{ lang['files_max_size_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[files_max_size]' value='{{ config['files_max_size'] }}' class="form-control"/>
						</td>
					</tr>
				</table>
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['img'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_url'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								http://server.com/uploads/images</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[images_url]' value='{{ config['images_url'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_dir'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								/home/servercom/public_html/uploads/images/</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[images_dir]' value='{{ config['images_dir'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_ext'] }}
							<small class="form-text text-muted">{{ lang['images_ext_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[images_ext]' value='{{ config['images_ext'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_max_size'] }}
							<small class="form-text text-muted">{{ lang['images_max_size_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[images_max_size]' value='{{ config['images_max_size'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_dim_action'] }}
							<small class="form-text text-muted">{{ lang['images_dim_action#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[images_dim_action]', 'value' : config['images_dim_action'], 'values' : { 0 : lang['images_dim_action#0'], 1 : lang['images_dim_action#1'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['images_max_dim'] }}
							<small class="form-text text-muted">{{ lang['images_max_dim#desc'] }}</small>
						</td>
						<td width="50%">
							<div class="input-group mb-3">
								<input type="text" name='save_con[images_max_x]' value='{{ config['images_max_x'] }}' class="form-control"/>
								<label class="input-group-text">x</label>
								<input type="text" name='save_con[images_max_y]' value='{{ config['images_max_y'] }}' class="form-control"/>
							</div>
						</td>
					</tr>
					<!-- IMAGE transform control -->
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['img.thumb'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['thumb_size'] }}
							<small class="form-text text-muted">{{ lang['thumb_size_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="input-group mb-3">
								<input type="text" name='save_con[thumb_size_x]' value='{{ config['thumb_size_x'] }}' class="form-control"/>
								<label class="input-group-text">x</label>
								<input type="text" name='save_con[thumb_size_y]' value='{{ config['thumb_size_y'] }}' class="form-control"/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['thumb_quality'] }}
							<small class="form-text text-muted">{{ lang['thumb_quality_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="d-flex align-items-center">
								<input type="range" name='save_con[thumb_quality]' id="thumb_quality_range" value='{{ config['thumb_quality'] }}' class="custom-range flex-grow-1 mr-3" min="0" max="100" oninput="document.getElementById('thumb_quality_value').value = this.value + '%';"/>
								<input type="text" id="thumb_quality_value" value='{{ config['thumb_quality'] }}%' class="form-control text-center" style="width: 70px;" readonly/>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['img.stamp'] }}</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['stamp_mode'] }}
							<small class="form-text text-muted">{{ lang['stamp_mode_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[stamp_mode]', 'value' : config['stamp_mode'], 'values' : { 0 : lang['mode_demand'], 1 : lang['mode_forbid'], 2 : lang['mode_always'] } }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['stamp_place'] }}
							<small class="form-text text-muted">{{ lang['stamp_place_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[stamp_place]', 'value' : config['stamp_place'], 'values' : { 0 : lang['mode_orig'], 1 : lang['mode_copy'], 2 : lang['mode_origcopy'] } }) }}
						</td>
					</tr>
					<!-- TEXT WATERMARK SETTINGS -->
					<tr>
						<td width="50%">{{ lang['wm_text'] }}
							<small class="form-text text-muted">{{ lang['wm_text_desc'] }}</small>
						</td>
						<td width="50%">
							<input type="text" name='save_con[wm_text]' value='{{ config['wm_text'] }}' class="form-control" placeholder="MySite.ru"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_font'] }}
							<small class="form-text text-muted">{{ lang['wm_font_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[wm_font]', 'value' : config['wm_font'], 'values' : list['wm_font'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_font_size'] }}
							<small class="form-text text-muted">{{ lang['wm_font_size_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="d-flex align-items-center">
								<input type="range" name='save_con[wm_font_size]' id="wm_font_size_range" value='{{ config['wm_font_size'] }}' class="custom-range flex-grow-1 mr-3" min="8" max="72" oninput="document.getElementById('wm_font_size_value').value = this.value; updateWatermarkPreview();" onchange="updateWatermarkPreview();"/>
								<input type="number" id="wm_font_size_value" value='{{ config['wm_font_size'] }}' class="form-control" min="8" max="72" style="width: 70px;" oninput="document.getElementById('wm_font_size_range').value = this.value; updateWatermarkPreview();" onchange="updateWatermarkPreview();" readonly/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_text_color'] }}
							<small class="form-text text-muted">{{ lang['wm_text_color_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="input-group">
								<input type="text" name='save_con[wm_text_color]' id="wm_text_color" value='{{ config['wm_text_color'] }}' class="form-control" placeholder="#FFFFFF"/>
								<div class="input-group-append">
									<input type="color" id="wm_text_color_picker" value='{{ config['wm_text_color'] }}' class="form-control" style="max-width: 50px; cursor: pointer;" title="Выбрать цвет"/>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_text_opacity'] }}
							<small class="form-text text-muted">{{ lang['wm_text_opacity_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="d-flex align-items-center">
								<input type="range" name='save_con[wm_text_opacity]' id="wm_text_opacity_range" value='{{ config['wm_text_opacity'] }}' class="custom-range flex-grow-1 mr-3" min="0" max="100" oninput="document.getElementById('wm_text_opacity_value').value = this.value + '%'; updateWatermarkPreview();" onchange="updateWatermarkPreview();"/>
								<input type="text" id="wm_text_opacity_value" value='{{ config['wm_text_opacity'] }}%' class="form-control text-center" style="width: 70px;" readonly/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_bg_color'] }}
							<small class="form-text text-muted">{{ lang['wm_bg_color_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="input-group">
								<input type="text" name='save_con[wm_bg_color]' id="wm_bg_color" value='{{ config['wm_bg_color'] }}' class="form-control" placeholder="#000000"/>
								<div class="input-group-append">
									<input type="color" id="wm_bg_color_picker" value='{{ config['wm_bg_color'] }}' class="form-control" style="max-width: 50px; cursor: pointer;" title="Выбрать цвет"/>
								</div>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_bg_opacity'] }}
							<small class="form-text text-muted">{{ lang['wm_bg_opacity_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="d-flex align-items-center">
								<input type="range" name='save_con[wm_bg_opacity]' id="wm_bg_opacity_range" value='{{ config['wm_bg_opacity'] }}' class="custom-range flex-grow-1 mr-3" min="0" max="100" oninput="document.getElementById('wm_bg_opacity_value').value = this.value + '%'; updateWatermarkPreview();" onchange="updateWatermarkPreview();"/>
								<input type="text" id="wm_bg_opacity_value" value='{{ config['wm_bg_opacity'] }}%' class="form-control text-center" style="width: 70px;" readonly/>
							</div>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_position'] }}
							<small class="form-text text-muted">{{ lang['wm_position_desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelect({'name' : 'save_con[wm_position]', 'value' : config['wm_position'], 'values' : {
								'bottom_right' : lang['wm_position_bottom_right'],
								'bottom_left' : lang['wm_position_bottom_left'],
								'bottom_center' : lang['wm_position_bottom_center'],
								'top_right' : lang['wm_position_top_right'],
								'top_left' : lang['wm_position_top_left'],
								'top_center' : lang['wm_position_top_center'],
								'center' : lang['wm_position_center'],
								'center_left' : lang['wm_position_center_left'],
								'center_right' : lang['wm_position_center_right'],
								'tile' : lang['wm_position_tile']
							} }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['wm_tile_spacing'] }}
							<small class="form-text text-muted">{{ lang['wm_tile_spacing_desc'] }}</small>
						</td>
						<td width="50%">
							<div class="d-flex align-items-center">
								<input type="range" name='save_con[wm_tile_spacing]' id="wm_tile_spacing_range" value='{{ config['wm_tile_spacing'] }}' class="custom-range flex-grow-1 mr-3" min="50" max="500" step="10" oninput="document.getElementById('wm_tile_spacing_value').value = this.value + ' px'; updateWatermarkPreview();" onchange="updateWatermarkPreview();"/>
								<input type="text" id="wm_tile_spacing_value" value='{{ config['wm_tile_spacing'] }} px' class="form-control text-center" style="width: 80px;" readonly/>
							</div>
						</td>
					</tr>
					<!-- WATERMARK PREVIEW -->
					<tr>
						<td colspan="2">
							<div class="card">
								<div class="card-header">
									<h5 class="card-title mb-0">Предпросмотр водяного знака</h5>
								</div>
								<div class="card-body text-center">
									<canvas id="watermark_preview" width="600" height="400" style="border: 1px solid #ddd; max-width: 100%; height: auto;"></canvas>
								</div>
							</div>
						</td>
					</tr>
					<!-- END TEXT WATERMARK SETTINGS -->
					<!-- END: IMAGE transform control -->
				</table>
			</div>
			<!-- ########################## MULTI TAB ########################## -->
			<div id="userTabs-multi" class="tab-pane">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['multi_info'] }}</td>
					</tr>
					<tr>
						<td width="50%" valign="top">{{ lang['mydomains'] }}
							<small class="form-text text-muted">{{ lang['mydomains_desc'] }}</small>
						</td>
						<td width="50%">
							<textarea cols="45" rows="3" name="save_con[mydomains]" class="form-control">{{ config['mydomains'] }}</textarea>
						</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" class="h3 font-weight-light">{{ lang['multisite'] }}</td>
					</tr>
					<tr>
						<td colspan="2">
							<table class="table table-sm">
								<thead>
									<tr>
										<th>{{ lang['status'] }}</th>
										<th>{{ lang['title'] }}</th>
										<th>{{ lang['domains'] }}</th>
										<th>{{ lang['flags'] }}</th>
									</tr>
								</thead>
								<tbody>
									{% for MR in multiConfig %}
										<tr>
											<td>
												{% if (MR['active']) %}On{% else %}Off
												{% endif %}
											</td>
											<td>{{ MR['key'] }}</td>
											<td>
												{% for domain in MR['domains'] %}
													{{ domain }}
													{% else %}-
													{{ lang['not_specified'] }}
													-
												{% endfor %}
											</td>
											<td>&nbsp;</td>
										</tr>
									{% else %}
										<tr>
											<td colspan="4">-
												{{ lang['not_used'] }}
												-</td>
										</tr>
									{% endfor %}
								</tbody>
							</table>
						</td>
					</tr>
				</table>
			</div>
			<!-- ########################## CACHE TAB ########################## -->
			<div id="userTabs-cache" class="tab-pane">
				<table class="table table-sm">
					<tr>
						<td colspan="2" class="h3 font-weight-light">Memcached</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['memcached_enabled'] }}
							<small class="form-text text-muted">{{ lang['memcached_enabled#desc'] }}</small>
						</td>
						<td width="50%" class="ng-select">
							{{ mkSelectNY({'name' : 'save_con[use_memcached]', 'value' : config['use_memcached'] }) }}
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['memcached_ip'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								localhost</small>
						</td>
						<td width="50%">
							<input id="memcached_ip" type="text" name='save_con[memcached_ip]' value='{{ config['memcached_ip'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['memcached_port'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								11211</small>
						</td>
						<td width="50%">
							<input id="memcached_port" type="text" name='save_con[memcached_port]' value='{{ config['memcached_port'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">{{ lang['memcached_prefix'] }}
							<small class="form-text text-muted">{{ lang['example'] }}
								ng</small>
						</td>
						<td width="50%">
							<input id="memcached_prefix" type="text" name='save_con[memcached_prefix]' value='{{ config['memcached_prefix'] }}' class="form-control"/>
						</td>
					</tr>
					<tr>
						<td width="50%">&nbsp;</td>
						<td width="50%">
							<input type="button" value="{{ lang['btn_checkMemcached'] }}" class="btn btn-outline-primary" onclick="ngCheckMemcached(); return false;"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="form-group my-3 text-center">
			<button type="submit" class="btn btn-outline-success">{{ lang['save'] }}</button>
		</div>
	</form>
</div>
 <script type="text/javascript">
	$("#mail_mode").on('change', toggleSmtp).trigger('change');
	function toggleSmtp(event) {
	$(".useSMTP").toggle("smtp" === $("#mail_mode option:selected").val());
	}
	// Check DB connection
	function ngCheckDB() {
	post('admin.configuration.dbCheck', {
	'token': '{{ token }}',
	'dbtype': $("#db_dbtype").val(),
	'dbhost': $("#db_dbhost").val(),
	'dbname': $("#db_dbname").val(),
	'dbuser': $("#db_dbuser").val(),
	'dbpasswd': $("#db_dbpasswd").val()
	});
	}
	// Check MEMCached connection
	function ngCheckMemcached() {
	post('admin.configuration.memcachedCheck', {
	'token': '{{ token }}',
	'ip': $("#memcached_ip").val(),
	'port': $("#memcached_port").val(),
	'prefix': $("#memcached_prefix").val()
	});
	}
	// Send test e-mail message
	function ngCheckEmail() {
	post('admin.configuration.emailCheck', {
	'token': '{{ token }}',
	'mode': $("#mail_mode").val(),
	'from': {
	'name': $("#mail_fromname").val(),
	'email': $("#mail_frommail").val()
	},
	'to': {
	'email': $("#mail_tomail").val()
	},
	'smtp': {
	'host': $("#mail_smtp_host").val(),
	'port': $("#mail_smtp_port").val(),
	'auth': $("#mail_smtp_auth").val(),
	'login': $("#mail_smtp_login").val(),
	'pass': $("#mail_smtp_pass").val(),
	'secure': $("#mail_smtp_secure").val()
	}
	});
	}
	// Color picker synchronization for watermark settings
	$(document).ready(function() {
		// Initialize color pickers with current values
		function initColorPicker() {
			var textColor = $('#wm_text_color').val() || '#FFFFFF';
			var bgColor = $('#wm_bg_color').val() || '#000000';
			if (/^#[0-9A-F]{6}$/i.test(textColor)) {
				$('#wm_text_color_picker').val(textColor);
			}
			if (/^#[0-9A-F]{6}$/i.test(bgColor)) {
				$('#wm_bg_color_picker').val(bgColor);
			}
		}
		initColorPicker();
		// Text color: click on text field opens color picker
		$('#wm_text_color').on('click focus', function() {
			$('#wm_text_color_picker').trigger('click');
		});
		// Text color picker - sync to text field
		$('#wm_text_color_picker').on('input change', function() {
			$('#wm_text_color').val($(this).val().toUpperCase());
			updateWatermarkPreview();
		});
		// Text field - sync to color picker
		$('#wm_text_color').on('input change keyup', function() {
			var color = $(this).val();
			if (/^#[0-9A-F]{6}$/i.test(color)) {
				$('#wm_text_color_picker').val(color);
			}
			updateWatermarkPreview();
		});
		// Background color: click on text field opens color picker
		$('#wm_bg_color').on('click focus', function() {
			$('#wm_bg_color_picker').trigger('click');
		});
		// Background color picker - sync to text field
		$('#wm_bg_color_picker').on('input change', function() {
			$('#wm_bg_color').val($(this).val().toUpperCase());
			updateWatermarkPreview();
		});
		// Background field - sync to color picker
		$('#wm_bg_color').on('input change keyup', function() {
			var color = $(this).val();
			if (/^#[0-9A-F]{6}$/i.test(color)) {
				$('#wm_bg_color_picker').val(color);
			}
			updateWatermarkPreview();
		});
		// Watermark preview functionality
		function updateWatermarkPreview() {
			var canvas = document.getElementById('watermark_preview');
			if (!canvas || !canvas.getContext) return;
			var ctx = canvas.getContext('2d');
			var width = canvas.width;
			var height = canvas.height;
			// Clear canvas
			ctx.clearRect(0, 0, width, height);
			// Draw background pattern (simulating an image)
			var gradient = ctx.createLinearGradient(0, 0, width, height);
			gradient.addColorStop(0, '#87CEEB');
			gradient.addColorStop(1, '#4682B4');
			ctx.fillStyle = gradient;
			ctx.fillRect(0, 0, width, height);
			// Add some pattern to simulate photo
			ctx.fillStyle = 'rgba(255, 255, 255, 0.1)';
			for (var i = 0; i < 20; i++) {
				ctx.beginPath();
				ctx.arc(Math.random() * width, Math.random() * height, Math.random() * 30, 0, Math.PI * 2);
				ctx.fill();
			}
			// Get watermark settings
			var text = $('input[name="save_con[wm_text]"]').val() || 'MySite.ru';
			var fontSize = parseInt($('input[name="save_con[wm_font_size]"]').val()) || 24;
			var fontFile = $('select[name="save_con[wm_font]"]').val() || 'arial.ttf';
			var textColor = $('#wm_text_color').val() || '#FFFFFF';
			var textOpacity = parseInt($('input[name="save_con[wm_text_opacity]"]').val()) || 50;
			var bgColor = $('#wm_bg_color').val() || '#000000';
			var bgOpacity = parseInt($('input[name="save_con[wm_bg_opacity]"]').val()) || 30;
			var position = $('select[name="save_con[wm_position]"]').val() || 'bottom_right';
			var tileSpacing = parseInt($('input[name="save_con[wm_tile_spacing]"]').val()) || 150;
			// Convert hex color to rgba
			function hexToRgba(hex, opacity) {
				var r = parseInt(hex.slice(1, 3), 16);
				var g = parseInt(hex.slice(3, 5), 16);
				var b = parseInt(hex.slice(5, 7), 16);
				return 'rgba(' + r + ',' + g + ',' + b + ',' + (opacity / 100) + ')';
			}
			// DEBUG: Check available fonts
			console.log('=== WATERMARK FONT DEBUG START ===');
			console.log('1. Selected font file:', fontFile);
			console.log('2. Font size:', fontSize);
			// Get font file name from select
			var fontFile = $('select[name="save_con[wm_font]"]').val() || 'arial';
			console.log('1. Selected font file:', fontFile);
			console.log('2. Font size:', fontSize);
			// Create dynamic font family name from filename
			// Example: 'Xtrusion.ttf' -> 'WM_Xtrusion', 'Solo5' -> 'WM_Solo5'
			var cleanName = fontFile.replace('.ttf', '').replace(/[^a-zA-Z0-9]/g, '_');
			var fontFamily = 'WM_' + cleanName;
			console.log('3. Generated font family:', fontFamily);
			// Build font path
			var fontPath = '../engine/trash/' + (fontFile.indexOf('.ttf') === -1 ? fontFile + '.ttf' : fontFile);
			console.log('4. Font path:', fontPath);
			// Load font dynamically if not loaded yet
			if (document.fonts && fontFile !== 'arial' && fontFile !== 'arial.ttf') {
				try {
					// Check if font already loaded
					var fontLoaded = false;
					document.fonts.forEach(function(font) {
						if (font.family === fontFamily) {
							fontLoaded = true;
						}
					});
					if (!fontLoaded) {
						console.log('5. Loading new font:', fontFamily, 'from', fontPath);
						// Create @font-face dynamically
						var fontFace = new FontFace(fontFamily, 'url(' + fontPath + ')');
						fontFace.load().then(function(loadedFont) {
							document.fonts.add(loadedFont);
							console.log('6. Font loaded successfully:', fontFamily);
							// Redraw with loaded font
							updateWatermarkPreview();
						}).catch(function(error) {
							console.error('6. Font loading failed:', fontFamily, error);
							// Use Arial as fallback
							fontFamily = 'Arial';
						});
					} else {
						console.log('5. Font already loaded:', fontFamily);
					}
				} catch(e) {
					console.error('5. Error loading font:', e);
					fontFamily = 'Arial';
				}
			} else {
				console.log('5. Using system font: Arial');
				fontFamily = 'Arial';
			}
			// Set font string for canvas
			var fontString = fontSize + 'px "' + fontFamily + '"';
			console.log('7. Final font string:', fontString);
			ctx.font = fontString;
			console.log('8. Canvas font after setting:', ctx.font);
			// Check document.fonts API
			if (document.fonts) {
				console.log('9. document.fonts.size:', document.fonts.size);
				// List all loaded fonts
				var loadedFonts = [];
				document.fonts.forEach(function(font) {
					loadedFonts.push(font.family);
				});
				console.log('10. All loaded fonts:', loadedFonts);
			} else {
				console.warn('9. document.fonts NOT available');
			}
			console.log('=== WATERMARK FONT DEBUG END ===');
			var textMetrics = ctx.measureText(text);
			var textWidth = textMetrics.width;
			var textHeight = fontSize;
			// Add padding
			var padding = 10;
			var boxWidth = textWidth + padding * 2;
			var boxHeight = textHeight + padding * 2;
			// Function to draw watermark at specific position
			var drawCallCount = 0;
			function drawWatermark(x, y) {
				drawCallCount++;
				if (drawCallCount === 1) {
					console.log('=== DRAW WATERMARK DEBUG ===');
					console.log('11. Font for drawing:', fontString);
				}
				// Ensure font is set (canvas state can reset)
				ctx.font = fontString;
				// Draw background rectangle
				ctx.fillStyle = hexToRgba(bgColor, bgOpacity);
				ctx.fillRect(x, y, boxWidth, boxHeight);
				// Draw text
				ctx.fillStyle = hexToRgba(textColor, textOpacity);
				ctx.textBaseline = 'top';
				ctx.fillText(text, x + padding, y + padding);
			}
			// Draw based on position
			if (position === 'tile') {
				// Draw tiled watermarks
				for (var y = 0; y < height; y += tileSpacing) {
					for (var x = 0; x < width; x += tileSpacing) {
						drawWatermark(x, y);
					}
				}
			} else {
				// Calculate single position
				var x = 0, y = 0;
				var margin = 20;
				switch (position) {
					case 'top_left':
						x = margin;
						y = margin;
						break;
					case 'top_center':
						x = (width - boxWidth) / 2;
						y = margin;
						break;
					case 'top_right':
						x = width - boxWidth - margin;
						y = margin;
						break;
					case 'center_left':
						x = margin;
						y = (height - boxHeight) / 2;
						break;
					case 'center':
						x = (width - boxWidth) / 2;
						y = (height - boxHeight) / 2;
						break;
					case 'center_right':
						x = width - boxWidth - margin;
						y = (height - boxHeight) / 2;
						break;
					case 'bottom_left':
						x = margin;
						y = height - boxHeight - margin;
						break;
					case 'bottom_center':
						x = (width - boxWidth) / 2;
						y = height - boxHeight - margin;
						break;
					case 'bottom_right':
					default:
						x = width - boxWidth - margin;
						y = height - boxHeight - margin;
						break;
				}
				drawWatermark(x, y);
			}
		}
		// Update preview on any watermark setting change
		$('input[name="save_con[wm_text]"]').on('input change keyup', updateWatermarkPreview);
		$('select[name="save_con[wm_font]"]').on('change', updateWatermarkPreview);
		$('input[name="save_con[wm_font_size]"]').on('input change', updateWatermarkPreview);
		$('input[name="save_con[wm_text_opacity]"]').on('input change', updateWatermarkPreview);
		$('input[name="save_con[wm_bg_opacity]"]').on('input change', updateWatermarkPreview);
		$('select[name="save_con[wm_position]"]').on('change', updateWatermarkPreview);
		$('input[name="save_con[wm_tile_spacing]"]').on('input change', updateWatermarkPreview);
		// Initial preview render
		updateWatermarkPreview();
	});
</script>
