<!DOCTYPE html>
<html lang="{{ lang['langcode'] }}">
	<head>
		<meta charset="{{ lang['encoding'] }}"/>
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<title>{{ home_title }}
			-
			{{ lang['admin_panel'] }}</title>
		<link href="{{ skins_url }}/public/css/bootstrap.min.css" type="text/css" rel="stylesheet">
		<link href="{{ skins_url }}/public/css/custom.min.css" type="text/css" rel="stylesheet">
		<link href="{{ skins_url }}/public/css/notify.css" type="text/css" rel="stylesheet">
		<link href="{{ skins_url }}/public/css/fontawesome.css" type="text/css" rel="stylesheet">
		<script src="{{ skins_url }}/public/js/manifest.js" type="text/javascript"></script>
		<script src="{{ skins_url }}/public/js/vendor.js" type="text/javascript"></script>
		<script src="{{ skins_url }}/public/js/app.js" type="text/javascript"></script>
		<script src="{{ skins_url }}/public/js/notify.js" type="text/javascript"></script>
		{# Стили для jQuery DateTimePicker (xdsoft) #}
		<link href="https://cdn.jsdelivr.net/npm/jquery-datetimepicker@2.5.21/build/jquery.datetimepicker.min.css" rel="stylesheet"/>
		<style>
			/* На всякий случай: повыше поверх модалок/панелей */
			.xdsoft_datetimepicker {
				z-index: 10550 !important;
			}
		</style>
	</head>
	<body class="nav-md">
		<div class="container body">
			<div class="main_container">
				<div class="col-md-3 left_col">
					<div class="left_col">
						<div class="navbar nav_title" style="border: 0;">
							<a href="{{ php_self }}" class="site_title">
								<i class="fa fa-rocket"></i>
								<span>Next Generation</span>
							</a>
						</div>
						<div class="clearfix"></div>
						<!-- menu profile quick info -->
						<div class="profile clearfix mb-3">
							<div class="profile_pic">
								<img src="{{ skin_UAvatar }}" alt="" class="img-circle profile_img">
							</div>
							<div class="profile_info">
								<span>Добро пожаловать,</span>
								<h4>{{ user.name }}</h4>
							</div>
						</div>
						<!-- /menu profile quick info -->
						<!-- sidebar menu -->
						<div id="sidebar-menu" class="main_menu_side main_menu">
							<div class="menu_section">
								<h3>Основное</h3>
								<ul class="nav side-menu">
									<li>
										<a href="{{ php_self }}">
											<i class="fa fa-home"></i>
											{{ lang['admin_panel'] }}</a>
									</li>
									<li>
										<a href="{{ home }}">
											<i class="fa fa-eye"></i>
											{{ lang['mainpage'] }}</a>
									</li>
									{% if (perm.addnews) %}
										<li>
											<a href="{{ php_self }}?mod=news&action=add">
												<i class="fa fa-plus"></i>
												{{ lang['news.add'] }}</a>
										</li>
									{% endif %}
									<li>
										<a>
											<i class="fa fa-newspaper-o"></i>
											{{ lang['news_a'] }}
											<span class="fa fa-chevron-down"></span>
										</a>
										<ul class="nav child_menu">
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
									</li>
									<li>
										<a>
											<i class="fa fa-users"></i>
											{{ lang['userman'] }}
											<span class="fa fa-chevron-down"></span>
										</a>
										<ul class="nav child_menu">
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
									</li>
									<li>
										<a>
											<i class="fa fa-edit"></i>
											{{ lang['system'] }}
											<span class="fa fa-chevron-down"></span>
										</a>
										<ul class="nav child_menu">
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
										</ul>
									</li>
									<li>
										<a href="{{ php_self }}?mod=extras">
											<i class="fa fa-plug"></i>
											{{ lang['extras'] }}</a>
									</li>
									<li>
										<a href="{{ php_self }}?mod=templates">
											<i class="fa fa-th-large"></i>
											{{ lang['templates_m'] }}</a>
									</li>
								</ul>
							</div>
							<div class="menu_section">
								<h3>Компоненты</h3>
								<ul class="nav side-menu">
									<li>
										<a href="{{ php_self }}?mod=docs">
											<i class="fa fa-book"></i>
											Документация</a>
									</li>
									<li>
										<a href="https://forum.ngcms.org/">
											<i class="fa fa-comments"></i>
											Форум поддержки</a>
									</li>
									<li>
										<a href="https://ngcms.org/">
											<i class="fa fa-globe"></i>
											Официальный сайт</a>
									</li>
									<li>
										<a href="https://github.com/irbees2008/ngcms-core">
											<i class="fa fa-github"></i>
											Github</a>
									</li>
								</ul>
							</div>
						</div>
						<!-- /sidebar menu -->
						<!-- /menu footer buttons -->
						<div class="sidebar-footer hidden-small">
							<a data-toggle="tooltip" title="Документация" href="{{ php_self }}?mod=docs">
								<span class="fa fa-book"></span>
							</a>
							<a data-toggle="tooltip" title="Форум поддержки" href="https://forum.ngcms.org">
								<span class="fa fa-comments"></span>
							</a>
							<a data-toggle="tooltip" title="Официальный сайт" href="https://ngcms.org/">
								<span class="fa fa-globe"></span>
							</a>
							<a data-toggle="tooltip" title="Github" href="https://github.com/irbees2008/ngcms-core">
								<span class="fa fa-github"></span>
							</a>
						</div>
						<!-- /menu footer buttons -->
					</div>
				</div>
				<!-- top navigation -->
				<div class="top_nav">
					<div class="nav_menu">
						<div class="nav toggle">
							<a id="menu_toggle">
								<i class="fa fa-bars"></i>
							</a>
						</div>
						<nav class="nav navbar-nav">
							<ul class="navbar-right">
								<li class="nav-item dropdown open" style="padding-left: 15px;">
									<a href="javascript:;" class="user-profile dropdown-toggle" aria-haspopup="true" id="navbarDropdown" data-bs-toggle="dropdown" aria-expanded="false">
										<img src="{{ skin_UAvatar }}" alt="">
										{{ user.name }}
									</a>
									<div class="dropdown-menu float-end" aria-labelledby="navbarDropdown">
										<a class="dropdown-item" href="?mod=users&action=editForm&id={{ user.id }}">
											{{ lang['loc_profile'] }}</a>
										<a class="dropdown-item" href="{{ php_self }}?action=logout">
											<i class="fa fa-sign-out-alt float-end"></i>
											{{ lang['logout'] }}</a>
									</div>
								</li>
								<li role="pm" class="nav-item dropdown m-1">
									<a href="{{ php_self }}?mod=pm" title="{{ lang['pm_t'] }} - {{ newpmText }}" class="info-number">
										<i class="fa fa-envelope"></i>
										{% if newpm > 0 %}
											<span class="badge bg-green">{{ newpm }}</span>
										{% endif %}
									</a>
								</li>
								<li role="presentation" class="nav-item dropdown open m-1">
									<a href="javascript:;" class="dropdown-toggle info-number" id="navbarDropdown1" data-bs-toggle="dropdown" aria-expanded="false">
										<i class="fa fa-bell"></i>
										<span class="badge bg-red">{{ unnAppLabel }}</span>
									</a>
									<ul class="dropdown-menu list-unstyled msg_list" role="menu" aria-labelledby="navbarDropdown1">
										{{ unapproved1 }}
										{{ unapproved2 }}
										{{ unapproved3 }}
										{% if newpm > 0 %}
											<a class="dropdown-item" href="{{ php_self }}?mod=pm" title="{{ lang['pm_t'] }}">
												<div class="d-flex align-items-center">
													<i class="fa fa-envelope-o"></i>
													<div class="flex-grow-1 ms-2">
														<h6 class="mt-0 mb-1 fs-13 fw-semibold">{{ newpmText }}</h6>
														<div class="fs-13 text-muted">
															<p class="mb-0">{{ lang['notify.new_pm'] }}</p>
														</div>
													</div>
												</div>
											</a>
										{% endif %}
									</ul>
								</li>
								{# Кнопка: Очистить кэш (браузера + сервера) - показываем только при наличии прав #}
								{% if perm.cache %}
									<li role="cache" class="nav-item dropdown m-1">
										<a href="#" id="btn-clear-cache" title="{{ lang['cache.clean']|default('Очистить кеш') }}" class="info-number">
											<i class="fa fa-cog"></i>
										</a>
									</li>
								{% endif %}
							</ul>
						</nav>
					</div>
				</div>
				<!-- /top navigation -->
				<!-- page content -->
				<div class="right_col" role="main">
					{{ notify }}
					{{ main_admin }}
				</div>
			</div>
		</div>
		<!-- /page content -->
		<!-- footer content -->
		<footer>
			2008-{{ year }}
			©
			<a href="http://ngcms.org" target="_blank">Next Generation CMS</a>
			<div class="float-end">
				Template by
				<a href="https://colorlib.com">Colorlib</a>
			</div>
			<div class="clearfix"></div>
		</footer>
		<!-- /footer content -->
		<div id="loading-layer" style="display:none">
			{{ lang['loading'] }}
		</div>
		<script src="{{ skins_url }}/public/js/bootstrap.bundle.min.js"></script>
		<script src="{{ skins_url }}/public/js/bootstrap-progressbar.min.js"></script>
		<script src="{{ skins_url }}/public/js/custom.min.js"></script>
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
		</script>
		<script type="text/javascript">
			// Очистка кэшей браузера: localStorage, sessionStorage, Cache Storage
async function clearBrowserCaches() {
try { // local/session storage
try {
window.localStorage && window.localStorage.clear();
} catch (e) {}
try {
window.sessionStorage && window.sessionStorage.clear();
} catch (e) {}
// Cache Storage API
if (window.caches && caches.keys) {
const keys = await caches.keys();
await Promise.all(keys.map((k) => caches.delete(k)));
}
return true;
} catch (e) {
return false;
}
}
// Унифицированный показ уведомлений под стиль default-скина
function showNotify(message, type) { // 1) Наши toasts, если присутствуют
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
// 2) Bootstrap Notify (если есть jQuery и плагин)
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
// 3) Старый fallback на ngNotifySticker (оставляем для совместимости)
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
// 4) Самый простой вариант
try {
alert(String(message));
} catch (e) {}
}
// Глобальные шимы: любые старые вызовы будут приходить сюда и показываться как toasts
(function () { // 1) Переопределяем ngNotifySticker -> showNotify
try {
var __ngStickerOriginal = window.ngNotifySticker;
window.ngNotifySticker = function (message, options) {
try {
var cls = options && (options.className || options.class) || '';
var t = 'info';
if (/success/i.test(cls))
t = 'success';
 else if (/(danger|error)/i.test(cls))
t = 'danger';
 else if (/warning/i.test(cls))
t = 'warning';
showNotify(String(message), t);
} catch (e) {
if (typeof __ngStickerOriginal === 'function') {
return __ngStickerOriginal(message, options);
}
try {
alert(String(message));
} catch (_) {}
}
};
} catch (e) {}
// 2) Переопределяем $.notify -> showNotify (если используется bootstrap-notify)
try {
if (window.$ && typeof $.notify === 'function') {
var __jqNotifyOriginal = $.notify;
$.notify = function (opts, settings) {
try {
var msg = (typeof opts === 'string') ? opts : (opts && (opts.message || opts.title || ''));
var t = settings && settings.type || 'info';
showNotify(String(msg || ''), t);
} catch (e) {
try {
return __jqNotifyOriginal.apply(this, arguments);
} catch (_) {}
}
};
}
} catch (e) {}
})();
// Клик по иконке "Очистить кэш": чистим браузер и дергаем RPC admin.statistics.cleanCache
async function handleTopbarClearCacheClick(ev) {
ev && ev.preventDefault && ev.preventDefault();
// 1) Браузерный кэш
const browserOk = await clearBrowserCaches();
// 2) Серверный кэш (папка cache/) через RPC
try {
const resp = await post('admin.statistics.cleanCache', {
token: '{{ token_statistics|e('js') }}'
}, false);
if (resp && resp.status) {
showNotify('{{ lang['notify.cache.server_ok']|e('js') }}', 'success');
} else {
showNotify('{{ lang['notify.cache.server_fail']|e('js') }}', 'danger');
}
} catch (e) {
showNotify('{{ lang['notify.cache.server_fail']|e('js') }}', 'danger');
}
// Итоговое уведомление по браузерному кэшу
if (browserOk) {
showNotify('{{ lang['notify.cache.browser_ok']|e('js') }}', 'success');
} else {
showNotify('{{ lang['notify.cache.browser_fail']|e('js') }}', 'warning');
}
return false;
}
document.addEventListener('DOMContentLoaded', function () {
const btn = document.getElementById('btn-clear-cache');
if (btn) {
btn.addEventListener('click', handleTopbarClearCacheClick);
}
});
		</script>
	</body>
</html>
