<!DOCTYPE html>
<html lang="{{ lang['langcode'] }}">
	<head>
		<meta charset="{{ lang['encoding'] }}"/>
		<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=no"/>
		<title>{{ home_title }}
			-
			{{ lang['admin_panel'] }}</title>
		<link href="{{ skins_url }}/public/css/app.css" rel="stylesheet"/>
	 <script src="{{ skins_url }}/public/js/manifest.js" type="text/javascript"></script>
		 <script src="{{ skins_url }}/public/js/vendor.js" type="text/javascript"></script>
		 <script src="{{ skins_url }}/public/js/app.js" type="text/javascript"></script>
		 <script src="{{ skins_url }}/public/js/notify.js" type="text/javascript"></script>
		 <script type="text/javascript">
							// Переопределяем глобальную post(), чтобы уважать флаг notify (тихий режим) и исключить двойные уведомления
				window.post = function (methodName, params, notify) {
				var n = (arguments.length < 3 || typeof notify === 'undefined') ? true : !! notify;
				var token = $('input[name="token"]').val();
				return $.ajax({
				method: 'POST',
				url: NGCMS.admin_url + '/rpc.php',
				dataType: 'json',
				headers: {
				'X-CSRF-TOKEN': token,
				'X-Requested-With': 'XMLHttpRequest'
				},
				data: {
				json: 1,
				token: token,
				methodName: methodName,
				params: JSON.stringify(params || {})
				},
				beforeSend: function () {
				if (typeof window.ngShowLoading === 'function')
				window.ngShowLoading();
				}
				}).then(function (resp) {
				if (! resp || ! resp.status) {
				var ex = {
				message: 'Error [' + (
				resp && resp.errorCode
				) + ']: ' + (
				resp && resp.errorText
				),
				response: resp
				};
				return $.Deferred().reject(ex).promise();
				}
				return resp;
				}).done(function (resp) {
				if (n && typeof window.ngNotifySticker === 'function') {
				window.ngNotifySticker(resp.errorText, {
				className: 'alert-success',
				closeBTN: true
				});
				}
				return resp;
				}).fail(function (err) {
				if (n && typeof window.ngNotifySticker === 'function') {
				var fallbackMsg = (window.NGCMS && NGCMS.lang && NGCMS.lang.rpc_httpError) || 'Request error';
				window.ngNotifySticker(err.message || fallbackMsg, {
				className: 'alert-danger',
				closeBTN: true
				});
				}
				}).always(function () {
				if (typeof window.ngHideLoading === 'function')
				window.ngHideLoading();
				});
				};
						</script>
	</head>
	<body>
		<div id="loading-layer" style="display:none">
			<div class="loading-content">
				<span class="spinner" aria-hidden="true"></span>
				<span>{{ lang['loading'] }}</span>
			</div>
		</div>
		<nav class="navbar navbar-dark sticky-top bg-dark flex-md-nowrap p-0 shadow">
			<a href="{{ php_self }}" class="navbar-brand col-md-3 col-lg-2 mr-0 px-3 admin">
				<i class="fa fa-cogs"></i>
				{{ lang['admin_panel'] }}</a>
			<button class="navbar-toggler position-absolute d-md-none collapsed" type="button" data-toggle="collapse" data-target="#menu-content" aria-controls="sidebarMenu" aria-expanded="false" aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>
			<!-- Часы реального времени -->
			<div id="site-clock" class="text-white mx-3 d-none d-md-block" style="font-size: 14px; white-space: nowrap;">
				<i class="fa fa-clock-o"></i>
				<span id="clock-display">Загрузка...</span>
			</div>
			<div class="btn-group ml-auto mr-2 py-1" role="group" aria-label="Button group with nested dropdown">
				<ul class="navbar-nav ml-auto">
					<li
						class="nav-item nav-badge-item">
						<!-- Иконка уведомлений -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#notificationsModal" title="{{ lang['notifications']|default('Уведомления') }}" data-bs-toggle="tooltip" data-bs-placement="bottom">
							<i class="fa fa-bell-o fa-lg"></i>
							<span class="badge badge-notife badge-danger">{{ unnAppLabel }}</span>
						</a>
					</li>
					{% if perm.cache %}
						<li
							class="nav-item">
							<!-- Очистка кэша (браузер + сервер) -->
							<a type="button" class="nav-link" id="btn-clear-cache" title="{{ lang['cache.clean']|default('Очистить кеш') }}" data-bs-toggle="tooltip" data-bs-placement="bottom">
								<i class="fa fa-refresh fa-lg"></i>
							</a>
						</li>
					{% endif %}
					<li
						class="nav-item">
						<!-- Иконка добавления контента -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#addContentModal" title="{{ lang['content.add']|default('Добавить контент') }}" data-bs-toggle="tooltip" data-bs-placement="bottom">
							<i class="fa fa-plus fa-lg"></i>
						</a>
					</li>
					<li class="nav-item nav-badge-item">
						<a type="button" class="nav-link" data-toggle="modal" data-target="#quickLinksModal" title="Часто открываемое" aria-label="Часто открываемое" data-bs-toggle="tooltip" data-bs-placement="bottom">
							<i class="fa fa-star-o fa-lg"></i>
							<span id="quick-links-badge" class="badge badge-notife badge-danger">0</span>
						</a>
					</li>
					<li
						class="nav-item">
						<!-- Иконка профиля пользователя -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#userProfileModal" title="{{ lang['user.profile']|default('Профиль пользователя') }}" data-bs-toggle="tooltip" data-bs-placement="bottom">
							<i class="fa fa-user-o fa-lg"></i>
						</a>
					</li>
				</ul>
			</div>
		</nav>
		<div class="container-fluid">
			<div class="row">
				<div class="nav-side-menu">
					<div class="menu-list">
						<ul id="menu-content" class="menu-content collapse out">
							<li>
								<a href="{{ home }}" target="_blank">
									<i class="fa fa-external-link"></i>
									{{ lang['mainpage'] }}</a>
							</li>
							{%
								set showContent = global.mod == 'news'
									or global.mod == 'categories'
									or global.mod == 'static'
									or global.mod == 'images'
									or global.mod == 'files'
							%}
							<li data-toggle="collapse" data-target="#nav-content" class="collapsed {{ h_active_options ? 'active' : '' }} ">
								<a href="#">
									<i class="fa fa-newspaper-o"></i>
									{{ lang['news_a'] }}
									<span class="arrow"></span>
								</a>
							</li>
							<ul class="sub-menu collapse {{ showContent ? 'show' : ''}}" id="nav-content">
								{% if (perm.editnews) %}
									<li>
										<a href="{{ php_self }}?mod=news">{{ lang['news.edit'] }}</a>
									</li>
								{% endif %}
								{% if (perm.categories) %}
									<li>
										<a href="{{ php_self }}?mod=categories">{{ lang['news.categories'] }}</a>
									</li>
								{% endif %}
								{% if (perm.static) %}
									<li>
										<a href="{{ php_self }}?mod=static">{{ lang['static'] }}</a>
									</li>
								{% endif %}
								{% if (perm.addnews) %}
									<li>
										<a href="{{ php_self }}?mod=news&action=add">{{ lang['news.add'] }}</a>
									</li>
								{% endif %}
								<li>
									<a href="{{ php_self }}?mod=images">{{ lang['images'] }}</a>
								</li>
								<li>
									<a href="{{ php_self }}?mod=files">{{ lang['files'] }}</a>
								</li>
								{% if comments_moderation_enabled and pluginIsActive('comments') %}
									<li>
										<a href="{{ php_self }}?plugin=comments&handler=moderation">Модерация комментариев</a>
									</li>
								{% endif %}
							</ul>
							{%
								set showUsers = global.mod == 'users'
									or global.mod == 'ipban'
									or global.mod == 'ugroup'
									or global.mod == 'perm'
							%}
							<li data-toggle="collapse" data-target="#nav-users" class="collapsed {{ h_active_userman ? 'active' : '' }}">
								<a href="#">
									<i class="fa fa-users"></i>
									{{ lang['userman'] }}
									<span class="arrow"></span>
								</a>
							</li>
							<ul class="sub-menu collapse {{ showUsers ? 'show' : '' }}" id="nav-users">
								{% if (perm.users) %}
									<li>
										<a href="{{ php_self }}?mod=users">{{ lang['users'] }}</a>
									</li>
								{% endif %}
								{% if (perm.ipban) %}
									<li>
										<a href="{{ php_self }}?mod=ipban">{{ lang['ipban_m'] }}</a>
									</li>
								{% endif %}
								<li>
									<a href="{{ php_self }}?mod=ugroup">{{ lang['ugroup'] }}</a>
								</li>
								<li>
									<a href="{{ php_self }}?mod=perm">{{ lang['uperm'] }}</a>
								</li>
							</ul>
							{%
								set showService = global.mod == 'configuration'
									or global.mod == 'dbo'
									or global.mod == 'rewrite'
									or global.mod == 'cron'
									or global.mod == 'statistics'
							%}
							<li data-toggle="collapse" data-target="#nav-service" class="collapsed {{ h_active_system ? 'active' : '' }}">
								<a href="#">
									<i class="fa fa-cog"></i>
									{{ lang['system'] }}
									<span class="arrow"></span>
								</a>
							</li>
							<ul class="sub-menu collapse {{ showService ? 'show' : '' }}" id="nav-service">
								{% if (perm.configuration) %}
									<li>
										<a href="{{ php_self }}?mod=configuration">{{ lang['configuration'] }}</a>
									</li>
								{% endif %}
								{% if (perm.dbo) %}
									<li>
										<a href="{{ php_self }}?mod=dbo">{{ lang['options_database'] }}</a>
									</li>
								{% endif %}
								{% if (perm.rewrite) %}
									<li>
										<a href="{{ php_self }}?mod=rewrite">{{ lang['rewrite'] }}</a>
									</li>
								{% endif %}
								{% if (perm.cron) %}
									<li>
										<a href="{{ php_self }}?mod=cron">{{ lang['cron_m'] }}</a>
									</li>
								{% endif %}
								<li>
									<a href="{{ php_self }}?mod=statistics">{{ lang['statistics'] }}
									</a>
								</li>
							</ul>
							<li class="{{ h_active_extras ? 'active' : '' }} ">
								<a href="{{ php_self }}?mod=extras">
									<i class="fa fa-puzzle-piece"></i>
									{{ lang['extras'] }}</a>
							</li>
							{% if (perm.templates) %}
								<li class="{{ h_active_templates ? 'active' : '' }} ">
									<a href="{{ php_self }}?mod=templates">
										<i class="fa fa-th-large"></i>
										{{ lang['templates_m'] }}</a>
								</li>
							{% endif %}
							<hr>
							<li>
								<a href="{{ php_self }}?mod=docs">
									<i class="fa fa-book" aria-hidden="true"></i>
									Документация</a>
							</li>
							<li>
								<a href="https://forum.ngcms.org" target="_blank">
									<i class="fa fa-comments-o" aria-hidden="true"></i>
									Форум поддержки</a>
							</li>
							<li>
								<a href="https://ngcms.org/" target="_blank">
									<i class="fa fa-globe fa-lg"></i>
									Официальный сайт</a>
							</li>
							<li>
								<a href="https://github.com/irbees2008/ngcms-core" target="_blank">
									<i class="fa fa-github"></i>
									Github</a>
							</li>
						</ul>
					</div>
				</div>
				<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 my-4">
					{{ notify }}
					{{ main_admin }}
				</main>
			</div>
			<footer class="border-top mt-5">
				<p class="text-right text-muted py-4 my-0">2008-{{ year }}
					©
					<a href="http://ngcms.org" target="_blank">Next Generation CMS</a>
				</p>
			</footer>
		</div>
		<!-- Модальное окно для уведомлений -->
		<div class="modal fade" id="notificationsModal" tabindex="-1" role="dialog" aria-labelledby="notificationsModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="notificationsModalLabel">Уведомления -
							{{ unnAppText }}</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						{{ unapproved1 }}
						{{ unapproved2 }}
						{{ unapproved3 }}
						<a class="dropdown-item" href="{{ php_self }}?mod=pm" title="{{ lang['pm_t'] }}">
							<i class="fa fa-envelope-o"></i>
							{{ newpmText }}
							{% if newpm > 0 %}
								<span class="badge badge-danger ml-2">{{ newpm }}</span>
							{% endif %}
						</a>
					</div>
				</div>
			</div>
		</div>
		<div class="modal fade" id="quickLinksModal" tabindex="-1" role="dialog" aria-labelledby="quickLinksModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="quickLinksModalLabel">Часто открываемое</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Закрыть">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<section id="quick-links" class="quick-links" data-user-id="{{ user.id }}">
							<div class="quick-links-heading">
								<span>Страницы админки</span>
								<span id="quick-links-count" class="quick-links-count">0/20</span>
								<button type="button" id="quick-links-toggle" class="quick-links-add-toggle" aria-label="Добавить страницу" title="Добавить страницу">
									<i class="fa fa-plus" aria-hidden="true"></i>
								</button>
							</div>
							<ul id="quick-links-list" class="quick-links-list" aria-live="polite"></ul>
							<form id="quick-links-form" class="quick-links-form" hidden>
								<label for="quick-links-title">Название</label>
								<input id="quick-links-title" type="text" maxlength="80" autocomplete="off" required>
								<label for="quick-links-url">Адрес админки</label>
								<input id="quick-links-url" type="text" autocomplete="url" required>
								<div class="quick-links-form-actions">
									<button type="submit" class="btn btn-sm btn-outline-primary">Добавить</button>
									<button type="button" id="quick-links-cancel" class="btn btn-sm btn-link">Отмена</button>
								</div>
								<div id="quick-links-message" class="quick-links-message" role="status"></div>
							</form>
						</section>
					</div>
				</div>
			</div>
		</div>
		<!-- Модальное окно для добавления контента -->
		<div class="modal fade" id="addContentModal" tabindex="-1" role="dialog" aria-labelledby="addContentModalLabel" aria-hidden="true">
			<div class="modal-dialog" role="document">
				<div class="modal-content">
					<div class="modal-header">
						<h5 class="modal-title" id="addContentModalLabel">Добавить контент</h5>
						<button type="button" class="close" data-dismiss="modal" aria-label="Close">
							<span aria-hidden="true">&times;</span>
						</button>
					</div>
					<div class="modal-body">
						<a class="btn btn-outline-success btn-custom" href="{{ php_self }}?mod=news&action=add">
							<i class="fa fa-newspaper-o" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_news'] }}
						</a>
						<a class="btn btn-outline-success btn-custom" href="{{ php_self }}?mod=categories&action=add">
							<i class="fa fa-list" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_cat'] }}
						</a>
						<a class="btn btn-outline-success btn-custom" href="{{ php_self }}?mod=static&action=addForm">
							<i class="fa fa-file-o" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_stat'] }}
						</a>
						<a class="btn btn-outline-success btn-custom add_form" href="{{ php_self }}?mod=users">
							<i class="fa fa-user-o" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_user'] }}
						</a>
						<a class="btn btn-outline-success btn-custom" href="{{ php_self }}?mod=images">
							<i class="fa fa-picture-o" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_images'] }}
						</a>
						<a class="btn btn-outline-success btn-custom" href="{{ php_self }}?mod=files">
							<i class="fa fa-folder-o" aria-hidden="true"></i>
							<i class="fa fa-plus"></i>
							{{ lang['head_add_files'] }}
						</a>
					</div>
				</div>
			</div>
		</div>
		<!-- Модальное окно для профиля пользователя -->
		<div class="modal fade" id="userProfileModal" tabindex="-1" role="dialog" aria-labelledby="userProfileModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-dialog-centered" role="document">
				<div class="modal-content">
					<div
						class="modal-body card card-widget widget-user">
						<!-- Add the bg color to the header using any of the bg-* classes -->
						<div class="widget-user-header bg-info text-right">
							<h3 class="widget-user-username">{{ user.name }}</h3>
							<h5 class="widget-user-desc">{{ skin_UStatus }}</h5>
						</div>
						<div class="widget-user-image">
							<img class="img-circle elevation-2" src="{{ skin_UAvatar }}" alt="User Avatar">
						</div>
						<div class="card-footer">
							<div class="row">
								<div class="col-sm-6 border-right">
									<div class="description-block">
										<a class="btn btn-block btn-outline-success btn-flat" href="?mod=users&action=editForm&id={{ user.id }}" title="{{ lang['loc_profile'] }}">
											<i class="fa fa-user-o"></i>
											{{ lang['loc_profile'] }}
										</a>
									</div>
									<!-- /.description-block -->
								</div>
								<!-- /.col -->
								<div class="col-sm-6">
									<div class="description-block">
										<a class="btn btn-block btn-outline-danger btn-flat" href="{{ php_self }}?action=logout" title="{{ lang['logout'] }}">
											<i class="fa fa-sign-out"></i>
											{{ lang['logout'] }}
										</a>
									</div>
									<!-- /.description-block -->
								</div>
								<!-- /.col -->
							</div>
							<!-- /.row -->
						</div>
						<!-- /.widget-user -->
					</div>
				</div>
			</div>
			 <script type="text/javascript">
										{% set encode_lang = lang | json_encode(constant('JSON_PRETTY_PRINT') b-or constant('JSON_UNESCAPED_UNICODE')) %}
						window.NGCMS = {
						admin_url: '{{ admin_url }}',
						home: '{{ home }}',
						lang: {{ encode_lang ?: '{}' }},
						langcode: '{{ lang['langcode'] }}',
						php_self: '{{ php_self }}',
						skins_url: '{{ skins_url }}'
						};
						(function () {
						var panel = document.getElementById('quick-links');
						if (!panel) return;
						var list = document.getElementById('quick-links-list');
						var count = document.getElementById('quick-links-count');
						var form = document.getElementById('quick-links-form');
						var titleInput = document.getElementById('quick-links-title');
						var urlInput = document.getElementById('quick-links-url');
						var message = document.getElementById('quick-links-message');
						var maxItems = 20;
						var storageKey = 'ngcms.quick-links.v1.' + panel.dataset.userId + '.' + location.host;
						var pendingKey = storageKey + '.pending';
						var visitThreshold = 10;
						var adminPath = '/engine';
						try { adminPath = new URL(NGCMS.admin_url || '/engine', location.origin).pathname.replace(/\/$/, ''); } catch (e) {}
						var items = [];
						function readItems() {
						try {
						var saved = JSON.parse(localStorage.getItem(storageKey) || '[]');
						return Array.isArray(saved) ? saved.filter(function (item) {
							return item && typeof item.url === 'string' && typeof item.title === 'string';
						}) : [];
						} catch (e) { return []; }
						}
						function saveItems() {
						try { localStorage.setItem(storageKey, JSON.stringify(items.slice(0, maxItems))); } catch (e) {}
						}
						function readPending() {
						try {
						var saved = JSON.parse(localStorage.getItem(pendingKey) || '{}');
						return saved && typeof saved === 'object' && !Array.isArray(saved) ? saved : {};
						} catch (e) { return {}; }
						}
						function savePending() {
						try {
						var recent = Object.keys(pending).sort(function (a, b) { return (pending[b].updated || 0) - (pending[a].updated || 0); }).slice(0, 100);
						var limited = {};
						recent.forEach(function (url) { limited[url] = pending[url]; });
						localStorage.setItem(pendingKey, JSON.stringify(limited));
						} catch (e) {}
						}
						function pageTitle() {
						var heading = document.querySelector('main h1, main h2, main .page-title');
						var headingText = heading && heading.textContent.trim();
						if (headingText) return headingText.slice(0, 80);
						var plugin = new URLSearchParams(location.search).get('plugin');
						if (plugin) return 'Плагин: ' + plugin;
						var activeLink = Array.prototype.find.call(document.querySelectorAll('.nav-side-menu a'), function (link) {
							try { return new URL(link.href).pathname === location.pathname && new URL(link.href).search === location.search; } catch (e) { return false; }
						});
						if (activeLink && activeLink.textContent.trim()) return activeLink.textContent.trim().slice(0, 80);
						return (document.title.split(/\s+-\s+/)[0] || location.pathname).slice(0, 80);
						}
						function render() {
						items.sort(function (a, b) { return (b.visits || 0) - (a.visits || 0) || (b.updated || 0) - (a.updated || 0); });
						list.textContent = '';
						items.forEach(function (item) {
						var row = document.createElement('li');
						var link = document.createElement('a');
						link.href = item.url;
						link.textContent = item.title;
						link.title = item.title + ' · посещений: ' + (item.visits || 0);
						var remove = document.createElement('button');
						remove.type = 'button';
						remove.className = 'quick-links-remove';
						remove.title = 'Удалить ссылку';
						remove.setAttribute('aria-label', 'Удалить ' + item.title);
						remove.innerHTML = '<i class="fa fa-times" aria-hidden="true"></i>';
						remove.addEventListener('click', function () {
							items = items.filter(function (entry) { return entry.url !== item.url; });
							saveItems(); render();
						});
						row.appendChild(link);
						row.appendChild(remove);
						list.appendChild(row);
						});
						count.textContent = items.length + '/' + maxItems;
						document.getElementById('quick-links-badge').textContent = items.length;
						}
						function toAdminUrl(value) {
						try {
						var url = new URL(value, location.origin);
						if (url.origin !== location.origin || !(url.pathname === adminPath || url.pathname.indexOf(adminPath + '/') === 0) || /\/rpc\.php$/i.test(url.pathname)) return '';
						return url.pathname + url.search + url.hash;
						} catch (e) { return ''; }
						}
						items = readItems();
						var pending = readPending();
						items = items.filter(function (item) {
							if (item.manual === false && (item.visits || 0) < visitThreshold) {
								var previous = pending[item.url] || {};
								pending[item.url] = { title: item.title, visits: Math.max(previous.visits || 0, item.visits || 0), updated: Math.max(previous.updated || 0, item.updated || 0) };
								return false;
							}
							return true;
						});
						var currentUrl = toAdminUrl(location.href);
						if (currentUrl && !/action=logout/.test(currentUrl)) {
						var current = items.find(function (item) { return item.url === currentUrl; });
						if (current) {
							current.visits = (current.visits || 0) + 1;
							current.updated = Date.now();
							delete pending[currentUrl];
						} else {
							var currentPending = pending[currentUrl] || { title: pageTitle(), visits: 0, updated: 0 };
							currentPending.title = pageTitle();
							currentPending.visits = (currentPending.visits || 0) + 1;
							currentPending.updated = Date.now();
							pending[currentUrl] = currentPending;
							if (currentPending.visits >= visitThreshold) {
								if (items.length >= maxItems) {
									var candidates = items.filter(function (item) { return item.manual === false; }).sort(function (a, b) { return (a.visits || 0) - (b.visits || 0) || (a.updated || 0) - (b.updated || 0); });
									if (candidates.length) items.splice(items.indexOf(candidates[0]), 1);
								}
								if (items.length < maxItems) {
									items.push({ url: currentUrl, title: currentPending.title, visits: currentPending.visits, updated: currentPending.updated, manual: false });
									delete pending[currentUrl];
								}
							}
						}
						}
						saveItems(); savePending(); render();
						document.getElementById('quick-links-toggle').addEventListener('click', function () {
							form.hidden = !form.hidden;
							if (!form.hidden) { titleInput.value = pageTitle(); urlInput.value = location.pathname + location.search + location.hash; message.textContent = ''; titleInput.focus(); }
						});
					document.getElementById('quick-links-cancel').addEventListener('click', function () { form.hidden = true; });
						form.addEventListener('submit', function (event) {
							event.preventDefault();
							var url = toAdminUrl(urlInput.value.trim());
							var title = titleInput.value.trim().slice(0, 80);
							if (!url || !title) { message.textContent = 'Укажите корректный адрес страницы админки и название.'; return; }
							var existing = items.find(function (item) { return item.url === url; });
							if (!existing && items.length >= maxItems) { message.textContent = 'Лимит 20 ссылок. Удалите одну, чтобы добавить новую.'; return; }
							if (existing) { existing.title = title; existing.manual = true; existing.updated = Date.now(); }
							else items.push({ url: url, title: title, visits: 0, updated: Date.now(), manual: true });
							delete pending[url];
							saveItems(); savePending(); render(); form.hidden = true;
						});
						})();
						$('#menu-content .sub-menu').on('show.bs.collapse', function () {
						$('#menu-content .sub-menu.show').not(this).removeClass('show');
						});
						// Очистка кэшей браузера: localStorage, sessionStorage, Cache Storage
						async function clearBrowserCaches() {
						try {
						try {
						window.localStorage && window.localStorage.clear();
						} catch (e) {}
						try {
						window.sessionStorage && window.sessionStorage.clear();
						} catch (e) {}
						if (window.caches && caches.keys) {
						const keys = await caches.keys();
						await Promise.all(keys.map((k) => caches.delete(k)));
						}
						return true;
						} catch (e) {
						return false;
						}
						}
						// Хендлер кнопки очистки кэша
						// Универсальный показ уведомлений: showToast -> $.notify -> ngNotifySticker -> alert
						function showNotify(message, type) { // 1) Предпочитаем наши тосты (vanilla, без зависимостей)
						try {
						if (typeof window.showToast === 'function') {
						var map = {
						danger: 'error',
						error: 'error',
						warning: 'warning',
						success: 'success',
						info: 'info'
						};
						var t = map[(type || 'info')] || 'info';
						var titles = {
						error: 'Ошибка',
						warning: 'Внимание',
						success: 'Готово',
						info: 'Info'
						};
						window.showToast(String(message), {
						type: t,
						title: titles[t] || '',
						sticked: t === 'error'
						});
						return;
						}
						} catch (e) {}
						// 2) Fallback на bootstrap-notify (если подключён)
						try {
						if (window.$ && typeof $.notify === 'function') {
						$.notify({
						message: String(message)
						}, {
						type: type || 'info'
						});
						return;
						}
						} catch (e) {}
						// 3) Fallback на старый ngNotifySticker
						try {
						if (typeof ngNotifySticker === 'function') {
						var cls = 'alert-' + (
						type || 'info'
						);
						ngNotifySticker(String(message), {
						className: cls,
						closeBTN: true
						});
						return;
						}
						} catch (e) {}
						// 4) Самый простой fallback
						try {
						alert(String(message));
						} catch (e) {}
						}
						async function handleTopbarClearCacheClick(ev) {
						ev && ev.preventDefault && ev.preventDefault();
						const browserOk = await clearBrowserCaches();
						// Вызов RPC admin.statistics.cleanCache
						try {
						const resp = await $.ajax({
						method: 'POST',
						url: NGCMS.admin_url + '/rpc.php',
						dataType: 'json',
						data: {
						json: 1,
						methodName: 'admin.statistics.cleanCache',
						params: JSON.stringify(
						{token: '{{ token_statistics|e('js') }}'}
						)
						}
						});
						if (resp && resp.status) {
						showNotify('{{ lang['notify.cache.server_ok']|e('js') }}', 'success');
						} else {
						showNotify('{{ lang['notify.cache.server_fail']|e('js') }}', 'danger');
						}
						} catch (e) {
						showNotify('{{ lang['notify.cache.server_fail']|e('js') }}', 'danger');
						}
						// Браузер
						if (browserOk) {
						showNotify('{{ lang['notify.cache.browser_ok']|e('js') }}', 'success');
						} else {
						showNotify('{{ lang['notify.cache.browser_fail']|e('js') }}', 'warning');
						}
						return false;
						}
						document.addEventListener('DOMContentLoaded', function () {
						var btn = document.getElementById('btn-clear-cache');
						if (btn) {
						btn.addEventListener('click', handleTopbarClearCacheClick);
						}
						// Инициализация Bootstrap tooltip
						if (typeof $.fn.tooltip !== 'undefined') {
						$('[data-bs-toggle="tooltip"]').tooltip();
						}

						// Инициализация часов реального времени (серверное время)
						var serverTime = new Date('{{ "now"|date('c') }}'); // Серверное время в ISO формате
						var clientTime = new Date();
						var timeDiff = serverTime - clientTime; // Разница между сервером и клиентом

						function updateClock() {
						var clockDisplay = document.getElementById('clock-display');
						if (!clockDisplay) return;

						var now = new Date(Date.now() + timeDiff); // Применяем серверную корректировку
						var months = ['января', 'февраля', 'марта', 'апреля', 'мая', 'июня',
						              'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря'];

						var day = now.getDate();
						var month = months[now.getMonth()];
						var year = now.getFullYear();
						var hours = String(now.getHours()).padStart(2, '0');
						var minutes = String(now.getMinutes()).padStart(2, '0');
						var seconds = String(now.getSeconds()).padStart(2, '0');

						var timeString = day + ' ' + month + ' ' + year + ' ' + hours + ':' + minutes + ':' + seconds;
						clockDisplay.textContent = timeString;
						}

						// Обновляем часы каждую секунду
						updateClock(); // Первое обновление сразу
						setInterval(updateClock, 1000);
						});
									</script>
			 <script>
										$(document).ready(function () { // Функция для определения ширины скроллбара
						function getScrollbarWidth() {
						var outer = document.createElement("div");
						outer.style.visibility = "hidden";
						outer.style.width = "100px";
						outer.style.msOverflowStyle = "scrollbar"; // needed for WinJS apps
						document.body.appendChild(outer);
						var widthNoScroll = outer.offsetWidth;
						// force scrollbars
						outer.style.overflow = "scroll";
						// add inner div
						var inner = document.createElement("div");
						inner.style.width = "100%";
						outer.appendChild(inner);
						var widthWithScroll = inner.offsetWidth;
						// remove divs
						outer.parentNode.removeChild(outer);
						return widthNoScroll - widthWithScroll;
						}
						// Сохраняем ширину скроллбара в переменную
						var scrollbarWidth = getScrollbarWidth();
						// При открытии модального окна
						$('.modal').on('show.bs.modal', function () {
						if ($('body').height() > $(window).height()) {
						$('body').addClass('modal-scrollbar-compensate');
						}
						$('body').addClass('modal-open-no-scroll');
						});
						// При закрытии модального окна
						$('.modal').on('hidden.bs.modal', function () {
						$('body').removeClass('modal-scrollbar-compensate');
						$('body').removeClass('modal-open-no-scroll');
						});
						// Добавляем компенсацию ширины скроллбара
						$(window).on('resize', function () {
						if ($('body').hasClass('modal-scrollbar-compensate')) {
						if (scrollbarWidth) {
						$('body').css('margin-right', scrollbarWidth);
						} else {
						$('body').css('margin-right', '17px'); // Задаём стандартное значение на случай если не удалось определить ширину скроллбара
						}
						} else {
						$('body').css('margin-right', '0');
						}
						}).trigger('resize');
						});
									</script>
		</body>
</html>
