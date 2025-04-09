<?php

//
// Copyright (C) 2006-2016 Next Generation CMS (http://ngcms.ru)
// Name: admin.php
// Description: administration panel
// Author: Vitaly Ponomarev, Alexey Zinchenko
//

// Administrative panel filters

$AFILTERS = [];

// Load core
header('Content-Type: text/html; charset=utf-8');
include_once 'core.php';

/**
 * @var $userROW
 * @var $lang
 * @var $SYSTEM_FLAGS
 * @var $twig
 * @var $config
 * @var $mysql
 * @var $unapproved
 * @var $main_admin
 */

// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}

header('Cache-Control: no-store, no-cache, must-revalidate');
header('Cache-Control: post-check=0, pre-check=0', false);
header('Pragma: no-cache');

// Pre-configure required global variables
$action = $_REQUEST['action'] ?? '';
$subaction = $_REQUEST['subaction'] ?? '';
$mod = $_REQUEST['mod'] ?? '';

// Activate output buffer
ob_start();

// Uncomment the line below if 'DEBUG' is defined
// define('DEBUG', 1);

if (defined('DEBUG')) {
    echo 'HTTP CALL PARAMS: <pre>';
    var_dump(['GET' => $_GET, 'POST' => $_POST, 'COOKIE' => $_COOKIE]);
    echo "</pre><br>\n";
    echo 'SERVER PARAMS: <pre>';
    var_dump($_SERVER);
    echo "</pre><br>\n";
}

$PHP_SELF = 'admin.php';
// Handle LOGIN
if ($action === 'login') {
    include_once root . 'cmodules.php';
    coreLogin();
}

// Handle LOGOUT
if ($action === 'logout') {
    include_once root . 'cmodules.php';
    coreLogout();
}

// Show LOGIN screen if user is not logged in
if (!is_array($userROW)) {
    $tVars = [
        'php_self'   => $PHP_SELF,
        'redirect'   => $REQUEST_URI,
        'year'       => date('Y'),
        'home_title' => home_title,
        'error'      => ($SYSTEM_FLAGS['auth_fail']) ? $lang['msge_login'] : '',
        'is_error'   => ($SYSTEM_FLAGS['auth_fail']) ? '$1' : '',
    ];

    $xt = $twig->loadTemplate(tpl_actions . 'login.tpl');
    echo $xt->render($tVars);
    exit;
}

// Check if visitor has permissions to view admin panel
if (!checkPermission(['plugin' => '#admin', 'item' => 'system'], null, 'admpanel.view')) {
    ngSYSLOG(['plugin' => '#admin', 'item' => 'system'], ['action' => 'admpanel.view'], null, [0, 'SECURITY.PERM']);
    header('Location: ' . home);
    exit;
}

// Only admins can reach this location
define('ADMIN', 1);

// Load library
require_once './includes/inc/lib_admin.php';

/**
 * Проверяет необходимость обновления БД и показывает страницу обслуживания
 */
function checkDatabaseUpgradeRequirement(): void
{
    if (!dbCheckUpgradeRequired()) {
        return;
    }

    $html = <<<HTML
<!DOCTYPE html>
<html lang="ru">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Требуется обновление БД | NGCMS</title>
    <style>
        .maintenance-container {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 600px;
            margin: 10% auto;
            padding: 30px;
            border-radius: 5px;
            background: #f5f5f5;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }
        .maintenance-title {
            color: #d9534f;
            font-size: 24px;
            margin-bottom: 15px;
        }
        .maintenance-message {
            font-size: 16px;
            margin-bottom: 25px;
            line-height: 1.5;
            color: #333;
        }
        .upgrade-button {
            display: inline-block;
            padding: 10px 20px;
            background: #5cb85c;
            color: white;
            text-decoration: none;
            border-radius: 4px;
            font-weight: 600;
        }
        .footer-note {
            margin-top: 20px;
            font-size: 13px;
            color: #777;
        }
    </style>
</head>
<body>
    <div class="maintenance-container">
        <h1 class="maintenance-title">NGCMS: Требуется обновление базы данных</h1>
        <div class="maintenance-message">
            Система обнаружила, что структура вашей базы данных требует обновления<br>
            для соответствия текущей версии программного обеспечения.<br>
            Пожалуйста, выполните обновление перед продолжением работы.
        </div>
        <a href="upgrade.php" class="upgrade-button">Обновить базу данных</a>
        <div class="footer-note">
            После обновления система будет работать в штатном режиме
        </div>
    </div>
</body>
</html>
HTML;

    echo $html;
    exit;
}

// Пример использования:
checkDatabaseUpgradeRequirement();

// Load plugins, that need to make any changes during user in admin panel
load_extras('admin:init');

// Configure user's permissions (access to modules, depends on user's status)
$permissionItems = [
    'perm',
    'ugroup',
    'configuration',
    'cron',
    'dbo',
    'extras',
    'extra-config',
    'docs',
    'statistics',
    'templates',
    'users',
    'rewrite',
    'static',
    'editcomments',
    'ipban',
    'categories',
    'news',
    'files',
    'images',
    'pm',
    'preview'
];

$permissions = [];

foreach ($permissionItems as $item) {
    $permissions[$item] = checkPermission(['plugin' => '#admin', 'item' => $item], null, 'details');
}

exec_acts('admin_header');

// Default action
if (!$mod) {
    $mod = $permissions['statistics'] ? 'statistics' : 'news';
}

// Check requested module exists
if (isset($permissions[$mod]) && $permissions[$mod]) {
    // Load plugins, that need to make any changes in this mod
    load_extras('admin:mod:' . $mod);
    require './actions/' . $mod . '.php';
} else {
    $notify = msg(['type' => 'error', 'text' => $lang['msge_mod']]);
}

$lang = LoadLang('index', 'admin');
$skins_url = skins_url;
LoadPluginLibrary('uprofile', 'lib');

$skin_UAvatar = (isset($userROW['avatar']) and !empty($userROW['avatar']) and function_exists('userGetAvatar')) ? userGetAvatar($userROW)[1] : $skins_url . '/images/default-avatar.jpg';
$skin_UStatus = $UGROUP[$userROW['status']]['langName'][$config['default_lang']];
///////////////////

if (is_array($userROW)) {
    $unnAppCount = '0';
    $newpm = '';
    $unapp1 = '';
    $unapp2 = '';

$newpm = $mysql->result("SELECT count(pmid) FROM " . prefix . "_users_pm WHERE to_id = " . db_squote($userROW['id']) . " AND viewed = '0'");
    $newpmText = ($newpm != "0") ? $newpm . ' ' . Padeg($newpm, $lang['head_pm_skl']) : $lang['head_pm_no'];

    // Calculate number of un-approved news
    if ($userROW['status'] == 1 || $userROW['status'] == 2) {
        $unapp1 = $mysql->result("SELECT count(id) FROM " . prefix . "_news WHERE approve = '-1'");
        $unapp2 = $mysql->result("SELECT count(id) FROM " . prefix . "_news WHERE approve = '0'");
        $unapp3 = $mysql->result("SELECT count(id) FROM " . prefix . "_static WHERE approve = '0'");
        if ($unapp1)
            $unapproved1 = '<a class="dropdown-item" href="' . $PHP_SELF . '?mod=news&status=1"><i class="fa fa-ban"></i> ' . $unapp1 . ' ' . Padeg($unapp1, $lang['head_news_draft_skl']) . '</a>';
        if ($unapp2)
            $unapproved2 = '<a class="dropdown-item" href="' . $PHP_SELF . '?mod=news&status=2"><i class="fa fa-times"></i> ' . $unapp2 . ' ' . Padeg($unapp2, $lang['head_news_pending_skl']) . '</a>';
        if ($unapp3)
            $unapproved3 = '<a class="dropdown-item" href="' . $PHP_SELF . '?mod=static"><i class="fa fa-times"></i> ' . $unapp3 . ' ' . Padeg($unapp3, $lang['head_stat_pending_skl']) . '</a>';
    }

    $unnAppCount = (int)$newpm + (int)$unapp1 + (int)$unapp2 + (int)$unapp3;
    $unnAppLabel = ($unnAppCount != "0") ? '<span class="label label-danger">' . $unnAppCount . '</span>' : '';
    $unnAppText = $lang['head_notify'] . (($unnAppCount != "0") ? $unnAppCount . ' ' . Padeg($unnAppCount, $lang['head_notify_skl']) : $lang['head_notify_no']);
}
$datetimepicker_lang_default = "
$.datepicker.setDefaults($.datepicker.regional['" . $lang['langcode'] . "']);
$.timepicker.setDefaults($.timepicker.regional['" . $lang['langcode'] . "']);
";
$datetimepicker_lang = ($lang['langcode'] == 'ru') ? $datetimepicker_lang_default : '';

$tVars = [
    'php_self'                => $PHP_SELF,
    'home_title'            => $config['home_title'],
    'newpm'                    => $newpm,
    'unapproved'            =>  $unapproved,
    'main_admin'            => $main_admin,
    'notify'                => $notify,
    'datetimepicker_lang'    => $datetimepicker_lang,
    'h_active_users'        => (($mod == 'users') || ($mod == 'ipban') || ($mod == 'ugroup') || ($mod == 'perm')) ? ' class="active"' : '',
    'h_active_content'      => ($mod == 'news' || $mod == 'categories' || $mod == 'static' || $mod == 'images' || $mod == 'files') ? ' class="active"' : '',
    'h_active_options'        => (($mod == '') || ($mod == 'options') || ($mod == 'configuration') || ($mod == 'statistics') || ($mod == 'dbo') || ($mod == 'rewrite') || ($mod == 'cron')) ? ' class="active"' : '',
    'h_active_extras'        => (($mod == 'extra-config') || ($mod == 'extras')) ? ' class="active"' : '',
    'h_active_addnews'        => (($mod == 'news') && ($action == 'add')) ? ' class="active"' : '',
    'h_active_editnews'        => (($mod == 'news') && ($action != 'add')) ? ' class="active"' : '',
    'h_active_images'        => ($mod == 'images') ? ' class="active"' : '',
    'h_active_files'        => ($mod == 'files') ? ' class="active"' : '',
    'h_active_templates'    => ($mod == 'templates') ? ' class="active"' : '',
    'h_active_pm'            => ($mod == 'pm') ? ' class="active"' : '',
    'year'                     => date("Y"),
    'themeStyle'            => $themeStyle,
    'skin_UAvatar'          => $skin_UAvatar,
    'skin_UStatus'          => $skin_UStatus,
    'unapproved1'           => $unapproved1,
    'unapproved2'           => $unapproved2,
    'unapproved3'           => $unapproved3,
    'unnAppText'            => $unnAppText,
    'unnAppLabel'           => $unnAppLabel,
    'user' => array(
        'id' => $userROW['id'],
        'name' => $userROW['name'],
        'status' => $status,
        'avatar' => $userAvatar,
        'flags' => array(
            'hasAvatar' => $config['use_avatars'] and $userAvatar,
        ),
    ),
    'newpmText' => $newpmText,
    'perm'                => [
        'static'        => checkPermission(['plugin' => '#admin', 'item' => 'static'], null, 'view'),
        'categories'    => checkPermission(['plugin' => '#admin', 'item' => 'categories'], null, 'view'),
        'addnews'       => checkPermission(['plugin' => '#admin', 'item' => 'news'], null, 'add'),
        'editnews'      => (checkPermission(['plugin' => '#admin', 'item' => 'news'], null, 'personal.list') || checkPermission(['plugin' => '#admin', 'item' => 'news'], null, 'other.list')),
        'configuration' => checkPermission(['plugin' => '#admin', 'item' => 'configuration'], null, 'details'),
        'dbo'           => checkPermission(['plugin' => '#admin', 'item' => 'dbo'], null, 'details'),
        'cron'          => checkPermission(['plugin' => '#admin', 'item' => 'cron'], null, 'details'),
        'rewrite'       => checkPermission(['plugin' => '#admin', 'item' => 'rewrite'], null, 'details'),
        'templates'     => checkPermission(['plugin' => '#admin', 'item' => 'templates'], null, 'details'),
        'ipban'         => checkPermission(['plugin' => '#admin', 'item' => 'ipban'], null, 'view'),
        'users'         => checkPermission(['plugin' => '#admin', 'item' => 'users'], null, 'view'),
    ],
];

// Register global vars
$twigGlobal['action'] = $action;
$twigGlobal['subaction'] = $subaction;
$twigGlobal['mod'] = $mod;

if (!$mod || ($mod !== 'preview')) {
    $xt = $twig->loadTemplate(dirname(tpl_actions) . '/index.tpl');
    echo $xt->render($tVars);
}

if (defined('DEBUG')) {
    echo "SQL queries:<br />\n-------<br />\n" . implode("<br />\n", $mysql->query_list);
}

exec_acts('admin_footer');