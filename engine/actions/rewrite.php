<?php
//
// Copyright (C) 2006-2014 Next Generation CMS (http://ngcms.org/)
// Name: rewrite.php
// Description: Managing rewrite rules
// Author: Vitaly Ponomarev
//
// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}
// Check for permissions
if (!checkPermission(['plugin' => '#admin', 'item' => 'rewrite'], null, 'details')) {
    msg(['type' => 'error', 'text' => $lang['perm.denied']], 1, 1);
    ngSYSLOG(['plugin' => '#admin', 'item' => 'rewrite'], ['action' => 'details'], null, [0, 'SECURITY.PERM']);
    return false;
}
@include_once 'includes/classes/uhandler.class.php';
$ULIB = new urlLibrary();
$ULIB->loadConfig();
$UH = new urlHandler();
$UH->loadConfig();
$lang = LoadLang('rewrite', 'admin');
// ================================================================
// Handlers for new REWRITE format
// ================================================================
//
// Generate list of supported commands [ config ]
//
$jconfig = [];
foreach ($ULIB->CMD as $plugin => $crow) {
    foreach ($crow as $cmd => $param) {
        $jconfig[$plugin][$cmd] = ['vars' => [], 'descr' => $ULIB->extractLangRec($param['descr'])];
        foreach ($param['vars'] as $vname => $vdata) {
            $jconfig[$plugin][$cmd]['vars'][$vname] = $ULIB->extractLangRec($vdata['descr']);
        }
    }
}
//
// Generate list of active rules [ data ]
//
error_log("REWRITE: hList count = " . count($UH->hList));
error_log("REWRITE: configLoaded = " . ($UH->configLoaded ? 'true' : 'false'));
if (count($UH->hList) > 0) {
    error_log("REWRITE: First key = " . array_key_first($UH->hList));
    $firstItem = $UH->hList[array_key_first($UH->hList)];
    error_log("REWRITE: First item is_array = " . (is_array($firstItem) ? 'yes' : 'no'));
    if (is_array($firstItem)) {
        error_log("REWRITE: First item keys = " . implode(', ', array_keys($firstItem)));
        error_log("REWRITE: First item pluginName = " . ($firstItem['pluginName'] ?? 'NONE'));
    }
}
error_log("REWRITE: Starting foreach loop...");
$recno = 0;
$jdata = [];
foreach ($UH->hList as $hRecord) {
    error_log("REWRITE: Processing record #$recno, pluginName=" . ($hRecord['pluginName'] ?? 'NONE'));
    $jrow = [
        'id'               => $recno,
        'pluginName'       => $hRecord['pluginName'] ?? '',
        'handlerName'      => $hRecord['handlerName'] ?? '',
        'regex'            => $hRecord['rstyle']['rcmd'] ?? '',
        'flagPrimary'      => $hRecord['flagPrimary'] ?? false,
        'flagFailContinue' => $hRecord['flagFailContinue'] ?? false,
        'flagDisabled'     => $hRecord['flagDisabled'] ?? false,
        'setVars'          => $hRecord['rstyle']['setVars'] ?? [],
    ];
    // Fetch associated command
    if ($cmd = $ULIB->fetchCommand($jrow['pluginName'], $jrow['handlerName'])) {
        $jrow['description'] = $ULIB->extractLangRec($cmd['descr']);
    } else {
        $jrow['description'] = '';
    }
    // Format flags for display
    $flags = [];
    if ($jrow['flagPrimary']) $flags[] = 'Primary';
    if ($jrow['flagFailContinue']) $flags[] = 'FailContinue';
    if ($jrow['flagDisabled']) $flags[] = 'Disabled';
    $jrow['flags'] = implode(', ', $flags);
    $jdata[] = $jrow;
    $recno++;
}
// Render template with Twig (entry.tpl uses {% verbatim %} block to preserve JS placeholders)
$xe = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/rewrite/entry.tpl');
$templateRendered = $xe->render([]);
$tVars = [
    'json'  => [
        'config'   => json_encode($jconfig),
        'data'     => json_encode($jdata),
        'template' => json_encode($templateRendered),
    ],
    'token' => genUToken('admin.rewrite'),
];
$xt = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/rewrite.tpl');
$main_admin = $xt->render($tVars);
//$UH->populateHandler($ULIB, array('pluginName' => 'news', 'handlerName' => 'by.day', 'regex' => '/{year}-{month}-{day}[-page{page}].html'));
