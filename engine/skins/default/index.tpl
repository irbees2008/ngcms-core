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
		<style>
			body {
				font-weight: 300;
			}
			/* Глобальный оверлей загрузки: фиксированный, не влияет на поток */
			#loading-layer {
				position: fixed;
				top: 0;
				left: 0;
				right: 0;
				bottom: 0;
				z-index: 20000;
				display: none;
				background: rgba(255, 255, 255, 0.65);
				backdrop-filter: blur(1px);
			}
			#loading-layer .loading-content {
				position: absolute;
				top: 50%;
				left: 50%;
				transform: translate(-50%, -50%);
				padding: 0.75rem 1rem;
				border-radius: 0.5rem;
				background: rgba(255, 255, 255, 0.95);
				color: #333;
				box-shadow: 0 6px 18px rgba(0, 0, 0, 0.12);
				display: inline-flex;
				align-items: center;
				gap: 0.5rem;
				font-weight: 500;
			}
			#loading-layer .spinner {
				width: 1.25rem;
				height: 1.25rem;
				border: 2px solid rgba(0, 0, 0, 0.2);
				border-top-color: rgba(0, 0, 0, 0.6);
				border-radius: 50%;
				animation: v-spin 0.8s linear infinite;
			}
			@keyframes v-spin {
				to {
					transform: rotate(360deg);
				}
			}
		</style>
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
			<div class="btn-group ml-auto mr-2 py-1" role="group" aria-label="Button group with nested dropdown">
				<ul class="navbar-nav ml-auto">
					<li
						class="nav-item">
						<!-- Иконка уведомлений -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#notificationsModal">
							<i class="fa fa-bell-o fa-lg"></i>
							<span class="badge badge-notife badge-danger">{{ unnAppLabel }}</span>
						</a>
					</li>
					{% if perm.cache %}
						<li
							class="nav-item">
							<!-- Очистка кэша (браузер + сервер) -->
							<a type="button" class="nav-link" id="btn-clear-cache" title="{{ lang['cache.clean']|default('Очистить кеш') }}">
								<i class="fa fa-refresh fa-lg"></i>
							</a>
						</li>
					{% endif %}
					<li
						class="nav-item">
						<!-- Иконка добавления контента -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#addContentModal">
							<i class="fa fa-plus fa-lg"></i>
						</a>
					</li>
					<li
						class="nav-item">
						<!-- Иконка профиля пользователя -->
						<a type="button" class="nav-link" data-toggle="modal" data-target="#userProfileModal">
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
								<a href="https://github.com/vponomarev/ngcms-core" target="_blank">
									<i class="fa fa-github"></i>
									Github</a>
							</li>
						</ul>
					</div>
				</div>
				<main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-md-4 my-4">
					<div id="legacy-notify" style="display:none">{{ notify }}</div>
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
// Универсальный показ уведомлений: используем новые toasts (ngNotifySticker), при отсутствии — создаём их на лету
function showNotify(message, type) {
message = String(message);
var reqType = String(type || 'info');
// Bootstrapper: всегда переопределяем глобальные toasts на современные
(function ensureNgToasts() {
try {
if (!document.getElementById('ng-toast-styles')) {
var style = document.createElement('style');
style.id = 'ng-toast-styles';
style.type = 'text/css';
style.textContent = '' + '#ng-toast-container{position:fixed;top:16px;right:16px;display:flex;flex-direction:column;gap:12px;z-index:2147483647}' + '.ng-toast{display:grid;grid-template-columns:auto 1fr auto;align-items:start;column-gap:10px;row-gap:4px;padding:12px 14px;min-width:260px;max-width:420px;background:#fff;color:#2c3e50;border-radius:8px;box-shadow:0 8px 24px rgba(0,0,0,.12),0 2px 6px rgba(0,0,0,.08);border-left:4px solid transparent;opacity:0;transform:translateX(120%);animation:ng-toast-in .35s ease-out forwards}' + '.ng-toast__icon{width:20px;height:20px;margin-top:2px}' + '.ng-toast__content{font-size:14px;line-height:1.35;word-break:break-word}' + '.ng-toast__close{appearance:none;border:0;background:transparent;color:#6c7a89;font-size:18px;line-height:1;padding:2px 4px;border-radius:4px;cursor:pointer}' + '.ng-toast__close:hover{color:#1f2d3d;background:rgba(0,0,0,.06)}' + '.ng-toast--info{border-left-color:#3498db}.ng-toast--success{border-left-color:#2ecc71}.ng-toast--warning{border-left-color:#f39c12}.ng-toast--error{border-left-color:#e74c3c}' + '.ng-toast--info .ng-toast__icon svg{color:#3498db}.ng-toast--success .ng-toast__icon svg{color:#2ecc71}.ng-toast--warning .ng-toast__icon svg{color:#f39c12}.ng-toast--error .ng-toast__icon svg{color:#e74c3c}' + '@keyframes ng-toast-in{from{opacity:0;transform:translateX(120%)}to{opacity:1;transform:translateX(0) }}@keyframes ng-toast-out{from{opacity:1;transform:translateX(0)}to{opacity:0;transform:translateX(120%) }}';
document.head.appendChild(style);
}
var container = document.getElementById('ng-toast-container');
if (! container) {
container = document.createElement('div');
container.id = 'ng-toast-container';
container.setAttribute('aria-live', 'polite');
container.setAttribute('aria-atomic', 'true');
document.body.appendChild(container);
}
function normalizeType(v) {
var c = String(v || '').toLowerCase();
if (c.indexOf('danger') !== -1 || c.indexOf('error') !== -1 || c.indexOf('fail') !== -1)
return 'error';
if (c.indexOf('success') !== -1 || c.indexOf('ok') !== -1)
return 'success';
if (c.indexOf('warn') !== -1)
return 'warning';
if (c.indexOf('primary') !== -1 || c.indexOf('info') !== -1)
return 'info';
return 'info';
}
if (typeof window.__ngRenderToast !== 'function') {
window.__ngRenderToast = function (msg, typeName, sticky) {
typeName = normalizeType(typeName);
var toast = document.createElement('div');
toast.className = 'ng-toast ng-toast--' + typeName;
var iconWrap = document.createElement('div');
iconWrap.className = 'ng-toast__icon';
var icons = {
info: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="12" y1="16" x2="12" y2="12"></line><line x1="12" y1="8" x2="12" y2="8"></line></svg>',
success: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path><polyline points="22 4 12 14.01 9 11.01"></polyline></svg>',
warning: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"></path><line x1="12" y1="9" x2="12" y2="13"></line><line x1="12" y1="17" x2="12" y2="17"></line></svg>',
error: '<svg viewBox="0 0 24 24" width="20" height="20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><circle cx="12" cy="12" r="10"></circle><line x1="15" y1="9" x2="9" y2="15"></line><line x1="9" y1="9" x2="15" y2="15"></line></svg>'
};
iconWrap.innerHTML = icons[typeName] || '';
var content = document.createElement('div');
content.className = 'ng-toast__content';
content.innerHTML = String(msg);
var closer = document.createElement('button');
closer.className = 'ng-toast__close';
closer.type = 'button';
closer.setAttribute('aria-label', 'Close');
closer.innerHTML = '&times;';
toast.appendChild(iconWrap);
toast.appendChild(content);
toast.appendChild(closer);
container.appendChild(toast);
var removed = false;
function remove() {
if (removed)
return;
removed = true;
toast.style.animation = 'ng-toast-out .25s ease-in forwards';
toast.addEventListener('animationend', function () {
if (toast && toast.parentNode)
toast.parentNode.removeChild(toast);
}, {once: true});
}
closer.addEventListener('click', remove);
if (! sticky) {
var ttl = Math.max(2500, Math.min(10000, String(msg).length * 60));
setTimeout(remove, ttl);
}
};
}
// Всегда переопределяем глобальную функцию на современную реализацию
window.ngNotifySticker = function (msg, opts) {
opts = opts || {};
var typeName = opts.type || opts.className || 'info';
var sticky = !! opts.sticked;
window.__ngRenderToast(msg, typeName, sticky);
};
window.ngNotifySticker.__modern = true;
} catch (e) {}
})();
if (typeof window.__ngRenderToast === 'function') {
window.__ngRenderToast(message, reqType, false);
return;
}
try {
alert(message);
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
// Миграция старых серверных уведомлений из {{ notify }} в новые тосты
try {
var legacy = document.getElementById('legacy-notify');
if (legacy) {
var html = legacy.innerHTML || '';
if (html && html.replace(/\s+/g, '').length) { // Попробуем найти bootstrap-алерты
var tmp = document.createElement('div');
tmp.innerHTML = html;
var alerts = tmp.querySelectorAll('.alert, .notification, .ng-msg, .nSys_notice');
if (alerts.length) {
alerts.forEach(function (a) {
var cls = a.className || '';
var type = 'info';
if (/alert\-(success|info|warning|danger|primary)/.test(cls)) {
type = (cls.match(/alert\-(success|info|warning|danger|primary)/) || [])[0] || 'alert-info';
type = type.replace('alert-', '');
} else if (/success|ok/.test(cls)) {
type = 'success';
} else if (/warn|warning/.test(cls)) {
type = 'warning';
} else if (/error|danger|fail/.test(cls)) {
type = 'danger';
}
var msg = a.textContent && a.textContent.trim() ? a.textContent.trim() : a.innerHTML;
showNotify(msg, type);
});
} else { // Если структуру не распознали — покажем весь html как info
if (html) {
showNotify(html, 'info');
}
}
}
// Очистим контейнер, чтобы не занимал место
legacy.innerHTML = '';
}
} catch (e) {}
// Шим для старых вызовов уведомлений ($.notify, ngNotify и пр.)
try {
function _mapType(opts) {
var t = (opts && (opts.type || opts.className)) || '';
t = String(t).toLowerCase();
if (t.indexOf('danger') !== -1 || t.indexOf('error') !== -1 || t.indexOf('fail') !== -1)
return 'danger';
if (t.indexOf('success') !== -1 || t.indexOf('ok') !== -1)
return 'success';
if (t.indexOf('warn') !== -1)
return 'warning';
if (t.indexOf('primary') !== -1 || t.indexOf('info') !== -1)
return 'info';
return 'info';
}
if (window.jQuery) {
var $ = window.jQuery;
// Перенаправим $.notify, если используется где-то в коде
if (! $.notify || typeof $.notify !== 'function' || ! $.notify.__bridged) {
var oldNotifyFn = $.notify;
var bridged = function (message, opts) {
try {
showNotify(message, _mapType(opts));
} catch (e) {
if (typeof oldNotifyFn === 'function')
oldNotifyFn.call($, message, opts);
}
};
bridged.__bridged = true;
$.notify = bridged;
}
}
} catch (e) {}
// Автоконвертация bootstrap-алертов в основной области в тосты
try {
var mainRoot = document.querySelector('main[role="main"]') || document.body;
function convertAlerts(root) {
var nodes = root.querySelectorAll('.alert');
nodes.forEach(function (el) {
if (! el || el.__ngToastConverted)
return;
// Игнорируем наши собственные контейнеры, если вдруг
if (el.closest('#ng-toast-container'))
return;
var cls = el.className || '';
var type = 'info';
var m = cls.match(/alert\-(success|info|warning|danger|primary)/);
if (m)
type = m[1] === 'primary' ? 'info' : m[1];
 else if (/success|ok/.test(cls))
type = 'success';
 else if (/warn|warning/.test(cls))
type = 'warning';
 else if (/error|danger|fail/.test(cls))
type = 'danger';
var msg = el.innerHTML && el.innerHTML.trim() ? el.innerHTML : (el.textContent || '');
if (msg) {
showNotify(msg, type);
}
el.__ngToastConverted = true;
// Удалим элемент из DOM, чтобы не дублировать
try {
el.parentNode && el.parentNode.removeChild(el);
} catch (e) {}
});
}
// Первичный проход
convertAlerts(mainRoot);
// Наблюдатель для динамических вставок
var mo = new MutationObserver(function (muts) {
muts.forEach(function (m) {
m.addedNodes && m.addedNodes.forEach(function (n) {
if (n.nodeType === 1) {
if (n.matches && n.matches('.alert'))
convertAlerts(n.parentNode || mainRoot);
 else
convertAlerts(n);
}
});
});
});
mo.observe(mainRoot, {
childList: true,
subtree: true
});
} catch (e) {}
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
	</body>
</html>
