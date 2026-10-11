<?php
//
// Copyright (C) 2006-2012 Next Generation CMS (http://ngcms.org/)
// Name: extra-config.php
// Description: Plugin managment
// Author: Vitaly Ponomarev
//
// Protect against hack attempts
if (!defined('NGCMS')) {
    exit('HAL');
}
@include_once root . 'includes/inc/extraconf.inc.php';
@include_once root . 'includes/inc/extrainst.inc.php';
// ==============================================================
//  Main module code
// ==============================================================
// Load lang files
$lang = LoadLang('extra-config', 'admin');
// Load plugin list
$extras = pluginsGetList();
// Load passed variables:
// ID of called plugin
$plugin = $_REQUEST['plugin'];
// Type of script to call  ( install / deinstall / config )
$stype = isset($_REQUEST['stype']) ? $_REQUEST['stype'] : '';
if (!is_array($extras[$plugin])) {
    $tVars = [
        'action'      => $lang['config_text'],
        'action_text' => $lang['noplugin'],
        'plugin'      => $plugin,
        'php_self'    => $PHP_SELF,
    ];
    $xt = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/extra-config/nomodule.tpl');
    $main_admin = $xt->render($tVars);
} else {
    //
    // Call 'install'/'deinstall' script if it's requested. Else - call config script.
    if (($stype != 'install') && ($stype != 'deinstall')) {
        $stype = 'config';
    }
    // Fetch the name of corresponding configuration file
    $cfg_file = extras_dir . '/' . $extras[$plugin]['dir'] . '/' . $extras[$plugin][$stype];
    // Check if such type of script is configured in plugin & exists
    if (is_array($extras[$plugin]) && ($extras[$plugin][$stype]) && is_file($cfg_file)) {
        // Security update: for stype == 'config' and POST update action - check for token
        if (($stype == 'config') && (isset($_REQUEST['action']) && $_REQUEST['action'] == 'commit') && ($_REQUEST['token'] != genUToken('admin.extra-config'))) {
            msg(['type' => 'error', 'text' => $lang['error.security.token'], 'info' => $lang['error.security.token#desc']]);
            ngSYSLOG(['plugin' => '#admin', 'item' => 'config#' . $plugin], ['action' => 'modify'], null, [0, 'SECURITY.TOKEN']);
            exit;
        }
        //
        // Include required script file
        ob_start();
        @include extras_dir . '/' . $extras[$plugin]['dir'] . '/' . $extras[$plugin][$stype];
        $main_admin .= ob_get_contents();
        ob_end_clean();
        //
        // Run install function if it exists in file
        if (($stype == 'install') && function_exists('plugin_' . $plugin . '_install')) {
            call_user_func('plugin_' . $plugin . '_install', ($_REQUEST['action'] == 'commit') ? 'apply' : 'confirm');
        }
    } else {
        $tVars = [
            'action'      => $lang[$stype . '_text'],
            'action_text' => $lang['nomod_' . $stype],
            'plugin'      => $plugin,
            'php_self'    => $PHP_SELF,
        ];
        $xt = $twig->loadTemplate('skins/' . $config['admin_skin'] . '/tpl/extra-config/nomodule.tpl');
        $main_admin = $xt->render($tVars);
    }
}

if ($stype == 'config' && isset($extras[$plugin]['dir']) && function_exists('plugin_documentation_markup')) {
    list($documentationButton, $documentationModal) = plugin_documentation_markup($plugin, $extras[$plugin]['dir']);
    if ($documentationButton !== '' && strpos($main_admin, 'data-plugin-settings-header') === false) {
        $pluginName = json_encode($plugin, JSON_HEX_TAG | JSON_HEX_APOS | JSON_HEX_AMP | JSON_HEX_QUOT);
        $main_admin = '<div class="card plugin-settings-card">' .
            '<h5 class="card-header d-flex justify-content-between align-items-center" data-plugin-settings-header>' .
            '<span>' . htmlspecialchars($plugin, ENT_QUOTES, 'UTF-8') . '</span>' . $documentationButton . '</h5>' .
            '<div class="card-body plugin-settings-content">' . $main_admin . '</div></div>' .
            $documentationModal .
            '<script>(function(){function normalizePluginSettingsHeading(){' .
            'var content=document.querySelector(".plugin-settings-content");if(!content){return;}' .
            'var title=' . $pluginName . ';' .
            'content.querySelectorAll("h1,h2,h3,h4,h5").forEach(function(heading){' .
            'if(heading.textContent.trim().toLowerCase()===title.toLowerCase()){heading.remove();}});}' .
            'if(document.readyState==="loading"){document.addEventListener("DOMContentLoaded",normalizePluginSettingsHeading);}' .
            'else{normalizePluginSettingsHeading();}})();</script>';
    } elseif (
        $documentationButton !== '' &&
        strpos($main_admin, 'data-plugin-documentation') !== false &&
        strpos($main_admin, 'id="pluginDocumentationModal"') === false
    ) {
        $main_admin .= $documentationModal;
    }
}

if ($stype == 'config' && isset($_SESSION['extra_config_saved']) && $_SESSION['extra_config_saved'] === (string)$plugin) {
    unset($_SESSION['extra_config_saved']);
    msgSticker($lang['commited']);
}
