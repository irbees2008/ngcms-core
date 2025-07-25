<?php
//
// Copyright (C) 2006-2020 Next Generation CMS (http://ngcms.ru/)
// Name: consts.inc.php
// Description: Initializing global consts
// Author: Vitaly Ponomarev
//
// Determine current admin working directory
    $tempVariable = preg_split('/(\\\|\/)/', root, -1, PREG_SPLIT_NO_EMPTY);
    define('adminDirName', array_pop($tempVariable));
    unset($tempVariable);
@define('NGCMS', true);
@define('engineName', 'NGCMS');
@define('engineVersion', '0.9.7 RC3');
@define('engineVersionType', 'GIT');
@define('engineVersionBuild', 'e9b75bb');
@define('minDBVersion', 5);
@define('prefix', $config['prefix']);
@define('uprefix', $config['uprefix']);
@define('home', $config['home_url']);
@define('scriptLibrary', $config['home_url'].'/lib');
@define('localPrefix', (preg_match('#^http\:\/\/([^\/])+(\/.+)#', $config['home_url'], $tempMatch)) ? $tempMatch[2] : '');
@define('home_title', $config['home_title']);
@define('admin_url', $config['admin_url']);
@define('files_dir', $config['files_dir']);
@define('files_url', $config['files_url']);
@define('images_dir', $config['images_dir']);
@define('images_url', $config['images_url']);
@define('avatars_dir', $config['avatars_dir']);
@define('avatars_url', $config['avatars_url']);
@define('timestamp', $config['timestamp_active']);
@define('date_adjust', $config['date_adjust']);
@define('skins_url', admin_url.'/skins/default');
@define('tpl_actions', root.'skins/default/tpl/');
@define('tpl_dir', site_root.'templates/');
@define('extras_dir', root.'plugins', true);
@define('conf_pactive', confroot.'plugins.php', true);
@define('conf_pconfig', confroot.'plugdata.php', true);
