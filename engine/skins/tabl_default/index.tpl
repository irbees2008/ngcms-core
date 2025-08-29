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
		</style>
	</head>
	<body>
		<div id="loading-layer" class="col-md-3 alert alert-dark" role="alert">
			<i class="fa fa-spinner fa-pulse mr-2"></i>
			{{ lang['loading'] }}
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
								<a href="https://forum.ngcms.org/" target="_blank">
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
					<a href="http://ngcms.ru" target="_blank">Next Generation CMS</a>
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
							{{ newpmText }}</a>
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
// Auto reload after configuration save
if (window.location.search.includes('mod=configuration')) {
	$(document).on('submit', 'form', function() {
		setTimeout(function() { location.reload(); }, 1500);
	});
}
			</script>
		</body>
	</body>
</html>
