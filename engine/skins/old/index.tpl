<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="{{ lang['langcode'] }}" lang="{{ lang['langcode'] }}" dir="ltr">
<head>
<meta http-equiv="Content-Type" content="text/html; charset={{ lang['encoding'] }}" />
<title>{{ home_title }} - {{ lang['admin_panel'] }}</title>
<link rel="stylesheet" href="{{ skins_url }}/style.css" type="text/css" media="screen" />
<link rel="stylesheet" href="{{ skins_url }}/ftr_panel.css" type="text/css" />
<link rel="stylesheet" href="{{ home }}/lib/jqueryui/core/themes/cupertino/jquery-ui.min.css" type="text/css"/>
<link rel="stylesheet" href="{{ home }}/lib/jqueryui/core/themes/cupertino/jquery-ui.theme.min.css" type="text/css"/>
<link rel="stylesheet" href="{{ home }}/lib/jqueryui/plugins/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.min.css" type="text/css"/>
<script type="text/javascript" src="{{ home }}/lib/jq/jquery.min.js"></script>
<script type="text/javascript" src="{{ home }}/lib/jqueryui/core/jquery-ui.min.js"></script>
<script type="text/javascript" src="{{ home }}/lib/jqueryui/plugins/jquery-ui-timepicker-addon/dist/jquery-ui-timepicker-addon.min.js"></script>
<script type="text/javascript" src="{{ home }}/lib/functions.js"></script>
<script type="text/javascript" src="{{ home }}/lib/admin.js"></script>
<script type="text/javascript" src="{{ skins_url }}/functions.js"></script>
<script type="text/javascript" src="{{ home }}/lib/jq/plugins/uploadifive/jquery.uploadifive.min.js"></script>
<link rel="stylesheet" href="{{ home }}/lib/jq/plugins/uploadifive/uploadifive.css" type="text/css" />
{% if lang['langcode'] == 'ru' %}
<script language="javascript" type="text/javascript">
$.datepicker.setDefaults($.datepicker.regional['{{ lang['langcode'] }}']);
$.timepicker.setDefaults($.timepicker.regional['{{ lang['langcode'] }}']);
</script>
{% endif %}
</head>
<body>
<div id="loading-layer"><img src="{{ skins_url }}/images/loading.gif" alt="" /> {{ lang['loading'] }} ...</div>
<table border="0" width="1440" align="center" cellspacing="0" cellpadding="0">
<tr>
<td width="100%">
<div id="topNavigator">
	<span><a href="{{ home }}" title="{{ lang['mainpage_t'] }}" target="_blank">{{ lang['mainpage'] }}</a></span>
	<span{% if global.mod == 'news' and global.action == 'add' %} class="active"{% endif %}><a href="{{ php_self }}?mod=news&amp;action=add" title="{{ lang['addnews_t'] }}">{{ lang['addnews'] }}</a></span>
	<span{% if global.mod == 'news' and global.action != 'add' %} class="active"{% endif %}><a href="{{ php_self }}?mod=news" title="{{ lang['editnews_t'] }}">{{ lang['editnews'] }}</a>{% if unapproved %} {{ unapproved }}{% endif %}</span>
	<span{% if global.mod == 'categories' %} class="active"{% endif %}><a href="{{ php_self }}?mod=categories" title="{{ lang['categories_t'] }}">{{ lang['categories'] }}</a></span>
	<span{% if global.mod == 'static' %} class="active"{% endif %}><a href="{{ php_self }}?mod=static" title="{{ lang['static_t'] }}">{{ lang['static'] }}</a></span>
	<span{% if global.mod == 'images' %} class="active"{% endif %}><a href="{{ php_self }}?mod=images" title="{{ lang['images_t'] }}">{{ lang['images'] }}</a></span>
	<span{% if global.mod == 'files' %} class="active"{% endif %}><a href="{{ php_self }}?mod=files" title="{{ lang['files_t'] }}">{{ lang['files'] }}</a></span>
	<span{% if global.mod in ['users', 'ipban', 'ugroup', 'perm'] %} class="active"{% endif %}><a href="{{ php_self }}?mod=users" title="{{ lang['users_t'] }}">{{ lang['users'] }}</a></span>
	<span{% if global.mod in ['extras', 'extra-config'] %} class="active"{% endif %}><a href="{{ php_self }}?mod=extras" title="{{ lang['extras_t'] }}">{{ lang['extras'] }}</a></span>
	{% if perm.templates %}<span{% if global.mod == 'templates' %} class="active"{% endif %}><a href="{{ php_self }}?mod=templates" title="{{ lang['templates_t'] }}">{{ lang['templates_m'] }}</a></span>{% endif %}
	<span{% if global.mod == 'configuration' %} class="active"{% endif %}><a href="{{ php_self }}?mod=configuration" title="{{ lang['configuration_t'] }}">{{ lang['configuration'] }}</a></span>
	<span{% if global.mod in ['dbo', 'rewrite', 'cron', 'statistics'] %} class="active"{% endif %}><a href="{{ php_self }}?mod=dbo" title="{{ lang['dbo_t'] }}">{{ lang['options_database'] }}</a></span>
	<span><a href="{{ php_self }}?mod=statistics" title="{{ lang['statistics_t'] }}">{{ lang['statistics'] }}</a></span>
	<span{% if global.mod == 'pm' %} class="active"{% endif %}><a href="{{ php_self }}?mod=pm" title="{{ lang['pm_t'] }}">{{ lang['pm'] }}</a> </span>
	<span><a href="{{ php_self }}?action=logout" title="{{ lang['logout_t'] }}">{{ lang['logout'] }}</a></span>
</div>
<div id="adminDataBlock" style="text-align : left;">
{{ notify }}
{{ main_admin }}
</div>
<div class="clear_20"></div>
<div class="clear_ftr"></div>
<div id="footpanel">
    <ul id="mainpanel">
        <li><a href="http://ngcms.ru" target="_blank" class="home">© 2008-{{ year }} <strong>Next Generation</strong> CMS <small>{{ lang['ngcms_site'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=news&amp;action=add" class="add_news">{{ lang['addnews_t'] }}<small>{{ lang['addnews_t'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=news" class="add_edit">{{ lang['editnews'] }}<small>{{ lang['editnews'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=categories" class="add_category">{{ lang['categories'] }}<small>{{ lang['categories'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=static" class="add_static">{{ lang['static'] }}<small>{{ lang['static'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=images" class="add_images">{{ lang['images'] }}<small>{{ lang['images'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=files" class="add_files">{{ lang['files'] }}<small>{{ lang['files'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=users" class="add_user">{{ lang['users'] }}<small>{{ lang['users'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=extras" class="add_plugins">{{ lang['extras'] }}<small>{{ lang['extras'] }}</small></a></li>
        {% if perm.templates %}<li><a href="{{ php_self }}?mod=templates" class="add_templates">{{ lang['templates_m'] }}<small>{{ lang['templates_m'] }}</small></a></li>{% endif %}
        <li><a href="{{ php_self }}?mod=configuration" class="add_system_option">{{ lang['configuration'] }}<small>{{ lang['configuration'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=dbo" class="add_system">{{ lang['options_database'] }}<small>{{ lang['options_database'] }}</small></a></li>
        <li><a href="{{ php_self }}?mod=statistics" class="add_stat">{{ lang['statistics'] }}<small>{{ lang['statistics'] }}</small></a></li>
        <li id="alertpanel"><a href="https://rocketvip.ru/" target="_blank" class="rocket">{{ lang['design'] }}- RocketBoy</a></li>
<li id="chatpanel">
	<a href="https://forum.ngcms.org/" target="_blank" class="chat">{{ lang['forum'] }}</a>
</li>
    </ul>
</div>
</td>
</table>
</body>
</html>
