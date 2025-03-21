<?php

//
// Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.ru/)
// Name: extras.php
// Description: List plugins
// Author: Vitaly Ponomarev
//

// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}

// ==============================================================
//  Module functions
// ==============================================================
@include_once root . 'includes/inc/extraconf.inc.php';
@include_once root . 'includes/inc/httpget.inc.php';

// ==========================================================
// Functions
// ==========================================================

//
// Generate list of plugins
function admGeneratePluginList()
{
    global $lang, $twig, $repoPluginInfo, $PHP_SELF;

    $extras = pluginsGetList();
    ksort($extras);

    $pCount = [0 => 0, 1 => 0, 2 => 0, 3 => 0];

    $tEntries = [];
    foreach ($extras as $id => $extra) {
        if (!isset($extra['author_uri'])) {
            $extra['author_uri'] = '';
        }
        if (!isset($extra['author'])) {
            $extra['author'] = 'Unknown';
        }

        $tEntry = [
            'title'       => $extra['name'],
            'icons'       => $extra['icons'],
            'version'     => $extra['version'],
            'description' => isset($extra['description']) ? $extra['description'] : '',
            'author_url'  => ($extra['author_uri']) ? ('<a href="' . ((strpos($extra['author_uri'], '@') !== false) ? 'mailto:' : '') . $extra['author_uri'] . '">' . $extra['author'] . '</a>') : $extra['author'],
            'author'      => $extra['author'],
            'id'          => $extra['id'],
            'style'       => getPluginStatusActive($id) ? 'pluginEntryActive' : 'pluginEntryInactive',
            'readme'      => file_exists(extras_dir . '/' . $id . '/readme') && filesize(extras_dir . '/' . $id . '/readme') ? (admin_url . '/includes/showinfo.php?mode=plugin&amp;item=readme&amp;plugin=' . $id) : '',
            'history'     => file_exists(extras_dir . '/' . $id . '/history') && filesize(extras_dir . '/' . $id . '/history') ? (admin_url . '/includes/showinfo.php?mode=plugin&amp;item=history&amp;plugin=' . $id) : '',
            'flags'       => [
                'isCompatible'  => $extra['isCompatible'],
            ],
        ];

        if (isset($repoPluginInfo[$extra['id']]) && ($repoPluginInfo[$extra['id']][1] > $extra['version'])) {
            $tEntry['new'] = '<a href="http://ngcms.ru/sync/plugins.php?action=jump&amp;id=' . $extra['id'] . '.html" title="' . $repoPluginInfo[$extra['id']][1] . '"target="_blank"><img src="' . skins_url . '/images/new.png" width=30 height=15/></a>';
        } else {
            $tEntry['new'] = '';
        }

        $tEntry['type'] = in_array($extra['type'], ['plugin', 'module', 'filter', 'auth', 'widget', 'maintanance']) ? $lang[$extra['type']] : 'Undefined';

        //
        // Check for permanent modules
        //
        if (($extra['permanent']) && (!getPluginStatusActive($id))) {
            // turn on
            if (pluginSwitch($id, 'on')) {
                $notify = msg(['text' => sprintf($lang['msgo_is_on'], $extra['name'])]);
            } else {
                // generate error message
                $notify = msg(['text' => 'ERROR: ' . sprintf($lang['msgo_is_on'], $extra['name'])]);
            }
        }

        $needinstall = 0;
        $tEntry['install'] = '';
        if (getPluginStatusInstalled($extra['id'])) {
            if (isset($extra['deinstall']) && $extra['deinstall'] && is_file(extras_dir . '/' . $extra['dir'] . '/' . $extra['deinstall'])) {
                $tEntry['install'] = '<a href="' . $PHP_SELF . '?mod=extra-config&amp;plugin=' . $extra['id'] . '&amp;stype=deinstall" class="btn btn-outline-danger btn-sm">' . $lang['deinstall'] . '</a>';
            }
        } else {
            if (isset($extra['install']) && $extra['install'] && is_file(extras_dir . '/' . $extra['dir'] . '/' . $extra['install'])) {
                $tEntry['install'] = '<a href="' . $PHP_SELF . '?mod=extra-config&amp;plugin=' . $extra['id'] . '&amp;stype=install" class="btn btn-outline-danger btn-sm">' . $lang['install'] . '</a>';
                $needinstall = 1;
            }
        }

        $tEntry['url'] = '';

        // Проверяем условия для отображения ссылки "Настройки"
        if (
            isset($extra['config']) &&
            $extra['config'] &&
            !$needinstall &&
            is_file(extras_dir . '/' . $extra['dir'] . '/' . $extra['config'])
        ) {
            $tEntry['url'] = '<a href="' . $PHP_SELF . '?mod=extra-config&amp;plugin=' . $extra['id'] . '" class="btn btn-outline-primary btn-sm">' . $lang['settings'] . '</a>';
        }
        $tEntry['link'] = (getPluginStatusActive($id) ? '<a href="' . $PHP_SELF . '?mod=extras&amp;&amp;token=' . genUToken('admin.extras') . '&amp;disable=' . $id . '"class="btn btn-outline-success btn-sm">' . $lang['switch_off'] . '</a>' : '<a href="' . $PHP_SELF . '?mod=extras&amp;&amp;token=' . genUToken('admin.extras') . '&amp;enable=' . $id . '"class="btn btn-outline-success btn-sm">' . $lang['switch_on'] . '</a>');

        if ($needinstall) {
            $tEntry['link'] = '';
            $tEntry['style'] = 'pluginEntryUninstalled';
            $pCount[3]++;
        } else {
            $pCount[1 + (!getPluginStatusActive($id))]++;
        }
        $pCount[0]++;

        $tEntries[] = $tEntry;
    }

    $tVars = [
        'entries'        => $tEntries,
        'token'          => genUToken('admin.extras'),
        'cntAll'         => $pCount[0],
        'cntActive'      => $pCount[1],
        'cntInactive'    => $pCount[2],
        'cntUninstalled' => $pCount[3],
    ];
    $xt = $twig->loadTemplate(tpl_actions . 'extras/table.tpl');

    return $xt->render($tVars);
}

function repoSync()
{
    global $extras, $config;

    // Проверяем кэш
    if (($vms = cacheRetrieveFile('plugversion.dat', 86400)) === false) {
        // URL для запроса к GitHub API
        $repoOwner = 'irbees2008';          // Владелец репозитория
        $repoName = 'ngcms-plugins';       // Название репозитория
        $url = "https://api.github.com/repos/$repoOwner/$repoName/contents";

        // Создаем HTTP-запрос
        $req = new http_get();
        $response = $req->get($url, 3, 1);

        // Сохраняем ответ в кэш
        cacheStoreFile('plugversion.dat', $response);
        $vms = $response;
    }

    // Декодируем JSON-ответ
    $rps = json_decode($vms, true);

    // Обрабатываем данные
    $plugins = [];
    if (is_array($rps)) {
        foreach ($rps as $item) {
            if ($item['type'] === 'dir') { // Проверяем, что это папка (плагин)
                $pluginName = $item['name'];
                $plugins[$pluginName] = [
                    'url' => $item['html_url'], // Ссылка на плагин
                    'version' => 'unknown',     // Версия пока неизвестна
                    'description' => 'No description available', // Описание по умолчанию
                ];

                // Получаем содержимое version.ini
                $versionUrl = $item['url'] . '/version.ini';
                $versionReq = new http_get();
                $versionResponse = $versionReq->get($versionUrl, 3, 1);
                if ($versionResponse) {
                    $versionData = parse_ini_string($versionResponse);
                    $plugins[$pluginName]['version'] = $versionData['version'] ?? 'unknown';
                }

                // Получаем содержимое readme.ini
                $readmeUrl = $item['url'] . '/readme.ini';
                $readmeReq = new http_get();
                $readmeResponse = $readmeReq->get($readmeUrl, 3, 1);
                if ($readmeResponse) {
                    $readmeData = parse_ini_string($readmeResponse);
                    $plugins[$pluginName]['description'] = $readmeData['description'] ?? 'No description available';
                    $plugins[$pluginName]['author'] = $readmeData['author'] ?? 'Unknown author';
                }
            }
        }
    }

    return $plugins;
}

// ==============================================================
//  Main module code
// ==============================================================

$lang = LoadLang('extras', 'admin');
$extras = pluginsGetList();
ksort($extras);

// ==============================================================
// Load a list of updated plugins from central repository
// ==============================================================
$repoPluginInfo = repoSync();

// ==============================================================
// Process enable request
// ==============================================================
$enable = isset($_REQUEST['enable']) ? $_REQUEST['enable'] : '';
$disable = isset($_REQUEST['disable']) ? $_REQUEST['disable'] : '';
$manage = (isset($_REQUEST['manageConfig']) && $_REQUEST['manageConfig'] && isset($_REQUEST['action']) && ($_REQUEST['action'] == 'commit')) ? true : false;

// Check for security token
if ($enable || $disable || $manage) {
    if ((!isset($_REQUEST['token'])) || ($_REQUEST['token'] != genUToken('admin.extras'))) {
        $notify = msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);
        ngSYSLOG(['plugin' => '#admin', 'item' => 'extras', 'ds_id' => $id], ['action' => 'modify'], null, [0, 'SECURITY.TOKEN']);
        exit;
    }
}

if (isset($_REQUEST['manageConfig']) && $_REQUEST['manageConfig']) {
    pluginsLoadConfig();

    if (isset($_REQUEST['action']) && ($_REQUEST['action'] == 'commit')) {
        echo 'TRY COMMIT';
    }
    $confLine = json_encode($PLUGINS['config']);
    $confLine = jsonFormatter($confLine);

    $tVars = [
        'config' => $confLine,
        'token'  => genUToken('admin.extras'),
    ];
    $xt = $twig->loadTemplate('skins/default/tpl/extras/manage_config.tpl');

    return $xt->render($tVars);

    exit;
}

if ($enable) {
    if (pluginSwitch($enable, 'on')) {
        ngSYSLOG(['plugin' => '#admin', 'item' => 'extras'], ['action' => 'switch_on', 'list' => ['plugin' => $enable]], null, [1, '']);
        msgSticker([[sprintf($lang['msgo_is_on'], $extras[$enable]['name']), '', 1]]);
    } else {
        // generate error message
        ngSYSLOG(['plugin' => '#admin', 'item' => 'extras'], ['action' => 'switch_on', 'list' => ['plugin' => $enable]], null, [0, 'ERROR: ' . $enable]);
        $notify = msg(['text' => 'ERROR: ' . sprintf($lang['msgo_is_on'], $extras[$id]['name'])]);
    }
}

if ($disable) {
    if ($extras[$disable]['permanent']) {
        ngSYSLOG(['plugin' => '#admin', 'item' => 'extras'], ['action' => 'switch_off', 'list' => ['plugin' => $disable]], null, [0, 'ERROR: PLUGIN is permanent ' . $disable]);
        msgSticker([
            [$lang['permanent.lock'], 'title'],
            [str_replace('{name}', $disable, $lang['permanent.lock#desc'])],
        ], 'error');
    } else {
        if (pluginSwitch($disable, 'off')) {
            ngSYSLOG(['plugin' => '#admin', 'item' => 'extras'], ['action' => 'switch_off', 'list' => ['plugin' => $disable]], null, [1, '']);
            msgSticker([[sprintf($lang['msgo_is_off'], $extras[$enable]['name']), '', 1]]);
        } else {
            ngSYSLOG(['plugin' => '#admin', 'item' => 'extras'], ['action' => 'switch_on', 'list' => ['plugin' => $disable]], null, [0, 'ERROR: ' . $disable]);
            msgSticker([[sprintf('ERROR: ' . $lang['msgo_is_off'], $extras[$enable]['name']), 'error', 1]]);
            //msg(array("text" => 'ERROR: '.sprintf($lang['msgo_is_off'], $extras[$id]['name'])));
        }
    }
}

$main_admin = admGeneratePluginList();