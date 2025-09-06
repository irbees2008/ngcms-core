<?php
//
// Copyright (C) 2006-2025 Next Generation CMS (http://ngcms.org/)
// Name: consts.inc.php
// Description: Initializing global consts
// Author: Vitaly Ponomarev
//
// Проверяем, определена ли переменная $config
if (!isset($config) || !is_array($config)) {
    die('Ошибка: массив $config не определён!');
}
// Determine current admin working directory
$tempVariable = preg_split('/(\\\|\/)/', root, -1, PREG_SPLIT_NO_EMPTY);
define('adminDirName', array_pop($tempVariable));
unset($tempVariable);
// Определяем константы только если они ещё не определены
if (!defined('NGCMS')) define('NGCMS', true);
if (!defined('engineName')) define('engineName', 'NGCMS');
if (!defined('engineVersion')) define('engineVersion', '0.9.8 Release');
if (!defined('engineVersionType')) define('engineVersionType', 'GIT');
if (!defined('engineVersionBuild')) define('engineVersionBuild', ' d2f66cc ');
if (!defined('minDBVersion')) define('minDBVersion', 7);
if (!defined('prefix')) define('prefix', $config['prefix']);
if (!defined('uprefix')) define('uprefix', $config['uprefix']);
if (!defined('home')) define('home', $config['home_url']);
if (!defined('scriptLibrary')) define('scriptLibrary', $config['home_url'].'/lib');
if (!defined('localPrefix')) define('localPrefix', (preg_match('#^http\:\/\/([^\/])+(\/.+)#', $config['home_url'], $tempMatch)) ? $tempMatch[2] : '');
if (!defined('home_title')) define('home_title', $config['home_title']);
if (!defined('admin_url')) define('admin_url', $config['admin_url']);
if (!defined('files_dir')) define('files_dir', $config['files_dir']);
if (!defined('files_url')) define('files_url', $config['files_url']);
if (!defined('images_dir')) define('images_dir', $config['images_dir']);
if (!defined('images_url')) define('images_url', $config['images_url']);
if (!defined('avatars_dir')) define('avatars_dir', $config['avatars_dir']);
if (!defined('avatars_url')) define('avatars_url', $config['avatars_url']);
if (!defined('timestamp')) define('timestamp', $config['timestamp_active']);
if (!defined('date_adjust')) define('date_adjust', $config['date_adjust']);
if (!defined('skins_url')) define('skins_url', admin_url.'/skins/'.($config['admin_skin'] ?? 'default'));
if (!defined('tpl_actions')) define('tpl_actions', root.'skins/'.($config['admin_skin'] ?? 'default').'/tpl/');
if (!defined('tpl_dir')) define('tpl_dir', site_root.'templates/');
if (!defined('extras_dir')) define('extras_dir', root.'plugins');
if (!defined('conf_pactive')) define('conf_pactive', confroot.'plugins.php');
if (!defined('conf_pconfig')) define('conf_pconfig', confroot.'plugdata.php');
